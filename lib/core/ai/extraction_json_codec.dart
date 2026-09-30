import 'dart:convert';

import 'chatml_sanitizer.dart';
import 'evidence_quote_range.dart';
import 'extraction_kind_slugs.dart';
import 'local_ai_service.dart';

/// Parses on-device model text into typed extraction candidates.
class ExtractionJsonCodec {
  const ExtractionJsonCodec();

  static const _unspecified = {'not stated', 'nicht angegeben', 'none', 'null'};

  /// Locales that write ambiguous numeric dates as day/month (EU / MENA).
  static const _dayMonthLocales = {'de', 'ar'};

  List<ExtractionCandidate> parse(
    String raw,
    String sourceText, {
    String languageCode = 'en',
    Set<String>? enabledKindSlugs,
    Set<String>? slugsAllowingDates,
  }) {
    final locale = languageCode.trim().toLowerCase();
    final allowed = enabledKindSlugs ?? ExtractionKindSlugs.defaultEnabled;
    final datesAllowed = slugsAllowingDates ?? {ExtractionKindSlugs.commitment};
    final decoded = jsonDecode(_extractJsonPayload(raw));
    final items = switch (decoded) {
      final Map map => map['candidates'],
      final List list => list,
      _ => throw const FormatException(
        'Extraction JSON must be an object or array.',
      ),
    };
    if (items is! List) {
      throw const FormatException('Extraction JSON needs a candidates array.');
    }

    final candidates = <ExtractionCandidate>[];
    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      if (item is! Map) continue;
      final parsed = _candidate(
        Map<String, dynamic>.from(item),
        sourceText,
        index,
        locale,
        allowed,
        datesAllowed,
      );
      if (parsed != null) candidates.add(parsed);
    }
    return candidates;
  }

  ExtractionCandidate? _candidate(
    Map<String, dynamic> json,
    String sourceText,
    int index,
    String languageCode,
    Set<String> enabledKindSlugs,
    Set<String> slugsAllowingDates,
  ) {
    final statement = '${json['statement'] ?? ''}'.trim();
    if (statement.isEmpty) return null;

    final kindName = '${json['kind'] ?? ''}'.trim().toLowerCase();
    if (kindName.isEmpty || !enabledKindSlugs.contains(kindName)) {
      return null;
    }
    if (!ExtractionKindSlugs.isValidSlug(kindName)) {
      return null;
    }

    final snippet = _quoteSnippet(json, statement);
    final distinctStatement = _distinctStatement(statement, snippet);
    // Small Arabic 1.5B runs often emit hedging-only extras; drop those.
    if (languageCode == 'ar' && _isSoftCueOnly(distinctStatement, snippet)) {
      return null;
    }

    final offsets = _quoteOffsets(json, sourceText, snippet);

    return ExtractionCandidate(
      id: '$index',
      kind: kindName,
      statement: distinctStatement,
      owner: _optionalText(json['owner']),
      dueDate: slugsAllowingDates.contains(kindName)
          ? _commitmentDueDate(
              json['dueDate'],
              distinctStatement,
              snippet,
              languageCode,
            )
          : null,
      evidence: ExtractionEvidence(
        quoteStart: offsets.start,
        quoteEnd: offsets.end,
        quoteSnippet: snippet,
      ),
    );
  }

  /// Keeps [statement] as a short title distinct from the evidence quote.
  String _distinctStatement(String statement, String snippet) {
    final normalizedStatement = statement.trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    final normalizedSnippet = snippet.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalizedStatement.isEmpty) return statement;
    if (normalizedStatement.toLowerCase() != normalizedSnippet.toLowerCase()) {
      return normalizedStatement;
    }
    return _shortTitleFrom(normalizedStatement);
  }

  String _shortTitleFrom(String text) {
    final words = text
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.length > 8) {
      return '${words.take(8).join(' ')}…';
    }
    if (text.length > 56) {
      return '${text.substring(0, 53).trimRight()}…';
    }
    // Still identical for short quotes — nudge with a compact paraphrase cue.
    if (words.length >= 2) {
      return words.join(' · ');
    }
    return text;
  }

  /// First non-empty quote wins: top-level snippet, nested evidence, then
  /// top-level `quote`, then [statement].
  String _quoteSnippet(Map<String, dynamic> json, String statement) {
    final fromTopLevel = _optionalText(json['quoteSnippet']);
    if (fromTopLevel != null) return fromTopLevel;

    final evidence = json['evidence'];
    if (evidence is Map) {
      final nested = Map<String, dynamic>.from(evidence);
      final fromNested =
          _optionalText(nested['quoteSnippet']) ??
          _optionalText(nested['quote']);
      if (fromNested != null) return fromNested;
    } else {
      final fromEvidenceString = _optionalText(evidence);
      if (fromEvidenceString != null) return fromEvidenceString;
    }

    return _optionalText(json['quote']) ?? statement;
  }

  ({int start, int end}) _quoteOffsets(
    Map<String, dynamic> json,
    String sourceText,
    String snippet,
  ) {
    final evidence = json['evidence'];
    final nested = evidence is Map ? Map<String, dynamic>.from(evidence) : null;
    final start =
        _readInt(json['quoteStart']) ??
        (nested != null ? _readInt(nested['quoteStart']) : null);
    final end =
        _readInt(json['quoteEnd']) ??
        (nested != null ? _readInt(nested['quoteEnd']) : null);
    final resolved = resolveEvidenceQuoteRange(
      content: sourceText,
      quoteStart: start,
      quoteEnd: end,
      quoteSnippet: snippet,
    );
    if (resolved != null) {
      return resolved;
    }
    return (start: 0, end: 0);
  }

  /// Accepts a JSON object, a bare candidates array, or fenced markdown.
  String _extractJsonPayload(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Model output was empty.');
    }

    final fenced = RegExp(
      r'```(?:json)?\s*([\s\S]*?)```',
      caseSensitive: false,
    ).firstMatch(trimmed);
    var candidate = (fenced?.group(1) ?? trimmed).trim();

    // Strip ChatML special tokens that some models append to output.
    candidate = stripChatMLTokens(candidate);

    final objectStart = candidate.indexOf('{');
    final arrayStart = candidate.indexOf('[');
    if (objectStart < 0 && arrayStart < 0) {
      throw const FormatException(
        'Model output did not contain a JSON object or array.',
      );
    }

    final useArray =
        arrayStart >= 0 && (objectStart < 0 || arrayStart < objectStart);
    if (useArray) {
      final end = candidate.lastIndexOf(']');
      if (end <= arrayStart) {
        throw const FormatException('Model output JSON array was truncated.');
      }
      return candidate.substring(arrayStart, end + 1);
    }

    final end = candidate.lastIndexOf('}');
    if (end <= objectStart) {
      throw const FormatException('Model output JSON object was truncated.');
    }
    return candidate.substring(objectStart, end + 1);
  }

  String? _optionalText(Object? value) {
    if (value == null) return null;
    final text = '$value'.trim();
    if (text.isEmpty || _unspecified.contains(text.toLowerCase())) {
      return null;
    }
    return text;
  }

  /// Soft / hedging cues without a hard accept or decide verb → drop.
  /// Helps small models (esp. Arabic) that emit extra maybe-candidates.
  bool _isSoftCueOnly(String statement, String snippet) {
    final blob = '$statement\n$snippet'.toLowerCase();
    if (!_softCue.hasMatch(blob)) return false;
    if (_hardCue.hasMatch(blob)) return false;
    return true;
  }

  /// Commitment due dates: model field first, then statement / quote only.
  /// Never scans the full conversation for a calendar day (wrong-date risk).
  /// Relative deadlines (Friday, next week, EOD, …) stay null.
  DateTime? _commitmentDueDate(
    Object? dueDateJson,
    String statement,
    String snippet,
    String languageCode,
  ) {
    final evidenceText = '$statement\n$snippet';
    if (_isRelativeDeadlineOnly(evidenceText)) return null;

    final yearContext = evidenceText;
    return _optionalDate(dueDateJson, yearContext, languageCode) ??
        _findDateInText(statement, yearContext, languageCode) ??
        _findDateInText(snippet, yearContext, languageCode);
  }

  DateTime? _optionalDate(
    Object? value,
    String yearContext,
    String languageCode,
  ) {
    final text = _optionalText(value);
    if (text == null) return null;
    return _findDateInText(text, yearContext, languageCode);
  }

  /// True when evidence has relative/weekday deadlines and no calendar day.
  bool _isRelativeDeadlineOnly(String text) {
    final lower = text.toLowerCase();
    if (_hasCalendarDay(lower, text)) return false;
    return _relativeDeadline.hasMatch(lower) ||
        (_weekdayMention.hasMatch(lower) && !_monthName.hasMatch(lower));
  }

  bool _hasCalendarDay(String lower, String original) {
    if (_monthDayEnglish.hasMatch(lower) || _dayMonthEnglish.hasMatch(lower)) {
      return true;
    }
    if (_numericDate.hasMatch(original)) return true;
    if (DateTime.tryParse(original.trim()) != null) return true;
    return false;
  }

  /// Parses ISO-8601 or common spoken calendar dates (optional clock time).
  /// Weekday-only / relative words are ignored.
  DateTime? _findDateInText(
    String text,
    String yearContext,
    String languageCode,
  ) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      return DateTime.utc(
        iso.year,
        iso.month,
        iso.day,
        iso.hour,
        iso.minute,
        iso.second,
      );
    }

    final lower = trimmed.toLowerCase();
    if (_weekdayOnly.hasMatch(lower) && !_monthName.hasMatch(lower)) {
      return null;
    }
    if (_isRelativeDeadlineOnly(trimmed)) return null;

    final yearHint = _yearFromText(trimmed) ?? _yearFromText(yearContext);
    final time = _findTimeInText(lower);
    final preferDayMonthLocale = _dayMonthLocales.contains(languageCode);

    final monthDay = _monthDayEnglish.firstMatch(lower);
    if (monthDay != null) {
      final month = _monthNumber(monthDay.group(1)!);
      final day = int.parse(monthDay.group(2)!);
      final y = monthDay.group(3) != null
          ? int.parse(monthDay.group(3)!)
          : yearHint;
      return _dateWithYear(y, month, day, time);
    }

    final dayMonth = _dayMonthEnglish.firstMatch(lower);
    if (dayMonth != null) {
      final day = int.parse(dayMonth.group(1)!);
      final month = _monthNumber(dayMonth.group(2)!);
      final y = dayMonth.group(3) != null
          ? int.parse(dayMonth.group(3)!)
          : yearHint;
      return _dateWithYear(y, month, day, time);
    }

    final numeric = _numericDate.firstMatch(trimmed);
    if (numeric != null) {
      final a = int.parse(numeric.group(1)!);
      final separator = numeric.group(2)!;
      final b = int.parse(numeric.group(3)!);
      final y = numeric.group(4) != null
          ? int.parse(numeric.group(4)!)
          : yearHint;
      // Dot → DD.MM (DE/EU). Slash/dash: day/month for de/ar, month/day for en.
      final preferDayMonth = separator == '.' || a > 12 || preferDayMonthLocale;
      if (preferDayMonth) {
        return _dateWithYear(y, b, a, time);
      }
      if (b > 12) {
        return _dateWithYear(y, a, b, time);
      }
      return _dateWithYear(y, a, b, time);
    }

    return null;
  }

  ({int hour, int minute})? _findTimeInText(String lower) {
    final match =
        _timeAtAmPm.firstMatch(lower) ??
        _timeGermanUhr.firstMatch(lower) ??
        _timeClockOptionalAmPm.firstMatch(lower);
    if (match == null) return null;

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2) ?? '0');
    final meridiem = match.groupCount >= 3
        ? match.group(3)?.replaceAll('.', '').toLowerCase()
        : null;

    if (minute > 59) return null;

    if (meridiem == 'am' || meridiem == 'pm') {
      if (hour < 1 || hour > 12) return null;
      if (meridiem == 'am') {
        hour = hour == 12 ? 0 : hour;
      } else {
        hour = hour == 12 ? 12 : hour + 12;
      }
    } else if (hour > 23) {
      return null;
    }

    return (hour: hour, minute: minute);
  }

  DateTime? _dateWithYear(
    int? year,
    int month,
    int day, [
    ({int hour, int minute})? time,
  ]) {
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    final y = year ?? DateTime.now().toUtc().year;
    final hour = time?.hour ?? 0;
    final minute = time?.minute ?? 0;
    try {
      return DateTime.utc(y, month, day, hour, minute);
    } on ArgumentError {
      return null;
    }
  }

  int? _yearFromText(String text) {
    final match = RegExp(r'\b(20\d{2})\b').firstMatch(text);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  int _monthNumber(String raw) {
    switch (raw.toLowerCase()) {
      case 'jan':
      case 'january':
      case 'januar':
      case 'يناير':
        return 1;
      case 'feb':
      case 'february':
      case 'februar':
      case 'فبراير':
        return 2;
      case 'mar':
      case 'march':
      case 'märz':
      case 'maerz':
      case 'مارس':
        return 3;
      case 'apr':
      case 'april':
      case 'أبريل':
      case 'ابريل':
        return 4;
      case 'may':
      case 'mai':
      case 'مايو':
        return 5;
      case 'jun':
      case 'june':
      case 'juni':
      case 'يونيو':
        return 6;
      case 'jul':
      case 'july':
      case 'juli':
      case 'يوليو':
        return 7;
      case 'aug':
      case 'august':
      case 'أغسطس':
      case 'اغسطس':
        return 8;
      case 'sep':
      case 'sept':
      case 'september':
      case 'سبتمبر':
        return 9;
      case 'oct':
      case 'october':
      case 'oktober':
      case 'أكتوبر':
      case 'اكتوبر':
        return 10;
      case 'nov':
      case 'november':
      case 'نوفمبر':
        return 11;
      case 'dec':
      case 'december':
      case 'dezember':
      case 'ديسمبر':
        return 12;
      default:
        return 0;
    }
  }

  static const _monthToken =
      r'jan(?:uary|uar)?|يناير|feb(?:ruary|ruar)?|فبراير|m(?:ar(?:ch)?|ärz|aerz)|مارس|apr(?:il)?|أبريل|ابريل|may|mai|مايو|jun(?:e|i)?|يونيو|jul(?:y|i)?|يوليو|aug(?:ust)?|أغسطس|اغسطس|sep(?:t(?:ember)?)?|سبتمبر|oct(?:ober)?|oktober|أكتوبر|اكتوبر|nov(?:ember)?|نوفمبر|dec(?:ember)?|dezember|ديسمبر';

  static final _weekdayOnly = RegExp(
    r'^\s*(mon|monday|tue|tues|tuesday|wed|wednesday|thu|thur|thurs|thursday|fri|friday|sat|saturday|sun|sunday|montag|dienstag|mittwoch|donnerstag|freitag|samstag|sonntag|الاثنين|الثلاثاء|الأربعاء|الخميس|الجمعة|السبت|الأحد)\s*$',
    caseSensitive: false,
    unicode: true,
  );

  static final _weekdayMention = RegExp(
    r'\b(mon|monday|tue|tues|tuesday|wed|wednesday|thu|thur|thurs|thursday|fri|friday|sat|saturday|sun|sunday|montag|dienstag|mittwoch|donnerstag|freitag|samstag|sonntag)\b|الاثنين|الثلاثاء|الأربعاء|الخميس|الجمعة|السبت|الأحد',
    caseSensitive: false,
    unicode: true,
  );

  /// Relative / unresolved deadlines — stay null (Ledger needs a calendar day).
  static final _relativeDeadline = RegExp(
    r'\b('
    r'next\s+(week|month|monday|tuesday|wednesday|thursday|friday|saturday|sunday)|'
    r'this\s+(week|monday|tuesday|wednesday|thursday|friday|saturday|sunday)|'
    r'end\s+of\s+(day|week|month)|'
    r'eod|eob|cob|'
    r'in\s+\d+\s+(day|days|week|weeks|month|months)|'
    r'nächste\s+woche|nächsten?\s+\w+|ende\s+der\s+woche|ende\s+des\s+tages|'
    r'übermorgen|uebermorgen'
    r')\b|'
    r'الأسبوع\s+القادم|نهاية\s+اليوم|غداً|غدا|بعد\s+غدا',
    caseSensitive: false,
    unicode: true,
  );

  static final _softCue = RegExp(
    r'\b(maybe|might|could|perhaps|possibly|vielleicht|eventuell|möglicherweise|moeglicherweise)\b|'
    r'\bkönnte\b|\bkoennte\b|'
    r'ربما|ممكن\b|قد\s',
    caseSensitive: false,
    unicode: true,
  );

  static final _hardCue = RegExp(
    r'\b('
    r'committed|commitment|will\s+deliver|will\s+draft|will\s+send|decided|decision|'
    r'explicitly|officially|'
    r'verpflichtet|zugesagt|entschieden|liefert|werde\s+ich|'
    r'offiziell'
    r')\b|'
    r'التزم|قرر|قررنا|سيسلّم|سيسلم|سأجهّز|ساجهز',
    caseSensitive: false,
    unicode: true,
  );

  static final _monthName = RegExp(
    '(?:$_monthToken)',
    caseSensitive: false,
    unicode: true,
  );

  /// November the 7th, 15. Oktober, Oct 15th, 15 أكتوبر
  static final _monthDayEnglish = RegExp(
    '(?<![A-Za-z0-9_])($_monthToken)\\s+(?:the\\s+)?(\\d{1,2})(?:st|nd|rd|th)?(?:\\s*,?\\s*(20\\d{2}))?(?![A-Za-z0-9_])',
    caseSensitive: false,
    unicode: true,
  );

  /// 15 October, 15. Oktober, the 7th of November, 15 أكتوبر
  static final _dayMonthEnglish = RegExp(
    '(?<![A-Za-z0-9_])(?:the\\s+)?(\\d{1,2})(?:\\.|st|nd|rd|th)?(?:\\s+of)?\\s+($_monthToken)(?![A-Za-z0-9_])(?:\\s*,?\\s*(20\\d{2}))?',
    caseSensitive: false,
    unicode: true,
  );

  /// 20.05.2026 (DE), 10/15/2026 (US), 15.10., 10-15
  static final _numericDate = RegExp(
    r'\b(\d{1,2})([./-])(\d{1,2})(?:\2(20\d{2}))?\b',
  );

  /// at 5 PM, at 5:30 p.m., at 17:00
  static final _timeAtAmPm = RegExp(
    r'\bat\s+(\d{1,2})(?::(\d{2}))?\s*(a\.?m\.?|p\.?m\.?)?\b',
    caseSensitive: false,
  );

  /// um 17 Uhr, um 17:30 Uhr
  static final _timeGermanUhr = RegExp(
    r'\bum\s+(\d{1,2})(?::(\d{2}))?\s*uhr\b',
    caseSensitive: false,
  );

  /// 5:30 PM, 17:00
  static final _timeClockOptionalAmPm = RegExp(
    r'\b(\d{1,2}):(\d{2})\s*(a\.?m\.?|p\.?m\.?)?\b',
    caseSensitive: false,
  );

  int? _readInt(Object? value) {
    if (value is int) return value;
    return int.tryParse('$value');
  }
}
