import 'dart:convert';

import 'package:http/http.dart' as http;

/// Result of fetching a webpage and reducing it to extractable plain text.
class WebpageTextResult {
  const WebpageTextResult({
    required this.url,
    required this.title,
    required this.text,
  });

  final String url;
  final String? title;
  final String text;
}

/// Fetches a public http(s) page and extracts main readable text.
///
/// Used when Capture receives a bare URL (share or typed) so extraction sees
/// article/body content instead of only the link.
abstract interface class WebpageTextFetcher {
  Future<WebpageTextResult> fetchMainText(Uri url);
}

/// True when [raw] is a single http(s) URL (optional surrounding whitespace).
bool looksLikeHttpUrl(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty || trimmed.contains(RegExp(r'\s'))) return false;
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;
  final scheme = uri.scheme.toLowerCase();
  return scheme == 'http' || scheme == 'https';
}

Uri? parseHttpUrl(String raw) {
  if (!looksLikeHttpUrl(raw)) return null;
  return Uri.parse(raw.trim());
}

class HttpWebpageTextFetcher implements WebpageTextFetcher {
  HttpWebpageTextFetcher({http.Client? client, this.maxBytes = 1_500_000})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;
  final int maxBytes;

  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }

  @override
  Future<WebpageTextResult> fetchMainText(Uri url) async {
    if (url.scheme != 'http' && url.scheme != 'https') {
      throw const WebpageFetchException('unsupported_scheme');
    }

    final response = await _client
        .get(
          url,
          headers: const {
            'Accept': 'text/html,application/xhtml+xml;q=0.9,*/*;q=0.8',
            'User-Agent':
                'Quorivell/1.0 (local capture; +https://quorivell.app)',
          },
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw WebpageFetchException('http_${response.statusCode}');
    }

    final bytes = response.bodyBytes;
    if (bytes.length > maxBytes) {
      throw const WebpageFetchException('too_large');
    }

    final contentType = response.headers['content-type'] ?? '';
    if (contentType.isNotEmpty &&
        !contentType.contains('html') &&
        !contentType.contains('text/plain') &&
        !contentType.contains('xml')) {
      throw const WebpageFetchException('unsupported_type');
    }

    final html = utf8.decode(bytes, allowMalformed: true);
    final extracted = extractMainTextFromHtml(html);
    if (extracted.text.trim().isEmpty) {
      throw const WebpageFetchException('empty_content');
    }
    return WebpageTextResult(
      url: url.toString(),
      title: extracted.title,
      text: extracted.text,
    );
  }
}

class WebpageFetchException implements Exception {
  const WebpageFetchException(this.code);

  final String code;

  @override
  String toString() => 'WebpageFetchException($code)';
}

({String? title, String text}) extractMainTextFromHtml(String html) {
  var working = html;

  // Drop non-content blocks early.
  working = working.replaceAll(
    RegExp(r'<script[\s\S]*?</script>', caseSensitive: false),
    ' ',
  );
  working = working.replaceAll(
    RegExp(r'<style[\s\S]*?</style>', caseSensitive: false),
    ' ',
  );
  working = working.replaceAll(
    RegExp(r'<noscript[\s\S]*?</noscript>', caseSensitive: false),
    ' ',
  );
  working = working.replaceAll(RegExp(r'<!--[\s\S]*?-->'), ' ');

  final title = _firstGroup(
    RegExp(r'<title[^>]*>([\s\S]*?)</title>', caseSensitive: false),
    working,
  );

  String? region;
  for (final pattern in [
    RegExp(r'<article\b[^>]*>([\s\S]*?)</article>', caseSensitive: false),
    RegExp(r'<main\b[^>]*>([\s\S]*?)</main>', caseSensitive: false),
    RegExp(
      r'''<div[^>]+(?:role=["']main["']|itemprop=["']articleBody["'])[^>]*>([\s\S]*?)</div>''',
      caseSensitive: false,
    ),
  ]) {
    region = _firstGroup(pattern, working);
    if (region != null && region.trim().length > 80) break;
    region = null;
  }

  final body =
      region ??
      _firstGroup(
        RegExp(r'<body\b[^>]*>([\s\S]*?)</body>', caseSensitive: false),
        working,
      ) ??
      working;

  final text = _htmlToPlainText(body);
  final titleText = title == null ? null : _htmlToPlainText(title);
  final combined = [
    if (titleText != null && titleText.isNotEmpty) titleText,
    text,
  ].join('\n\n').trim();

  return (title: titleText, text: _clampText(combined));
}

String? _firstGroup(RegExp pattern, String input) {
  final match = pattern.firstMatch(input);
  return match?.group(1);
}

String _htmlToPlainText(String input) {
  var text = input;
  text = text.replaceAll(
    RegExp(r'<(br|/p|/div|/li|/h[1-6]|/tr)[^>]*>', caseSensitive: false),
    '\n',
  );
  text = text.replaceAll(RegExp(r'<[^>]+>'), ' ');
  text = text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll(RegExp(r'&#(\d+);'), ' ')
      .replaceAll(RegExp(r'&[a-zA-Z]+;'), ' ');
  text = text.replaceAll(RegExp(r'[ \t\f\v]+'), ' ');
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return text.trim();
}

String _clampText(String text, {int maxChars = 48000}) {
  if (text.length <= maxChars) return text;
  return text.substring(0, maxChars).trim();
}
