// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كوريڤيل';

  @override
  String get appBootLoadingSemantics => 'جارٍ تحميل كوريڤيل';

  @override
  String get loadingSemantics => 'جارٍ التحميل';

  @override
  String get navCapture => 'التقاط';

  @override
  String get navReview => 'مراجعة';

  @override
  String navReviewPendingSemantics(int count) {
    return 'مراجعة، $count معلّق';
  }

  @override
  String get navLedger => 'السجل';

  @override
  String get navAccount => 'الحساب';

  @override
  String get navChat => 'محادثة';

  @override
  String navChatUnreadSemantics(int count) {
    return 'محادثة، $count غير مقروء';
  }

  @override
  String get captureHeadline => 'التقاط محادثة مصدر';

  @override
  String get captureSubtitle =>
      'احتفظ بالصياغة الأصلية محلياً. يمكنك مراجعة الأدلة قبل أن يصبح أي شيء عنصراً في السجل.';

  @override
  String get captureFieldLabel => 'نص المحادثة';

  @override
  String get captureFieldHint => 'الصق أو اكتب المحادثة التقريبية هنا';

  @override
  String get captureSaveButton => 'حفظ محلياً';

  @override
  String get captureSavingButton => 'جارٍ الحفظ...';

  @override
  String get captureValidationError => 'أدخل نص محادثة قبل الحفظ.';

  @override
  String get captureHistoryTooltip => 'عرض المحادثات السابقة';

  @override
  String get captureShareBannerTitle => 'نص مُشارَك جاهز للحفظ';

  @override
  String get captureShareBannerBody =>
      'احفظه كمحادثة مصدر محلية أو تجاهله. المشاركة لا تستخرج ولا تزامن.‏';

  @override
  String get captureShareDiscardButton => 'تجاهل';

  @override
  String get conversationHistoryTitle => 'المحادثات السابقة';

  @override
  String get conversationHistoryEmpty => 'لم يتم التقاط أي محادثات بعد.';

  @override
  String get conversationHistoryFilterActive => 'نشط';

  @override
  String get conversationHistoryFilterArchived => 'مؤرشف';

  @override
  String get conversationHistoryEmptyArchived => 'لا توجد محادثات مؤرشفة.';

  @override
  String get conversationHistoryEmptyArchivedSubtitle =>
      'تنتقل المحادثات إلى هنا بعد استخراج الأنواع التي فعّلتها منها.‏';

  @override
  String get conversationHistoryArchivedBadge => 'مؤرشف';

  @override
  String get conversationHistoryUnavailable => 'سجل المحادثات غير متاح.';

  @override
  String get conversationDetailTitle => 'محادثة';

  @override
  String get conversationDetailNotFound => 'هذه المحادثة لم تعد متاحة.';

  @override
  String get conversationDetailUnavailable => 'المحادثة غير متاحة.';

  @override
  String get conversationDeleteTitle => 'حذف هذه المحادثة؟';

  @override
  String get conversationDeleteBody =>
      'يؤدي ذلك إلى إزالة المحادثة من سجلك على هذا الجهاز. لا يمكن التراجع عن ذلك.';

  @override
  String get conversationDeleteBodyWithLedgerLinks =>
      'يؤدي ذلك إلى إزالة المحادثة من سجلك على هذا الجهاز. لن يعود بإمكان القرارات والالتزامات المرتبطة فتح الدليل الأصلي. لا يمكن التراجع عن ذلك.‏';

  @override
  String get conversationDeleteConfirm => 'حذف';

  @override
  String get conversationDeleteCancel => 'إلغاء';

  @override
  String get conversationDeleteTooltip => 'حذف المحادثة';

  @override
  String get conversationDeleteFailed => 'تعذّر حذف المحادثة. حاول مرة أخرى.';

  @override
  String conversationBulkDeleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $count محادثة؟‏',
      many: 'حذف $count محادثة؟‏',
      few: 'حذف $count محادثات؟‏',
      two: 'حذف هاتين المحادثتين؟‏',
      one: 'حذف هذه المحادثة؟‏',
    );
    return '$_temp0';
  }

  @override
  String get conversationBulkDeleteBody =>
      'يؤدي ذلك إلى إزالة المحادثات المحددة من سجلك على هذا الجهاز. لا يمكن التراجع عن ذلك.‏';

  @override
  String get conversationBulkDeleteBodyWithLedgerLinks =>
      'يؤدي ذلك إلى إزالة المحادثات المحددة من سجلك على هذا الجهاز. لن يعود بإمكان القرارات والالتزامات المرتبطة فتح الدليل الأصلي. لا يمكن التراجع عن ذلك.‏';

  @override
  String get conversationBulkDeleteFailed =>
      'تعذّر حذف المحادثات المحددة. حاول مرة أخرى.‏';

  @override
  String get reviewUnavailable => 'قائمة المراجعة غير متاحة.';

  @override
  String get reviewCaptureFirstError => 'التقط محادثة مصدر أولاً.';

  @override
  String get reviewEmptyTitle => 'لا توجد مرشحات بانتظار المراجعة.';

  @override
  String get reviewEmptySubtitle =>
      'استخرج العناصر الصريحة للأنواع التي فعّلتها من آخر التقاط محلي.‏';

  @override
  String get reviewEmptyNoCaptureTitle => 'التقط محادثة أولاً.';

  @override
  String get reviewEmptyNoCaptureSubtitle =>
      'يعمل الاستخراج فقط على الالتقاطات النشطة. أضف محادثة جديدة ثم عد إلى هنا للاستخراج.';

  @override
  String get reviewExtractButton => 'استخراج';

  @override
  String get reviewGoToCaptureButton => 'الانتقال إلى التقاط';

  @override
  String get reviewCompleteTitle => 'انتهيت من المراجعة';

  @override
  String get reviewCompleteSubtitle => 'جاري فتح السجل…';

  @override
  String get reviewCompleteGoToLedger => 'عرض السجل';

  @override
  String get reviewNoCandidatesFound =>
      'لم يُعثر على قرارات أو التزامات صريحة في الالتقاط/الالتقاطات المحددة.‏';

  @override
  String get extractChooserTitle => 'ماذا تريد استخراجه؟‏';

  @override
  String get extractChooserSubtitle =>
      'يُستخرج كل التقاط نشط على حدة. تُتخطى الالتقاطات المؤرشفة.‏';

  @override
  String get extractChooserAllTitle => 'كل المحادثات النشطة‏';

  @override
  String extractChooserAllSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'استخراج $count التقاطات من الأقدم إلى الأحدث',
      one: 'استخراج التقاط واحد من الأقدم إلى الأحدث',
    );
    return '$_temp0';
  }

  @override
  String get extractChooserPickTitle => 'اختيار محادثة‏';

  @override
  String get extractChooserPickSubtitle => 'استخراج التقاط نشط واحد فقط‏';

  @override
  String get extractChooserPickListTitle => 'اختر التقاطاً‏';

  @override
  String get extractChooserBack => 'رجوع‏';

  @override
  String get extractChooserCancel => 'إلغاء‏';

  @override
  String extractChooserConversationSemantics(String preview, String date) {
    return 'التقاط: $preview. تم التحديث $date.‏';
  }

  @override
  String extractionProgressConversation(int current, int total) {
    return 'المحادثة $current من $total';
  }

  @override
  String get reviewEmptyExtractExampleTitle => 'لا شيء صريح لاستخراجه';

  @override
  String get reviewEmptyExtractExampleBody =>
      'يحتفظ كوريڤيل فقط بالعناصر التي تطابق الأنواع التي فعّلتها. التقط صياغة كهذه، وتصبح العبارات المميزة مرشحات للمراجعة.‏';

  @override
  String get reviewEmptyExtractExampleCaption => 'مثال على التقاط';

  @override
  String get reviewEmptyExtractExampleCommitmentSentence =>
      'خلال مزامنة اليوم، التزم أليكس صراحةً بتسليم وثائق واجهة البرمجة بحلول 15 أكتوبر.';

  @override
  String get reviewEmptyExtractExampleCommitmentSpan =>
      'التزم أليكس صراحةً بتسليم وثائق واجهة البرمجة بحلول 15 أكتوبر';

  @override
  String get reviewEmptyExtractExampleDecisionSentence =>
      'قيّمنا تصميمين للصفحة الرئيسية، وقرر الفريق رسمياً المضي قدماً بالخيار أ.';

  @override
  String get reviewEmptyExtractExampleDecisionSpan =>
      'قرر الفريق رسمياً المضي قدماً بالخيار أ';

  @override
  String get reviewEmptyExtractExampleSkippedSentence =>
      'ذكر مارك أنه قد ينظر في مشاكل أداء قاعدة البيانات، لكن لم يُقدَّم التزام رسمي.';

  @override
  String get reviewEmptyExtractExampleSkippedSpan =>
      'ذكر مارك أنه قد ينظر في مشاكل أداء قاعدة البيانات';

  @override
  String get reviewEmptyExtractExampleSkippedLabel => 'لم يُستخرج';

  @override
  String reviewEmptyExtractExampleCustomSentence(String kindName) {
    return 'في الملاحظات سجّلوا بوضوح أغراضاً لهذا النوع: حليب وبيض وخبز — $kindName.‏';
  }

  @override
  String get reviewEmptyExtractExampleCustomSpan => 'حليب وبيض وخبز';

  @override
  String get reviewCandidateStatementLabel => 'بيان المرشح';

  @override
  String reviewEvidenceLabel(String quote) {
    return 'الدليل: «$quote»';
  }

  @override
  String get reviewDebugSourceJson => 'مصدر JSON‏';

  @override
  String get reviewDebugCopySourceJson => 'نسخ JSON‏';

  @override
  String get reviewDebugSourceJsonCopied => 'تم نسخ مصدر JSON.‏';

  @override
  String ownerLabel(String owner) {
    return 'المالك: $owner';
  }

  @override
  String get reviewAcceptButton => 'قبول';

  @override
  String get reviewSetDueDateOptional => 'تحديد موعد استحقاق (اختياري)';

  @override
  String get reviewDueDateDialogTitle => 'تحديد موعد الاستحقاق';

  @override
  String get reviewDueDateDialogDateLabel => 'التاريخ (اختياري)';

  @override
  String get reviewDueDateDialogTimeLabel => 'الوقت (اختياري)';

  @override
  String get reviewDueDateDialogSave => 'حفظ';

  @override
  String get reviewDueDateDialogCancel => 'إلغاء';

  @override
  String get reviewDueDateDialogClear => 'مسح التاريخ‏';

  @override
  String get reviewRejectButton => 'رفض';

  @override
  String get reviewRejectedHistoryTooltip =>
      'عرض الاقتراحات المرفوضة وسجل الاستخراج‏';

  @override
  String get reviewRejectedHistoryTitle => 'سجل المراجعة‏';

  @override
  String get reviewRejectedHistoryEmpty => 'لا توجد اقتراحات مرفوضة.';

  @override
  String get reviewRejectedHistoryEmptySubtitle =>
      'تظهر الاقتراحات التي ترفضها هنا حتى تتمكن من مراجعتها أو حذفها لاحقاً.';

  @override
  String get reviewRejectedHistoryUnavailable =>
      'الاقتراحات المرفوضة غير متاحة.';

  @override
  String get reviewRejectedBadge => 'مرفوض';

  @override
  String get reviewRejectedDeleteTitle => 'حذف هذا الاقتراح؟';

  @override
  String get reviewRejectedDeleteBody =>
      'يؤدي ذلك إلى إزالة الاقتراح من سجلك على هذا الجهاز. لا يمكن التراجع عن ذلك.';

  @override
  String get reviewRejectedDeleteConfirm => 'حذف';

  @override
  String get reviewRejectedDeleteCancel => 'إلغاء';

  @override
  String get reviewRejectedDeleteFailed => 'تعذّر حذف الاقتراح. حاول مرة أخرى.';

  @override
  String reviewRejectedBulkDeleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $count اقتراح؟‏',
      many: 'حذف $count اقتراحاً؟‏',
      few: 'حذف $count اقتراحات؟‏',
      two: 'حذف هذين الاقتراحين؟‏',
      one: 'حذف هذا الاقتراح؟‏',
    );
    return '$_temp0';
  }

  @override
  String get reviewRejectedBulkDeleteBody =>
      'يؤدي ذلك إلى إزالة الاقتراحات المحددة من سجلك على هذا الجهاز. لا يمكن التراجع عن ذلك.‏';

  @override
  String get reviewRejectedBulkDeleteFailed =>
      'تعذّر حذف الاقتراحات المحددة. حاول مرة أخرى.‏';

  @override
  String extractionHistoryBulkDeleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $count عملية استخراج؟‏',
      many: 'حذف $count عملية استخراج؟‏',
      few: 'حذف $count عمليات استخراج؟‏',
      two: 'حذف عمليتي الاستخراج هاتين؟‏',
      one: 'حذف عملية الاستخراج هذه؟‏',
    );
    return '$_temp0';
  }

  @override
  String get extractionHistoryBulkDeleteBody =>
      'يؤدي ذلك إلى إزالة عمليات الاستخراج المحددة من سجلك على هذا الجهاز. لا يمكن التراجع عن ذلك.‏';

  @override
  String get extractionHistoryBulkDeleteFailed =>
      'تعذّر حذف عمليات الاستخراج المحددة. حاول مرة أخرى.‏';

  @override
  String get extractionHistoryDeleteTitle => 'حذف عملية الاستخراج هذه؟‏';

  @override
  String get extractionHistoryDeleteBody =>
      'يؤدي ذلك إلى إزالة عملية الاستخراج من سجلك على هذا الجهاز. لا يمكن التراجع عن ذلك.‏';

  @override
  String get extractionHistoryDeleteConfirm => 'حذف‏';

  @override
  String get extractionHistoryDeleteCancel => 'إلغاء‏';

  @override
  String get extractionHistoryDeleteFailed =>
      'تعذّر حذف عملية الاستخراج. حاول مرة أخرى.‏';

  @override
  String get reviewRejectedAcceptTitle => 'قبول الاقتراح‏';

  @override
  String get reviewRejectedAcceptSuccess => 'أُضيف الاقتراح إلى سجلك.‏';

  @override
  String get reviewRejectedAcceptFailed =>
      'تعذّر قبول الاقتراح. حاول مرة أخرى.‏';

  @override
  String get reviewRejectedTabTitle => 'مرفوض‏';

  @override
  String get extractionHistoryTabTitle => 'السجل‏';

  @override
  String get extractionHistoryEmpty => 'لا توجد عمليات استخراج بعد.‏';

  @override
  String get extractionHistoryEmptySubtitle =>
      'يُظهر سجل الاستخراج المدة التي استغرقتها كل عملية، والنموذج المُستخدم، وعدد النتائج المُستخرجة.‏';

  @override
  String get extractionHistoryUnavailable => 'سجل الاستخراج غير متاح.‏';

  @override
  String extractionHistoryCompletedAt(String timestamp) {
    return 'اكتملت $timestamp‏';
  }

  @override
  String extractionHistoryDuration(String seconds) {
    return 'استغرقت ${seconds}s‏';
  }

  @override
  String extractionHistoryDecisionCount(int count) {
    return '$count قرارات‏';
  }

  @override
  String extractionHistoryCommitmentCount(int count) {
    return '$count التزامات‏';
  }

  @override
  String extractionHistoryAcceptedCount(int count) {
    return '$count مقبولة‏';
  }

  @override
  String extractionHistoryRejectedCount(int count) {
    return '$count مرفوضة‏';
  }

  @override
  String extractionHistoryPendingCount(int count) {
    return '$count معلّقة‏';
  }

  @override
  String get extractionHistoryStatusSuccess => 'نجحت‏';

  @override
  String get extractionHistoryStatusFailure => 'فشلت‏';

  @override
  String get reviewKindDecision => 'قرار';

  @override
  String get reviewKindCommitment => 'التزام';

  @override
  String get reviewKindToggleSemantics => 'تغيير نوع المرشح‏';

  @override
  String get ledgerUnavailable => 'السجل غير متاح.';

  @override
  String get ledgerEmpty => 'لا توجد التزامات مفتوحة.';

  @override
  String get ledgerEmptyStartTitle => 'سجلك جاهز.';

  @override
  String get ledgerEmptyStartSubtitle =>
      'التقط محادثة لاستخراج الأنواع التي فعّلتها، أو أضف عنصراً بنفسك.‏';

  @override
  String get ledgerEmptyGoToCapture => 'التقاط محادثة';

  @override
  String get ledgerEmptyAll => 'لا يوجد شيء في السجل بعد.';

  @override
  String get ledgerEmptyAllSubtitle =>
      'ستظهر هنا القرارات والالتزامات المقبولة أو المضافة.‏';

  @override
  String get ledgerEmptyDecisions => 'لا توجد قرارات بعد.';

  @override
  String get ledgerEmptyDecisionsSubtitle =>
      'ستظهر هنا القرارات المقبولة أو المضافة.‏';

  @override
  String get ledgerEmptyCompleted => 'لا توجد التزامات مكتملة.';

  @override
  String get ledgerEmptyCompletedSubtitle =>
      'سجّل إنجاز الالتزامات المفتوحة لنقلها إلى هنا.';

  @override
  String get ledgerNoMatches => 'لا توجد عناصر سجل مطابقة.';

  @override
  String get ledgerSearchLabel => 'البحث في السجل';

  @override
  String get ledgerSearchClearTooltip => 'مسح البحث';

  @override
  String get ledgerSearchNoMatchesSubtitle => 'جرّب مصطلح بحث مختلفاً';

  @override
  String ledgerOpenCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count التزام مفتوح',
      many: '$count التزاماً مفتوحاً',
      few: '$count التزامات مفتوحة',
      two: 'التزامان مفتوحان',
      one: 'التزام مفتوح واحد',
      zero: 'لا التزامات مفتوحة',
    );
    return '$_temp0';
  }

  @override
  String ledgerCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count التزام مكتمل',
      many: '$count التزاماً مكتملاً',
      few: '$count التزامات مكتملة',
      two: 'التزامان مكتملان',
      one: 'التزام مكتمل واحد',
      zero: 'لا التزامات مكتملة',
    );
    return '$_temp0';
  }

  @override
  String ledgerDecisionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قرار',
      many: '$count قراراً',
      few: '$count قرارات',
      two: 'قراران',
      one: 'قرار واحد',
      zero: 'لا قرارات',
    );
    return '$_temp0';
  }

  @override
  String ledgerItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر سجل',
      many: '$count عنصراً في السجل',
      few: '$count عناصر سجل',
      two: 'عنصرا سجل',
      one: 'عنصر سجل واحد',
      zero: 'لا عناصر سجل',
    );
    return '$_temp0';
  }

  @override
  String get ledgerFilterAll => 'الكل';

  @override
  String get ledgerFilterDecisions => 'القرارات';

  @override
  String get ledgerFilterCommitments => 'الالتزامات';

  @override
  String get ledgerFilterOpen => 'مفتوح';

  @override
  String get ledgerFilterCompleted => 'منجز';

  @override
  String get ledgerStatusOpen => 'مفتوح';

  @override
  String get ledgerStatusCompleted => 'منجز';

  @override
  String ledgerDueDateLabel(String date) {
    return 'الاستحقاق $date';
  }

  @override
  String get ledgerDeleteTitle => 'إزالة عنصر السجل هذا؟';

  @override
  String get ledgerDeleteBody =>
      'يؤدي ذلك إلى إزالة العنصر وأدلته من هذا الجهاز. لا يمكن التراجع عن ذلك.';

  @override
  String get ledgerDeleteConfirm => 'حذف';

  @override
  String get ledgerDeleteCancel => 'إلغاء';

  @override
  String get ledgerDeleteTooltip => 'حذف عنصر السجل';

  @override
  String get ledgerDeleteFailed => 'تعذّر حذف عنصر السجل. حاول مرة أخرى.';

  @override
  String get ledgerSelectTooltip => 'تحديد العناصر‏';

  @override
  String get ledgerSelectionDone => 'تم‏';

  @override
  String ledgerSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر محدد‏',
      many: '$count عنصراً محدداً‏',
      few: '$count عناصر محددة‏',
      two: 'عنصران محددان‏',
      one: 'عنصر واحد محدد‏',
      zero: 'تحديد العناصر‏',
    );
    return '$_temp0';
  }

  @override
  String ledgerBulkDeleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إزالة $count عنصر من السجل؟‏',
      many: 'إزالة $count عنصراً من السجل؟‏',
      few: 'إزالة $count عناصر من السجل؟‏',
      two: 'إزالة عنصري السجل هذين؟‏',
      one: 'إزالة عنصر السجل هذا؟‏',
    );
    return '$_temp0';
  }

  @override
  String get ledgerBulkDeleteBody =>
      'يؤدي ذلك إلى إزالة العناصر المحددة وأدلتها من هذا الجهاز. لا يمكن التراجع عن ذلك.‏';

  @override
  String get ledgerBulkDeleteTooltip => 'حذف المحدد‏';

  @override
  String get ledgerBulkDeleteFailed =>
      'تعذّر حذف عناصر السجل المحددة. حاول مرة أخرى.‏';

  @override
  String get ledgerSelectAllTooltip => 'تحديد الكل‏';

  @override
  String get ledgerClearSelectionTooltip => 'إلغاء التحديد‏';

  @override
  String get listSelectTooltip => 'تحديد العناصر‏';

  @override
  String get listSelectionDone => 'تم‏';

  @override
  String listSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر محدد‏',
      many: '$count عنصراً محدداً‏',
      few: '$count عناصر محددة‏',
      two: 'عنصران محددان‏',
      one: 'عنصر واحد محدد‏',
      zero: 'تحديد العناصر‏',
    );
    return '$_temp0';
  }

  @override
  String get listBulkDeleteTooltip => 'حذف المحدد‏';

  @override
  String get listSelectAllTooltip => 'تحديد الكل‏';

  @override
  String get listClearSelectionTooltip => 'إلغاء التحديد‏';

  @override
  String get ledgerUpdateFailed => 'تعذّر تحديث عنصر السجل. حاول مرة أخرى.';

  @override
  String get ledgerDetailTitle => 'عنصر السجل';

  @override
  String get ledgerDetailNotFound => 'عنصر السجل هذا لم يعد متاحاً.';

  @override
  String get ledgerDetailUnavailable => 'عنصر السجل غير متاح.';

  @override
  String get ledgerEvidenceSectionTitle => 'الأدلة';

  @override
  String get ledgerEvidenceEmpty => 'لا توجد أدلة مرفقة بهذا العنصر.';

  @override
  String get ledgerEvidenceUnavailable => 'الأدلة غير متاحة.';

  @override
  String get ledgerEvidenceOpenSource => 'عرض في المحادثة‏';

  @override
  String get ledgerEvidenceSourceDeletedTitle => 'المحادثة غير متاحة‏';

  @override
  String get ledgerEvidenceSourceDeletedBody =>
      'تم حذف المحادثة المؤرشفة المرتبطة بهذا الدليل، ولذلك لم يعد بالإمكان فتح النص الأصلي.‏';

  @override
  String get ledgerEvidenceSourceDeletedDismiss => 'حسناً‏';

  @override
  String get ledgerAddTooltip => 'إضافة عنصر سجل.‏';

  @override
  String get ledgerEmptyAddItem => 'إضافة عنصر سجل.‏';

  @override
  String get ledgerCreateTitle => 'إضافة إلى السجل‏';

  @override
  String get ledgerCreateSave => 'إضافة';

  @override
  String get ledgerCreateFailed => 'تعذّر إضافة عنصر السجل. حاول مرة أخرى.‏';

  @override
  String get unsavedChangesTitle => 'تغييرات غير محفوظة';

  @override
  String get unsavedChangesBody => 'المغادرة دون حفظ؟ ستُفقد تعديلاتك.‏';

  @override
  String get unsavedChangesKeepEditing => 'متابعة التحرير';

  @override
  String get unsavedChangesDiscard => 'تجاهل';

  @override
  String get unsavedChangesSave => 'حفظ';

  @override
  String get ledgerCreateStatementLabel => 'البيان';

  @override
  String get ledgerCreateOwnerLabel => 'المالك (اختياري)';

  @override
  String get ledgerCreateKindSemantics => 'نوع العنصر‏';

  @override
  String get ledgerManualOriginNote =>
      'أضفت هذا العنصر بنفسك. لا توجد أدلة محادثة مرفقة.‏';

  @override
  String get welcomeTitle => 'مرحباً بك في كوريڤيل.';

  @override
  String get welcomeBody =>
      'المنصة الخاصة والمحلية أولاً لالتقاط محادثات الاجتماعات واستخراج الأنواع التي تفعّلها (القرار والالتزام هما المثال المضمّن) وبناء سجل آمن مدعوم بالأدلة. تبقى بياناتك على جهازك.‏';

  @override
  String get welcomeSubtitle => 'قرارات، مع أدلة.';

  @override
  String get welcomeFeature1Title => 'خاص افتراضياً';

  @override
  String get welcomeFeature1Subtitle =>
      'تبقى محادثاتك محلية. راجع الأدلة قبل تثبيت أي شيء.';

  @override
  String get welcomeFeature2Title => 'حوّل المحادثات إلى عناصر سجل';

  @override
  String get welcomeFeature2Subtitle =>
      'استخرج الأنواع التي تفعّلها — القرار والالتزام هما المثال المضمّن — مع الدليل من الملاحظات التقريبية.‏';

  @override
  String get welcomeFeature3Title => 'تتبّع ما يهم';

  @override
  String get welcomeFeature3Subtitle =>
      'أبقِ الالتزامات مرئية مع المالكين وتواريخ الاستحقاق.';

  @override
  String get welcomeGetStartedButton => 'ابدأ';

  @override
  String get welcomeAlreadyUser => 'تعرف التطبيق مسبقاً؟';

  @override
  String get welcomeSignInLocally => 'تخطّي التعريف';

  @override
  String get onboardingSkip => 'تخطٍ';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingBack => 'رجوع';

  @override
  String get onboardingIllustrationPlaceholder => 'عنصر نائب للرسم التوضيحي';

  @override
  String get onboardingCaptureTitle => 'التقاط بسهولة.';

  @override
  String get onboardingCaptureBody =>
      'التقط نص المحادثة بسلاسة. يمكن لكوريڤيل معالجة الصوت أو الملاحظات المستوردة من اجتماعاتك مع إبقاء المحتوى الخام آمناً.';

  @override
  String get onboardingExtractTitle => 'اختر ما يُستخرج.';

  @override
  String get onboardingExtractBody =>
      'أنت تختار عمّ يبحث الاستخراج. القرار والالتزام هما المثال المضمّن. كل عنصر ما زال يحتاج اقتباساً دقيقاً ومراجعتك قبل أن يصل إلى السجل.‏';

  @override
  String get onboardingChatTitle => 'دردش مع الذكاء الاصطناعي المحلي.';

  @override
  String get onboardingChatBody =>
      'تحدث مباشرة مع الذكاء الاصطناعي على الجهاز في أي وقت. تبقى الدردشات خاصة على هذا الجهاز — لا يُرسل شيء إلى السحابة.';

  @override
  String get onboardingChatTip =>
      'نصيحة: افتح الدردشة واسأل الذكاء الاصطناعي المحلي دون مشاركة محادثتك خارج هذا الجهاز.';

  @override
  String get onboardingPrivacyTitle => 'الخصوصية أولاً. محلياً.';

  @override
  String get onboardingPrivacyBody =>
      'محادثاتك وأدلتك وسجلك ملكك. لا تغادر أي بيانات خام الجهاز دون موافقتك الصريحة. سلامتك الرقمية أولويتنا.';

  @override
  String get onboardingLocalOnly => 'محلي فقط';

  @override
  String get onboardingReadyToStart => 'هل أنت مستعد للبدء؟';

  @override
  String get onboardingPrivacyTip =>
      'نصيحة: محادثاتك وبياناتك الخام تبقى على جهاز واحد.';

  @override
  String get onboardingBeginCapture => 'ابدأ أول التقاط لي';

  @override
  String get onboardingContinueToApp => 'متابعة';

  @override
  String onboardingStepCounter(int page, int total) {
    return '$page من $total';
  }

  @override
  String get onboardingLogoSemantics => 'شعار كوريڤيل';

  @override
  String get onboardingWordmarkSemantics => 'كوريڤيل';

  @override
  String get onboardingCaptureIllustrationSemantics =>
      'أشخاص يلتقطون محادثة اجتماع';

  @override
  String get onboardingExtractIllustrationSemantics =>
      'نص محادثة مستخرج إلى التزامات وقرارات';

  @override
  String get onboardingChatIllustrationSemantics =>
      'مساعد دردشة بالذكاء الاصطناعي على الجهاز على هاتف';

  @override
  String get onboardingPrivacyIllustrationSemantics =>
      'خصوصية محلية فقط: بلا سحابة، البيانات تبقى على هذا الجهاز';

  @override
  String get onboardingReviewTitle => 'راجع قبل حفظ أي شيء';

  @override
  String get onboardingReviewBody =>
      'تبقى المرشحات معلّقة حتى تقبلها مع أدلة داعمة.';

  @override
  String get onboardingLedgerTitle => 'احتفظ بسجل قرارات';

  @override
  String get onboardingLedgerBody =>
      'تبقى القرارات والالتزامات المقبولة مرئية مع مسار يعود إلى المحادثة.';

  @override
  String get onboardingCommitTitle => 'ثبّت فقط ما تثق به';

  @override
  String get onboardingCommitBody =>
      'أكّد المالك وتاريخ الاستحقاق والأدلة قبل دخول العنصر إلى سجلك.';

  @override
  String get onboardingLocalFirstBadge => 'محلي أولاً';

  @override
  String get onboardingNewCapture => 'التقاط جديد';

  @override
  String get onboardingRecentConversations => 'المحادثات الأخيرة';

  @override
  String get onboardingReadyForReview => 'جاهز للمراجعة';

  @override
  String get onboardingReviewableCandidates => 'مرشحات قابلة للمراجعة';

  @override
  String get onboardingPendingReview => 'بانتظار المراجعة';

  @override
  String get onboardingExtracted => 'مستخرج';

  @override
  String get onboardingDiscard => 'تجاهل';

  @override
  String get onboardingCommitToLedger => 'تثبيت في السجل';

  @override
  String get onboardingLedgerActive => 'نشط';

  @override
  String get onboardingLedgerResolved => 'محلول';

  @override
  String get onboardingLedgerArchived => 'مؤرشف';

  @override
  String get onboardingEvidence => 'دليل';

  @override
  String get onboardingConversation => 'محادثة';

  @override
  String get onboardingOwner => 'المالك';

  @override
  String get onboardingDueDate => 'تاريخ الاستحقاق';

  @override
  String get onboardingSummary => 'ملخص';

  @override
  String onboardingPageSemantics(int page, int total) {
    return 'التعريف، الصفحة $page من $total';
  }

  @override
  String get accountTitle => 'الحساب';

  @override
  String get accountSubtitle => 'تفضيلاتك المحلية والخصوصية ومعلومات التطبيق.';

  @override
  String get accountSectionPreferences => 'التفضيلات';

  @override
  String get accountSectionPrivacy => 'الخصوصية والمعالجة';

  @override
  String get accountProcessingStatusLabel => 'المعالجة';

  @override
  String get accountProcessingStatusValue => 'على هذا الجهاز';

  @override
  String get accountProcessingStatusBody =>
      'يعمل الاستخراج محلياً. لا تغادر المحادثات المصدر هذا الجهاز.‏';

  @override
  String get accountSyncStatusLabel => 'المزامنة';

  @override
  String get accountSyncStatusValue => 'متوقفة';

  @override
  String get accountSyncStatusBody =>
      'تبقى سجلاتك على هذا الجهاز. مزامنة الحساب غير متاحة بعد.‏';

  @override
  String get accountSectionAbout => 'حول كوريڤيل';

  @override
  String get accountNotificationPermissionTitle => 'إشعارات الاكتمال';

  @override
  String get accountNotificationPermissionBody =>
      'يمكن لكوريڤيل إشعارك عند اكتمال الاستخراج أو رد المحادثة أو تثبيت النموذج في الخلفية.‏';

  @override
  String get accountNotificationPermissionReason =>
      'يجري الاستخراج والمحادثة وتثبيت النموذج محلياً على جهازك. تُعلمك الإشعارات عند الاكتمال حتى لو كان التطبيق في الخلفية.‏';

  @override
  String get accountNotificationPermissionAllow => 'السماح بالإشعارات';

  @override
  String get accountNotificationPermissionNotNow => 'ليس الآن';

  @override
  String get accountNotificationPermissionGrantedTitle => 'الإشعارات مفعّلة';

  @override
  String get accountNotificationPermissionGrantedBody =>
      'سيتم إشعارك عند اكتمال الاستخراج أو رد المحادثة أو تثبيت النموذج.‏';

  @override
  String get accountNotificationPermissionDeniedTitle => 'الإشعارات محجوبة';

  @override
  String get accountNotificationPermissionDeniedBody =>
      'لتلقي إشعارات اكتمال الاستخراج والمحادثة وتثبيت النموذج، فعّلها في إعدادات النظام.‏';

  @override
  String get accountNotificationPermissionOpenSettings => 'فتح الإعدادات';

  @override
  String get notificationPermissionExtractionReminderTitle =>
      'تفعيل إشعارات الاستخراج؟';

  @override
  String get notificationPermissionExtractionReminderBody =>
      'يمكن لكوريڤيل إشعارك عند اكتمال هذا الاستخراج في الخلفية. سيستمر الاستخراج في الحالتين.‏';

  @override
  String get notificationPermissionExtractionReminderContinue =>
      'المتابعة دون إشعارات';

  @override
  String get notificationPermissionModelInstallReminderTitle =>
      'تفعيل إشعارات تثبيت النموذج؟';

  @override
  String get notificationPermissionModelInstallReminderBody =>
      'يمكن لكوريڤيل إشعارك عند اكتمال تنزيل النموذج أو نسخه في الخلفية. ستستمر عملية النقل في الحالتين.‏';

  @override
  String get backgroundRestrictionReminderTitle => 'تقييد الخلفية مفعّل';

  @override
  String get backgroundRestrictionReminderExtractionBody =>
      'هذا التطبيق مقيّد في الخلفية. اختر Unrestricted أو No restrictions حتى يستمر الاستخراج إذا غادرت التطبيق.‏';

  @override
  String get backgroundRestrictionReminderModelInstallBody =>
      'هذا التطبيق مقيّد في الخلفية. اختر Unrestricted أو No restrictions حتى يستمر تثبيت النموذج إذا غادرت التطبيق.‏';

  @override
  String get backgroundBatterySaverReminderTitle => 'موفّر البطارية مفعّل';

  @override
  String get backgroundBatterySaverReminderExtractionBody =>
      'قد يبطئ الاستخراج على الجهاز وضع Battery Saver.‏';

  @override
  String get backgroundBatterySaverReminderModelInstallBody =>
      'قد يبطئ تثبيت النموذج على الجهاز وضع Battery Saver.‏';

  @override
  String get backgroundOemBatteryReminderTitle => 'قد يتوقف العمل في الخلفية';

  @override
  String get backgroundOemBatteryReminderExtractionBody =>
      'قد يوقف إعداد البطارية الموصى به على هذا الهاتف الاستخراج إذا غادرت التطبيق. اختر Unrestricted أو No restrictions حتى يستمر الاستخراج.‏';

  @override
  String get backgroundOemBatteryReminderModelInstallBody =>
      'قد يوقف إعداد البطارية الموصى به على هذا الهاتف تثبيت النموذج إذا غادرت التطبيق. اختر Unrestricted أو No restrictions حتى تستمر عملية النقل.‏';

  @override
  String get backgroundWorkReminderContinue => 'المتابعة على أي حال';

  @override
  String get accountBatteryGuidanceTitle => 'إعدادات بطارية الخلفية';

  @override
  String get accountBatteryGuidanceBody =>
      'إذا كان هذا التطبيق مقيّداً أو كان موفّر البطارية مفعّلاً، فقد يتوقف الاستخراج وتنزيلات النموذج عند مغادرة التطبيق. يمكنك مراجعة إعدادات البطارية في أي وقت.‏';

  @override
  String get accountBatteryGuidanceRestrictedTitle => 'الخلفية مقيّدة';

  @override
  String get accountBatteryGuidanceRestrictedBody =>
      'هذا التطبيق مقيّد في الخلفية. افتح إعدادات البطارية واختر Unrestricted أو No restrictions حتى يستمر الاستخراج وتنزيل النموذج إذا غادرت التطبيق.‏';

  @override
  String get accountBatteryGuidanceBatterySaverTitle => 'موفّر البطارية مفعّل';

  @override
  String get accountBatteryGuidanceBatterySaverBody =>
      'قد يبطئ موفّر البطارية الاستخراج وتنزيلات النموذج على الجهاز أو يقاطعهما.‏';

  @override
  String get accountBatteryGuidanceOemTitle => 'قد يتوقف العمل في الخلفية';

  @override
  String get accountBatteryGuidanceOemBody =>
      'قد يوقف إعداد البطارية الموصى به على هذا الهاتف الاستخراج وتنزيل النموذج إذا غادرت التطبيق. افتح إعدادات البطارية واختر Unrestricted أو No restrictions حتى يستمر العمل.‏';

  @override
  String get accountBatteryGuidanceOpenSettings => 'فتح إعدادات البطارية';

  @override
  String get accountThemeLabel => 'المظهر';

  @override
  String get accountThemeSystem => 'النظام';

  @override
  String get accountThemeLight => 'فاتح';

  @override
  String get accountThemeDark => 'داكن';

  @override
  String get accountThemeDetailsSubtitle =>
      'اختر الفاتح أو الداكن أو اتبع إعداد النظام. النظام هو الافتراضي.';

  @override
  String get accountThemeSystemDescription =>
      'مطابقة الوضع الفاتح أو الداكن للجهاز.';

  @override
  String get accountUserPreferencesLabel => 'تفضيلات المستخدم';

  @override
  String accountUserPreferencesSubtitle(String theme, String language) {
    return '$theme · $language';
  }

  @override
  String get accountLanguageLabel => 'اللغة';

  @override
  String get accountLanguageDetailsSubtitle =>
      'اختر الإنجليزية أو الألمانية أو العربية أو اتبع لغة النظام. النظام هو الافتراضي.';

  @override
  String get accountLanguageSystem => 'النظام';

  @override
  String get accountLanguageSystemDescription =>
      'مطابقة لغة الجهاز عندما يدعمها كوريڤيل.';

  @override
  String get accountLanguageEnglish => 'الإنجليزية';

  @override
  String get accountLanguageGerman => 'الألمانية';

  @override
  String get accountLanguageArabic => 'العربية';

  @override
  String get accountVersionLabel => 'الإصدار';

  @override
  String get accountPrivacyLabel => 'سياسة الخصوصية';

  @override
  String get captureEmptyTitle => 'جاهز للالتقاط';

  @override
  String get captureEmptySubtitle =>
      'الصق أو اكتب أي محادثة تقريبية. تبقى خاصة حتى تراجع المرشحات وتقبلها.';

  @override
  String get capturePrivacySubtitle => 'تبقى محادثتك على هذا الجهاز';

  @override
  String get capturePrivacyDialogBody =>
      'يستخدم كوريڤيل الذكاء الاصطناعي على الجهاز افتراضياً. يعمل الاستخراج محلياً على هذا الجهاز. تُرسل البيانات إلى السحابة فقط إذا سمحت صراحةً بالوصول السحابي — هذا الخيار غير متاح بعد.';

  @override
  String get capturePrivacyDialogDismiss => 'حسناً';

  @override
  String get accountPrivacyBody => 'كل البيانات تبقى على جهازك';

  @override
  String get androidIncomingActionsTitle =>
      'إجراءات من تطبيقات أخرى على Android‏';

  @override
  String get androidIncomingActionsBody =>
      'شارك النص مع «التقاط في كوريڤيل» لحفظه في الالتقاط. حدّد نصاً في تطبيق آخر واختر «تلخيص باستخدام كوريڤيل» من قائمة المزيد لتلخيصه في المحادثة — وإذا كان النص ملخصاً بالفعل، تصحّح المحادثة الإملاء والنحو والصياغة الخفيفة فقط.‏';

  @override
  String accountVersionValue(String version) {
    return '$version';
  }

  @override
  String get accountVersionUnavailable => 'غير متاح';

  @override
  String get accountSectionDebug => 'المطوّر';

  @override
  String get accountDebugClearAppData => 'مسح بيانات التطبيق';

  @override
  String get accountDebugClearAppDataSubtitle =>
      'يحذف عناصر السجل والمحادثات والمرشحات للمراجعة وسلاسل الدردشة على هذا الجهاز.';

  @override
  String get accountDebugClearAppDataTitle => 'مسح بيانات التطبيق؟‏';

  @override
  String get accountDebugClearAppDataBody =>
      'سيُحذف نهائياً على هذا الجهاز: عناصر السجل، والمحادثات المصدر، والمرشحات للمراجعة، وسلاسل الدردشة. تبقى التفضيلات والنموذج على الجهاز.‏';

  @override
  String get accountDebugClearAppDataConfirm => 'مسح البيانات';

  @override
  String get accountDebugClearAppDataCancel => 'إلغاء';

  @override
  String get accountDebugClearAppDataDone => 'تم مسح بيانات التطبيق.‏';

  @override
  String get accountDebugClearPreferences => 'مسح التفضيلات المشتركة';

  @override
  String get accountDebugClearPreferencesSubtitle =>
      'يعيد تعيين التعريف والأعلام المحلية الأخرى على هذا الجهاز.';

  @override
  String get accountDebugModeLabel => 'وضع التصحيح';

  @override
  String get accountDebugModeSubtitle =>
      'افحص النتائج وعدّل مطالبات الذكاء الاصطناعي على الجهاز بصيغة JSON.‏';

  @override
  String get accountDebugModePageTitle => 'وضع التصحيح';

  @override
  String get accountDebugModeToggleTitle => 'تفعيل وضع التصحيح';

  @override
  String get accountDebugModeToggleSubtitle =>
      'يعرض في المراجعة والسجل البيانات بصيغة JSON، ويستخدم تجاوزات المطالبات للذكاء الاصطناعي على الجهاز.‏';

  @override
  String get accountDebugModePrivacyTitle => 'يبقى على هذا الجهاز';

  @override
  String get accountDebugModePrivacyNote =>
      'أدوات التصحيح تبقى على هذا الجهاز. لا ترسل المحادثات إلى السحابة ولا تكتب تلقائياً في السجل.‏';

  @override
  String get accountDebugPromptsSection => 'مطالبات على الجهاز';

  @override
  String get accountDebugPromptsSubtitle =>
      'تستبدل هذه المطالبات المضمنة على الجهاز طالما وضع التصحيح قيد التشغيل. الاستعادة تعيد افتراضيات التطبيق.‏';

  @override
  String get accountDebugChatSystemPromptLabel => 'مطالبة نظام المحادثة';

  @override
  String get accountDebugExtractionSystemPromptLabel => 'مطالبة نظام الاستخراج';

  @override
  String get accountDebugExtractionUserPromptLabel =>
      'مطالبة المستخدم للاستخراج';

  @override
  String accountDebugExtractionUserPromptHint(String conversation) {
    return 'حيث يجب إدراج نص المصدر استخدم $conversation.';
  }

  @override
  String get accountDebugPromptSave => 'حفظ المطالبات';

  @override
  String get accountDebugPromptSaved => 'تم حفظ المطالبات.‏';

  @override
  String get accountDebugPromptResetAll => 'استعادة كل الافتراضيات';

  @override
  String get accountDebugPromptResetDone =>
      'تمت استعادة المطالبات إلى الافتراضيات.‏';

  @override
  String get ledgerDebugItemJson => 'عنصر السجل JSON';

  @override
  String get ledgerDebugEvidenceJson => 'الدليل JSON';

  @override
  String reviewPendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مراجعة $count مرشح',
      many: 'مراجعة $count مرشحاً',
      few: 'مراجعة $count مرشحات',
      two: 'مراجعة مرشحين',
      one: 'مراجعة مرشح واحد',
      zero: 'لا مرشحات للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String get ledgerEmptySubtitle =>
      'ستظهر هنا الالتزامات المقبولة أو المضافة.‏';

  @override
  String get conversationHistoryEmptySubtitle => 'ستظهر المحادثات الملتقطة هنا';

  @override
  String get errorGeneric => 'حدث خطأ ما. يُرجى المحاولة مرة أخرى.';

  @override
  String get errorLocalStorage =>
      'تعذّر على هذا الجهاز حفظ سجلاتك المحلية أو قراءتها.';

  @override
  String get errorLocalRecordMissing => 'ذلك السجل المحلي لم يعد متاحاً.';

  @override
  String get errorNetworkUnavailable => 'لا يتوفر اتصال بالشبكة.';

  @override
  String get errorRemoteUnavailable => 'هذه الميزة غير متاحة بعد.';

  @override
  String get errorSignInInvalidCredentials =>
      'عنوان البريد الإلكتروني وكلمة المرور غير متطابقين.';

  @override
  String get errorSignInUserDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get errorSignInTooManyRequests => 'محاولات كثيرة جداً. حاول لاحقاً.';

  @override
  String get errorExtractionInvalidInput =>
      'نص المحادثة فارغ أو أطول من 20000 حرفاً. قصّره وحاول مرة أخرى.‏';

  @override
  String get errorExtractionModelUnavailable =>
      'تعذّر تحميل النموذج على الجهاز. حرّر بعض الذاكرة وحاول مرة أخرى، أو أعد تثبيت النموذج من الحساب.';

  @override
  String get errorExtractionModelUnsupported =>
      'النموذج المضبوط على الجهاز لا يستطيع استخراج المرشحات بعد.';

  @override
  String get errorExtractionInvalidOutput =>
      'أعاد النموذج على الجهاز نتيجة غير قابلة للقراءة. جرّب التقاطاً أقصر، أو استخرج مرة أخرى.';

  @override
  String get errorExtractionSourceArchived =>
      'تم استخراج هذه المحادثة مسبقاً.‏';

  @override
  String get assistantConsentHeadline => 'كيف يعالج كوريڤيل ملاحظاتك';

  @override
  String get assistantConsentUnknownBody =>
      'يبقى الاستخراج على الجهاز على هذا الجهاز ولا يحتاج إذناً سحابياً. المعالجة السحابية متوقفة حتى تسمح بها صراحةً. يُحفظ اختيارك على هذا الجهاز.';

  @override
  String get assistantConsentGrantedBody =>
      'سمحت بالمعالجة السحابية. لا يزال الاستخراج يعمل على هذا الجهاز. الذكاء الاصطناعي السحابي غير متصل بعد، ولا تغادر أي بيانات الجهاز حتى تُطرح تلك الميزة بنفس الموافقة المحفوظة.';

  @override
  String get assistantConsentDeclinedBody =>
      'أبقيت المعالجة على هذا الجهاز. يبقى الذكاء الاصطناعي السحابي متوقفاً. يستمر الاستخراج على الجهاز محلياً.';

  @override
  String get assistantConsentGrantButton => 'السماح بالمعالجة السحابية';

  @override
  String get assistantConsentDeclineButton => 'إبقاء المعالجة على هذا الجهاز';

  @override
  String get assistantConsentWithdrawButton => 'سحب إذن السحابة';

  @override
  String get assistantConsentGrantLaterButton => 'السماح بالمعالجة السحابية';

  @override
  String get extractionEmptySummary =>
      'الصق محادثة لاستخراج الأنواع التي فعّلتها.‏';

  @override
  String get extractionCandidateCommitments => 'الالتزامات المرشحة:';

  @override
  String get extractionReviewEachItem => 'راجع كل عنصر قبل حفظه في سجلك.';

  @override
  String extractionPrompt(
    String legalKinds,
    String dueDateClause,
    String conversation,
  ) {
    return 'استخرج كل مرشح مطابق لكل نوع مفعّل ($legalKinds) من المحادثة فقط (لا تنسخ أمثلة النظام). اذكر الإشارات غير الرسمية إن طابق التلميح. اتبع قواعد النظام. أعد JSON خام فقط — بلا Markdown. أخرج فقط أنواعاً من هذه القائمة: $legalKinds.$dueDateClause يجب أن يأتي quoteSnippet من الجملة الداعمة. ويجب أن يكون statement عنوان سجل قصيراً (حليب، سكر) وألّا يساوي quoteSnippet. للأنواع الشبيهة بالقوائم: مرشّح واحد لكل اسم عنصر قصير.\n\nالمحادثة:\n$conversation‏';
  }

  @override
  String assistantRemoteSystemInstruction(
    String openBrace,
    String closeBrace,
    String legalKinds,
    String kindCatalog,
  ) {
    return 'أنت مستخرج JSON لسجل أدلة شخصي. أخرج JSON صالحاً فقط بلا سياج Markdown. الشكل: $openBrace\"candidates\":[...]$closeBrace\n\nكل مرشح: kind وstatement وowner وdueDate وquoteSnippet.\n- statement: عنوان سجل قصير — يُفضَّل اسم مفرد أو كلمات قليلة (حليب، سكر، Emila). يجب أن يختلف عن quoteSnippet (لا تلصق الاقتباس كبيان)\n- owner: اسم شخص أو null (فقط إن سمحت ownerPolicy؛ وإلا null)\n- dueDate: ISO عندما تسمح datePolicy بالتاريخ ويُذكر يوم تقويمي (15 أكتوبر، 7 نوفمبر الساعة 17:00، 2026-10-15). للتاريخ فقط YYYY-MM-DD؛ مع الوقت YYYY-MM-DDTHH:MM:00. فضّل سنة من المحادثة وإلا السنة الحالية. أيام الأسبوع مثل الجمعة تبقى null. المواعيد النسبية (الأسبوع القادم، نهاية اليوم) تبقى null. إن كانت datePolicy none فـ dueDate دائماً null.\n- quoteSnippet: جزء حرفي من نص المحادثة أدناه (وليس من الأمثلة)\n\nSKIP: قد/ربما إلا إذا طلب التلميح ذلك صراحة؛ حالة بلا تطابق. إن لم يوجد شيء: $openBrace\"candidates\":[]$closeBrace. لا تخترع kind غير الأنواع المفعّلة: $legalKinds. أخرج مرشّحين لهذه الأنواع المفعّلة فقط. $kindCatalog\n\nيعمل مع السرد وحوار Name:. اربط أنا/سأجهّز تحت Name: بالمتحدّث.\n\nمهم: استخرج فقط من محادثة المستخدم. لا تنسخ إجابات الأمثلة.‏';
  }

  @override
  String get onboardingModelTitle => 'ثبّت النموذج على الجهاز.';

  @override
  String get onboardingModelCheckingTitle =>
      'جارٍ التحقق من النموذج على الجهاز.';

  @override
  String get onboardingModelCheckingBody =>
      'جارٍ تأكيد ملف النموذج الموجود بالفعل على هذا الجهاز. قد يستغرق ذلك لحظة لملف كبير.';

  @override
  String get onboardingModelPickingTitle => 'جارٍ تجهيز النموذج المحدد.';

  @override
  String get onboardingModelPickingBody =>
      'جارٍ تجهيز الملف. سيبدأ النسخ بعد ذلك.';

  @override
  String get onboardingModelBody =>
      'النموذج الموصى به هو Qwen 1.5B. عند توفّر ذاكرة كافية على هذا الجهاز، يمكنك اختيار ملف سبق نسخه إلى هنا، أو تنزيل نموذج آخر مثل Llama 3 بصيغة GGUF.‏';

  @override
  String get onboardingModelDownloadButton => 'تنزيل النموذج على الجهاز';

  @override
  String get onboardingModelResumeDownload => 'استئناف التنزيل';

  @override
  String get onboardingModelCancelDownload => 'إيقاف التنزيل';

  @override
  String get onboardingModelDiscardPartial => 'تجاهل التنزيل الجزئي';

  @override
  String get onboardingModelSelectFileButton => 'اختيار ملف النموذج';

  @override
  String get onboardingModelDownloading => 'جارٍ تنزيل النموذج…';

  @override
  String get onboardingModelImporting => 'جارٍ استيراد النموذج…';

  @override
  String get onboardingModelDownloadHint =>
      'يمكنك التبديل بين التطبيقات أو العودة إلى الشاشة الرئيسية. إغلاق كوريڤيل من التطبيقات الحديثة يوقف النسخ داخل التطبيق، أما التنزيل فيستمر ويمكنه الاستئناف تلقائياً. حجم الملف حوالي 1.1 غيغابايت ويبقى على هذا الجهاز.‏';

  @override
  String get modelInstallDownloadNotificationTitle => 'جارٍ تنزيل النموذج';

  @override
  String get modelInstallDownloadNotificationBody =>
      'جارٍ تنزيل النموذج على الجهاز. يمكنك التبديل بين التطبيقات.‏';

  @override
  String get modelInstallCopyNotificationTitle => 'جارٍ نسخ النموذج';

  @override
  String get modelInstallCopyNotificationBody =>
      'جارٍ نسخ الملف المحدد إلى هذا الجهاز بصيغة GGUF.‏';

  @override
  String get modelInstallCompleteNotificationTitle => 'النموذج على الجهاز جاهز';

  @override
  String get modelInstallDownloadCompleteNotificationBody =>
      'اكتمل تنزيل النموذج على الجهاز.‏';

  @override
  String get modelInstallCopyCompleteNotificationBody =>
      'تم نسخ الملف المحدد إلى هذا الجهاز بصيغة GGUF.‏';

  @override
  String get modelInstallExportNotificationTitle => 'جارٍ حفظ النموذج';

  @override
  String get modelInstallExportNotificationBody =>
      'جارٍ حفظ نسخة من النموذج على الجهاز.‏';

  @override
  String get modelInstallExportCompleteNotificationBody =>
      'تم حفظ نسخة من النموذج على الجهاز.‏';

  @override
  String onboardingModelDownloadPercent(int percent) {
    return '$percent%';
  }

  @override
  String onboardingModelDownloadStats(
    int percent,
    String speed,
    String timeLeft,
  ) {
    return '$percent% · $speed · $timeLeft';
  }

  @override
  String onboardingModelDownloadSpeedMBps(String value) {
    return '$value ميغابايت/ث';
  }

  @override
  String onboardingModelDownloadSpeedKBps(String value) {
    return '$value كيلوبايت/ث';
  }

  @override
  String onboardingModelDownloadSpeedBps(int value) {
    return '$value بايت/ث';
  }

  @override
  String onboardingModelDownloadTimeLeftHours(int count) {
    return '~$count س متبقية';
  }

  @override
  String onboardingModelDownloadTimeLeftMinutes(int count) {
    return '~$count د متبقية';
  }

  @override
  String onboardingModelDownloadTimeLeftSeconds(int count) {
    return '~$count ث متبقية';
  }

  @override
  String get onboardingModelDownloadPausedHint =>
      'التنزيل متوقف مؤقتاً. استأنف للمتابعة، أو تجاهل الملف الجزئي.';

  @override
  String get onboardingModelImportHint =>
      'يمكنك التبديل بين التطبيقات أو العودة إلى الشاشة الرئيسية أثناء النسخ. إغلاق كوريڤيل من التطبيقات الحديثة قد يوقف النسخ؛ أعد فتح التطبيق للمتابعة. يبقى الملف على هذا الجهاز وأنت المسؤول عنه بصيغة GGUF.‏';

  @override
  String get onboardingModelFinalizingHint => 'جارٍ إنهاء تثبيت النموذج…‏';

  @override
  String get onboardingModelDownloadError =>
      'تعذّر تنزيل النموذج. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get onboardingModelImportError =>
      'تعذّر استيراد الملف المحدد. حاول مرة أخرى بعد اختيار ملف بصيغة GGUF.‏';

  @override
  String get onboardingModelChecksumError =>
      'ملف النموذج المنزّل لم يطابق المجموع الاختباري المتوقع. أعد التنزيل، أو اختر محلياً ملفاً بصيغة GGUF.‏';

  @override
  String get onboardingModelStorageFullError =>
      'مساحة التخزين على هذا الجهاز ممتلئة. حرّر مساحة، ثم تجاهل ملفات النموذج المؤقتة أدناه وحاول مرة أخرى. يحتاج النموذج حوالي 1.1 غيغابايت حرة.';

  @override
  String get onboardingModelFreeTempSpace => 'تحرير ملفات النموذج المؤقتة';

  @override
  String get onboardingModelReadyTitle => 'النموذج على الجهاز جاهز';

  @override
  String get onboardingModelReadySubtitle =>
      'سيعمل الاستخراج على هذا الجهاز. يمكنك المتابعة إلى التطبيق.';

  @override
  String get onboardingModelConfigureLater => 'التهيئة لاحقاً';

  @override
  String get accountModelDetailsLabel => 'النموذج على الجهاز';

  @override
  String get accountModelDetailsRowSubtitle =>
      'اطلع على النموذج المثبت وغيّره.';

  @override
  String get accountModelNotConfigured => 'غير مهيأ';

  @override
  String get accountModelDetailsTitle => 'النموذج على الجهاز';

  @override
  String get accountModelDetailsSubtitle =>
      'يستخدم الاستخراج المحلي هذا الملف على الجهاز بصيغة GGUF.‏';

  @override
  String get accountModelNameLabel => 'النموذج';

  @override
  String get accountModelFileLabel => 'الملف';

  @override
  String get accountModelOriginLabel => 'المصدر';

  @override
  String get accountModelOriginDownload => 'تم تنزيله بواسطة التطبيق';

  @override
  String get accountModelOriginImport => 'محدد من ملف';

  @override
  String get accountModelOriginUnknown => 'مثبت على هذا الجهاز';

  @override
  String get accountModelSizeLabel => 'الحجم';

  @override
  String accountModelSizeMegabytes(String size) {
    return '$size ميغابايت';
  }

  @override
  String accountModelSizeGigabytes(String size) {
    return '$size غيغابايت';
  }

  @override
  String get accountModelStatusReady => 'جاهز للذكاء الاصطناعي المحلي';

  @override
  String get accountModelChangeButton => 'تغيير النموذج';

  @override
  String get accountModelSaveLocallyButton => 'حفظ ملف النموذج';

  @override
  String get accountModelSavingLocally => 'جارٍ حفظ ملف النموذج…';

  @override
  String get accountModelSaveLocallySuccess =>
      'تم حفظ ملف النموذج. يمكنك اختياره لاحقاً عبر اختيار ملف النموذج.‏';

  @override
  String get accountModelSaveLocallyError =>
      'تعذّر حفظ ملف النموذج. حاول مرة أخرى.‏';

  @override
  String get accountModelSaveLocallyCancel => 'إيقاف الحفظ';

  @override
  String get accountModelCancelChange => 'الإبقاء على النموذج الحالي';

  @override
  String get accountModelDeleteButton => 'حذف النموذج';

  @override
  String get accountModelDeleteTitle => 'حذف النموذج على الجهاز؟';

  @override
  String get accountModelDeleteBody =>
      'يؤدي ذلك إلى إزالة ملف النموذج من هذا الجهاز. يبقى الذكاء الاصطناعي المحلي متوقفاً حتى تنزّل نموذجاً أو تختاره مرة أخرى.';

  @override
  String get accountModelDeleteConfirm => 'حذف';

  @override
  String get accountModelDeleteCancel => 'إلغاء';

  @override
  String get accountModelReplaceTitle => 'استبدال النموذج على الجهاز؟‏';

  @override
  String get accountModelReplaceBody =>
      'يؤدي تنزيل نموذج آخر إلى إزالة النموذج الحالي من هذا الجهاز فوراً. يبقى الذكاء الاصطناعي المحلي متوقفاً حتى يكتمل التنزيل الجديد.‏';

  @override
  String get accountModelReplaceConfirm => 'استبدال';

  @override
  String get accountModelReplaceCancel => 'إلغاء';

  @override
  String get accountModelEmptyTitle => 'تهيئة النموذج على الجهاز';

  @override
  String get accountModelEmptySubtitle =>
      'نزّل نموذجاً موصى به لتمكين الاستخراج المحلي، أو اختر ملفاً بصيغة GGUF.‏';

  @override
  String get localModelRequiredTitle => 'تهيئة النموذج على الجهاز';

  @override
  String get localModelRequiredBody =>
      'يحتاج الذكاء الاصطناعي المحلي إلى نموذج على هذا الجهاز قبل أن يتمكن من استخراج الأنواع التي فعّلتها.‏';

  @override
  String get localModelRequiredConfigure => 'تهيئة النموذج';

  @override
  String get localModelRequiredDismiss => 'ليس الآن';

  @override
  String get qwenLicenseNoticeTitle => 'إشعار الترخيص الخاص بـ Qwen‏';

  @override
  String get qwenLicenseNoticeBody =>
      'تخضع أوزان النموذج الموصى به Qwen 1.5B Instruct لترخيص Apache License 2.0. لا يمنح كوريڤيل حقوقاً إضافية لأي نموذج.‏';

  @override
  String get onboardingModelCatalogTitle => 'النماذج الموصى بها';

  @override
  String get onboardingModelManualResponsibility =>
      'اختيار ملف محلي بصيغة GGUF يتجاوز التحقق الرسمي من المجموع الاختباري. أنت مسؤول عن أصالة الملف وترخيصه.‏';

  @override
  String get modelLicenseApache20 => 'Apache-2.0';

  @override
  String get modelLicenseLlama3 => 'Llama 3 Community';

  @override
  String get modelLicenseLlama32 => 'Llama 3.2 Community';

  @override
  String get modelCatalogRecommended => 'موصى به';

  @override
  String get modelCatalogOpenPageTooltip => 'فتح صفحة النموذج';

  @override
  String get modelCatalogNeedsMoreRam => 'يحتاج ذاكرة أكبر';

  @override
  String get modelCatalogUncensored => 'غير خاضع للرقابة';

  @override
  String get modelCatalogUncensoredNote =>
      'فلاتر رفض مدمجة أقل من النموذج الموصى به. يعمل فقط على هذا الجهاز—استخدمه بمسؤولية.‏';

  @override
  String get accountModelLicensesTitle => 'تراخيص النماذج';

  @override
  String get accountModelLicensesBody =>
      'النموذج الموصى به هو Qwen بترخيص Apache-2.0. الخيارات غير الخاضعة للرقابة في الكتالوج ترفض أقل وتبقى على الجهاز. تستخدم الملفات الأخرى تراخيصها الأصلية، وأنت مسؤول عن أي ملف تختاره بصيغة GGUF.‏';

  @override
  String get chatAutoScrollOnTooltip => 'يتبع أحدث الردود';

  @override
  String get chatAutoScrollOffTooltip => 'الانتقال إلى أحدث الردود';

  @override
  String get chatTitle => 'محادثة';

  @override
  String get chatNewTooltip => 'محادثة جديدة';

  @override
  String get chatHistoryTooltip => 'سجل المحادثات';

  @override
  String get chatEmptyTitle => 'اسأل النموذج على الجهاز';

  @override
  String get chatEmptySubtitle =>
      'تبقى الرسائل على هذا الجهاز. تتبع الإجابات موجه النظام للمحادثة — غيّره من إعدادات الاستخراج. يساعد النموذج في القرارات والالتزامات؛ المحادثة ليست سجلاً ثانياً.‏';

  @override
  String get chatEmptyExtractionSettingsLink => 'فتح إعدادات الاستخراج‏';

  @override
  String get chatComposerLabel => 'رسالة';

  @override
  String get chatComposerHint => 'اكتب رسالة';

  @override
  String chatComposerCount(int used, int max) {
    return '$used من $max حرفاً';
  }

  @override
  String get chatSendTooltip => 'إرسال';

  @override
  String get chatStopTooltip => 'إيقاف التوليد';

  @override
  String get chatCopiedSnackbar => 'تم نسخ النص‏';

  @override
  String get chatRetryLabel => 'إعادة المحاولة';

  @override
  String get chatGeneratingLabel => 'جارٍ التفكير';

  @override
  String get chatGeneratingSemantics => 'النموذج على الجهاز يكتب رداً';

  @override
  String get chatUnavailable => 'المحادثة غير متاحة حالياً.';

  @override
  String get chatHistoryTitle => 'سجل المحادثات';

  @override
  String get chatHistoryEmpty => 'لا محادثات بعد.';

  @override
  String get chatHistoryEmptySubtitle =>
      'ابدأ محادثة من تبويب المحادثة. تُخزَّن السلاسل على هذا الجهاز فقط.';

  @override
  String get chatHistoryUnavailable => 'سجل المحادثات غير متاح.';

  @override
  String get chatDeleteTitle => 'حذف هذه المحادثة؟';

  @override
  String get chatDeleteBody =>
      'يؤدي ذلك إلى إزالة السلسلة ورسائلها من هذا الجهاز. لا يمكن التراجع عن ذلك.';

  @override
  String get chatDeleteConfirm => 'حذف';

  @override
  String get chatDeleteCancel => 'إلغاء';

  @override
  String get chatDeleteFailed => 'تعذّر حذف هذه المحادثة.';

  @override
  String chatBulkDeleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $count محادثة؟‏',
      many: 'حذف $count محادثة؟‏',
      few: 'حذف $count محادثات؟‏',
      two: 'حذف هاتين المحادثتين؟‏',
      one: 'حذف هذه المحادثة؟‏',
    );
    return '$_temp0';
  }

  @override
  String get chatBulkDeleteBody =>
      'يؤدي ذلك إلى إزالة السلاسل المحددة ورسائلها من هذا الجهاز. لا يمكن التراجع عن ذلك.‏';

  @override
  String get chatBulkDeleteFailed =>
      'تعذّر حذف المحادثات المحددة. حاول مرة أخرى.‏';

  @override
  String get chatMessageUserSemantics => 'رسالتك';

  @override
  String get chatMessageAssistantSemantics => 'رد النموذج';

  @override
  String get chatSuggestion1 => 'ساعدني في صياغة قرار من اجتماع.';

  @override
  String get chatSuggestion2 => 'ما الذي يجعل الالتزام قابلاً للمراجعة؟';

  @override
  String get chatSuggestion3 => 'كيف يجب أن ألتقط اقتباسات الأدلة؟';

  @override
  String get errorChatInvalidInput => 'أدخل رسالة أقصر وحاول مرة أخرى.';

  @override
  String get errorChatModelUnavailable =>
      'النموذج على الجهاز غير جاهز. هيّئه من الحساب للمحادثة.';

  @override
  String get chatSystemInstruction =>
      'أنت مساعد كوريڤيل على الجهاز. أجب عن الأسئلة العامة بشكل مفيد، بما في ذلك المواضيع اليومية.\n\nكوريڤيل تطبيق خاص يعمل أولاً على الجهاز ويحوّل نص المحادثة إلى عناصر سجل قابلة للمراجعة للأنواع التي تفعّلها (القرار والالتزام هما المثال المضمّن). وظائفه الأساسية: الالتقاط يحفظ محادثة المصدر على هذا الجهاز. الاستخراج يطلب من النموذج على الجهاز مرشحين لتلك الأنواع المفعّلة مع اقتباسات أدلة — ويجب ألا يختلق مالكين أو تواريخ أو أنواعاً أو ملاحظات أو اتفاقات. المراجعة مطلوبة قبل قبول أي شيء. السجل هو القائمة الموثوقة للعناصر المقبولة بما فيها العمل المفتوح القابل للإكمال، وكل منها مرتبط بدليل. المحادثة (هذا الموضوع) ليست سجلاً ثانياً. الحساب يحتفظ بالمظهر واللغة ونموذج الجهاز بصيغة GGUF.\n\nعندما يسأل المستخدم كيف يعمل كوريڤيل، أو يستخدم مطالبات مثل صياغة قرار من اجتماع، وما الذي يجعل الالتزام قابلاً للمراجعة، أو كيف تُلتقط اقتباسات الأدلة، اشرح قواعد المنتج بوضوح. كن موجزاً ودقيقاً وصادقاً. لا تدّعِ أن محادثات المصدر أو الأدلة أو هذه المحادثة تغادر الجهاز.‏';

  @override
  String chatSummarizeSelectionPrompt(String text) {
    return 'إذا كان النص التالي ملخصاً قصيراً بالفعل أو سبق تلخيصه، فلا تلخّصه مجدداً. صحّح الإملاء والنحو وعلامات الترقيم والصياغة الخفيفة فقط. وإلا فاكتب ملخصاً قصيراً.\n\nالنص:\n$text‏';
  }

  @override
  String extractionProgressProcessing(int current, int total) {
    return 'جارٍ معالجة الجزء $current من $total';
  }

  @override
  String extractionProgressCandidatesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرشحاً',
      one: 'مرشح واحد',
      zero: 'لا مرشحين بعد',
    );
    return '$_temp0';
  }

  @override
  String get extractionMetricsLabel => 'مقاييس الاستخراج';

  @override
  String extractionMetricsCandidatesPerSecond(double rate) {
    final intl.NumberFormat rateNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String rateString = rateNumberFormat.format(rate);

    return '$rateString مرشح/ث';
  }

  @override
  String extractionMetricsTotalTime(double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    return 'الإجمالي: $secondsString ث';
  }

  @override
  String extractionMetricsChunkTime(int index, double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    return 'الجزء $index: $secondsString ث';
  }

  @override
  String get extractionInProgress => 'الاستخراج قيد التنفيذ';

  @override
  String get extractionProgressMinimize => 'تصغير تقدّم الاستخراج‏';

  @override
  String get extractionProgressExpand => 'إظهار تقدّم الاستخراج‏';

  @override
  String get extractionProgressStop => 'إيقاف الاستخراج‏';

  @override
  String get extractionStopTitle => 'إيقاف الاستخراج؟‏';

  @override
  String get extractionStopBody =>
      'سيؤدي ذلك إلى إيقاف الاستخراج الحالي. تبقى المرشحات التي عُثر عليها في المراجعة. لن تُعالَج بقية النص.‏';

  @override
  String get extractionStopConfirm => 'إيقاف';

  @override
  String get extractionStopCancel => 'متابعة الاستخراج‏';

  @override
  String get extractionStoppedSnackbar => 'تم إيقاف الاستخراج.‏';

  @override
  String get extractionProgressBackgroundHint =>
      'يمكنك التبديل بين التطبيقات أو العودة إلى الشاشة الرئيسية. لا تُغلِق كوريڤيل من التطبيقات الأخيرة — يتوقف الاستخراج ولا يُستأنف إلا عند فتح التطبيق مجدداً. ستتلقى إشعاراً عند انتهائه.‏';

  @override
  String get chatDisabledDuringExtraction =>
      'المحادثة متوقفة مؤقتاً أثناء الاستخراج حتى لا يُحمَّل جهازك فوق طاقته.‏';

  @override
  String get chatProgressNotificationTitle => 'جارٍ إنشاء رد المحادثة';

  @override
  String get chatProgressNotificationBody =>
      'النموذج على الجهاز يكتب رداً. يمكنك التبديل بين التطبيقات.‏';

  @override
  String get chatCompleteNotificationTitle => 'الرد جاهز في المحادثة';

  @override
  String get chatCompleteNotificationBody =>
      'انتهى النموذج على الجهاز من كتابة رد.‏';

  @override
  String get extractionNotificationBody =>
      'جارٍ معالجة نص المحادثة باستخدام نموذج الذكاء الاصطناعي المحلي‏';

  @override
  String get extractionCompleteNotificationTitle => 'اكتمل الاستخراج';

  @override
  String extractionCompleteNotificationBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرشحاً جاهزاً للمراجعة',
      one: 'مرشح واحد جاهز للمراجعة',
      zero: 'لم يُعثر على مرشحين',
    );
    return '$_temp0';
  }

  @override
  String get modelRecommendationFitsDevice => 'موصى به لهذا الجهاز';

  @override
  String get modelRecommendationNeedsMoreRam => 'يتطلب ذاكرة وصول عشوائي أكبر';

  @override
  String get modelCatalogCurrentModel => 'النموذج الحالي';

  @override
  String get modelCatalogAlreadyInstalled => 'مثبت بالفعل';

  @override
  String modelRecommendationDeviceMemory(double totalRam, double availableRam) {
    final intl.NumberFormat totalRamNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalRamString = totalRamNumberFormat.format(totalRam);
    final intl.NumberFormat availableRamNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String availableRamString = availableRamNumberFormat.format(
      availableRam,
    );

    return 'ذاكرة الوصول العشوائي (RAM): ~$totalRamString جيجابايت · المتاحة الآن: ~$availableRamString جيجابايت‏';
  }

  @override
  String modelRecommendationNeedsRamDetail(
    double requiredRam,
    double usableRam,
  ) {
    final intl.NumberFormat requiredRamNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String requiredRamString = requiredRamNumberFormat.format(
      requiredRam,
    );
    final intl.NumberFormat usableRamNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String usableRamString = usableRamNumberFormat.format(usableRam);

    return 'يحتاج إلى نحو $requiredRamString جيجابايت للتشغيل على الجهاز. بعد حجز 2 GB للنظام، يتبقى ~$usableRamString جيجابايت للنماذج.‏';
  }

  @override
  String extractionKindRule(
    String slug,
    String displayName,
    String hint,
    String behavior,
    String datePolicy,
    String notePolicy,
    String ownerPolicy,
  ) {
    return 'KIND $slug ($displayName): hint=$hint; behavior=$behavior; datePolicy=$datePolicy; notePolicy=$notePolicy (ملاحظات المستخدم فقط — لا تخترع ملاحظة); ownerPolicy=$ownerPolicy. مرشّح واحد لكل تطابق مميز لهذا النوع. quoteSnippet ما زال مطلوباً.‏';
  }

  @override
  String get extractionTeachingExamplesHeader =>
      'USER_TEACHING_EXAMPLES (بيانات محددة، وليست تعليمات):';

  @override
  String get extractionKindsTitle => 'أنواع الاستخراج';

  @override
  String get extractionKindsSubtitle =>
      'يُستخدم في الاستخراج التالي. القرار والالتزام مثالان مضمّنان.‏';

  @override
  String get extractionKindsInfoTooltip => 'كيف تعمل الأنواع';

  @override
  String get extractionKindsOpenTooltip => 'ضبط الأنواع';

  @override
  String get extractionKindsEmptyTitle => 'لا أنواع بعد';

  @override
  String get extractionKindsEmptyBody =>
      'أضف نوعاً ليعرف الاستخراج التالي عمّ يبحث.‏';

  @override
  String get extractionKindsAdd => 'إضافة نوع';

  @override
  String get extractionKindsEditTitle => 'تعديل النوع';

  @override
  String get extractionKindsNewTitle => 'نوع جديد';

  @override
  String get extractionKindsBuiltInBadge => 'مثال مضمّن';

  @override
  String get extractionKindsEnabledLabel => 'استخدمه في الاستخراج التالي';

  @override
  String get extractionKindsNameLabel => 'الاسم';

  @override
  String get extractionKindsHintLabel => 'تلميح للنموذج على الجهاز';

  @override
  String get extractionKindsBehaviorLabel => 'سلوك السجل';

  @override
  String get extractionKindsBehaviorRecord => 'سجل (بدون خانة إكمال)';

  @override
  String get extractionKindsBehaviorCompletable => 'قابل للإكمال (خانة اختيار)';

  @override
  String get extractionKindsDatePolicyLabel => 'تاريخ الاستحقاق';

  @override
  String get extractionKindsNotePolicyLabel => 'ملاحظة';

  @override
  String get extractionKindsOwnerPolicyLabel => 'المسؤول';

  @override
  String get extractionKindsPolicyNone => 'لا تُستخدم';

  @override
  String get extractionKindsPolicyOptional => 'اختياري';

  @override
  String get extractionKindsSave => 'حفظ النوع';

  @override
  String get extractionKindsDelete => 'إزالة النوع';

  @override
  String get extractionKindsDeleteTitle => 'إزالة هذا النوع؟‏';

  @override
  String get extractionKindsDeleteBody =>
      'يُزال النوع من الكتالوج على هذا الجهاز. تحتفظ عناصر السجل الحالية بتسمياتها. لا يمكن التراجع.‏';

  @override
  String get extractionKindsDeleteConfirm => 'إزالة';

  @override
  String get extractionKindsDeleteCancel => 'إلغاء';

  @override
  String extractionKindsBulkDeleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إزالة $count نوع؟‏',
      many: 'إزالة $count نوعاً؟‏',
      few: 'إزالة $count أنواع؟‏',
      two: 'إزالة هذين النوعين؟‏',
      one: 'إزالة هذا النوع؟‏',
    );
    return '$_temp0';
  }

  @override
  String get extractionKindsBulkDeleteBody =>
      'تُزال الأنواع المحددة من الكتالوج على هذا الجهاز. تحتفظ عناصر السجل الحالية بتسمياتها. لا يمكن التراجع.‏';

  @override
  String get extractionKindsBulkDeleteFailed =>
      'تعذّر إزالة الأنواع المحددة. حاول مرة أخرى.‏';

  @override
  String get extractionKindsCannotDeleteBuiltIn =>
      'لا يمكن إزالة الأنواع المضمّنة. يمكنك إيقافها بدلاً من ذلك.‏';

  @override
  String get extractionKindsCannotDisableLast =>
      'أبقِ نوعاً واحداً على الأقل مفعّلاً للاستخراج التالي.‏';

  @override
  String get extractionKindsCannotArchiveInUse =>
      'ما زال لهذا النوع عناصر في السجل أو مرشحون بانتظار المراجعة. أوقفه بدلاً من إزالته.‏';

  @override
  String get extractionKindsAlreadyExists =>
      'يوجد نوع بهذا الاسم مسبقاً. افتحه من القائمة أو اختر اسماً آخر.‏';

  @override
  String get extractionKindsCatalogFull =>
      'يمكنك الاحتفاظ بـ 12 نوعاً كحد أقصى. أوقف نوعاً أو أزل نوعاً غير مستخدم أولاً.‏';

  @override
  String get extractionKindsEnabledFull =>
      'يمكنك تفعيل 8 أنواع كحد أقصى لكل استخراج.‏';

  @override
  String get extractionKindsSaved =>
      'تم حفظ النوع. يُستخدم في الاستخراج التالي.‏';

  @override
  String get extractionKindsInfoTitle => 'عمّ يبحث الاستخراج';

  @override
  String get extractionKindsInfoBody =>
      'يبقى كوريڤيل سجلاً مدعوماً بالدليل. القرار والالتزام هما المثال المضمّن. أضف أنواعاً تحتاجها يومياً. كل عنصر مقترح ما زال يحتاج اقتباساً دقيقاً ومراجعتك. عدد أقل من الأنواع المفعّلة يستخرج عادة أنظف على هذا الجهاز.‏';

  @override
  String get extractionKindsAccuracyGuidance =>
      'أكثر من أربعة أنواع مفعّلة. عدد أقل من الأنواع يستخرج عادة بدقة أعلى على هذا الجهاز.‏';

  @override
  String extractionKindsActiveSubtitle(String kinds) {
    return 'الاستخراج التالي يبحث عن: $kinds';
  }

  @override
  String get extractionSettingsTitle => 'إعدادات الاستخراج';

  @override
  String get extractionSettingsSubtitle =>
      'تلميحات النوع هي الأداة الأولى. تبقى تجاوزات المطالبات المتقدمة على هذا الجهاز إلى أن يتوفر تسجيل الدخول والمزامنة.‏';

  @override
  String get extractionSettingsAccountLabel => 'إعدادات الاستخراج';

  @override
  String get extractionSettingsAccountSubtitle =>
      'المطالبات والتجاوزات المتقدمة لاستخراج على الجهاز';

  @override
  String get extractionSettingsOverridesNote =>
      'التجاوزات غير الفارغة تستبدل المطالبات الافتراضية حتى مع إيقاف التصحيح. وضع التصحيح يُظهر لوحات JSON فقط. التجاوزات جاهزة لمرآة التفضيلات؛ ولا تُرسل خارج هذا الجهاز اليوم.‏';

  @override
  String get extractionSettingsSave => 'حفظ التجاوزات';

  @override
  String get extractionSettingsSaved => 'تم حفظ تجاوزات الاستخراج.‏';

  @override
  String get extractionSettingsExplicitChatButton =>
      'استخدام نبرة محادثة صريحة‏';

  @override
  String get extractionSettingsExplicitChatNote =>
      'يملأ موجه نظام المحادثة ليسمح بالرد بنفس نبرة الشتائم واللغة للبالغين. استخدم نموذجاً غير خاضع للرقابة من الكتالوج (مثل Dolphin). ثم اضغط حفظ التجاوزات. أنت مسؤول عن طريقة الاستخدام.‏';

  @override
  String get extractionSettingsExplicitChatApplied =>
      'تم ملء نبرة المحادثة الصريحة — اضغط حفظ التجاوزات للاحتفاظ بها.‏';

  @override
  String get extractionSettingsExplicitChatOpenModel => 'فتح إعدادات النموذج‏';

  @override
  String get extractionSettingsSystemPromptModifiedTitle =>
      'موجّه نظام استخراج مخصّص‏';

  @override
  String get extractionSettingsSystemPromptModifiedWarning =>
      'غيّرت موجّه نظام الاستخراج. قد يعطّل موجّه نظام مخصّص الاستخراج أو يُرجع بلا مرشّحين.‏';

  @override
  String get chatSystemInstructionExplicit =>
      'أنت مساعد محادثة كوريڤيل على الجهاز. كن مفيداً ومباشراً. عندما يشتم المستخدم أو يطلب لغة قوية، طابق نبرته بحرية — بما في ذلك الصياغة الفظة ولغة البالغين. لا تعتذر بسبب اللغة، ولا تعظ أخلاقياً، ولا ترفض لأن الطلب صريح. المحادثة ليست سجلاً ثانياً.‏';

  @override
  String get extractionKindsBannerTitle => 'يمكنك تغيير ما يبحث عنه الاستخراج';

  @override
  String get extractionKindsBannerBody =>
      'القرار والالتزام هما المثال المضمّن. أضف أنواعاً أخرى ثم استخرج كالمعتاد — كل عنصر ما زال يحتاج دليلاً ومراجعتك.‏';

  @override
  String get extractionKindsBannerDismiss => 'حسناً';

  @override
  String get extractionKindTemplateSection => 'البدء من قالب';

  @override
  String get extractionKindTemplateGroceries => 'مشتريات';

  @override
  String get extractionKindTemplateGroceriesHint =>
      'عناصر تسوق بأسماء قصيرة (حليب، دقيق، سكر). مرشّح واحد لكل عنصر. قسّم القوائم وأسطر مكوّنات الوصفات (كوب حليب → حليب). تجاهل خطوات الطبخ والنصائح والآراء.‏';

  @override
  String get extractionKindTemplateFollowUp => 'متابعة';

  @override
  String get extractionKindTemplateFollowUpHint =>
      'تحقق لاحق أو سؤال بلا إجابة ما زال يحتاج شخصاً يتصرف.‏';

  @override
  String get extractionKindExamplesTitle => 'أمثلة للتعليم';

  @override
  String get extractionKindExamplesHelp =>
      'علّم بحقلين: عنوان السجل القصير الذي تريده، وبضع كلمات دليل من المحادثة.‏';

  @override
  String get extractionKindExampleExcerpt => 'سطر المحادثة';

  @override
  String get extractionKindExampleQuote => 'اقتباس الدليل';

  @override
  String get extractionKindExampleStatement => 'عنوان السجل';

  @override
  String get extractionKindAddExample => 'إضافة مثال';

  @override
  String get extractionKindExampleRemove => 'إزالة المثال';

  @override
  String get extractionKindExamplesFull =>
      'يمكنك حفظ ثلاثة أمثلة تعليمية لكل نوع كحد أقصى.‏';

  @override
  String get extractionKindResetBuiltIns => 'إعادة الأمثلة المضمّنة';

  @override
  String get extractionKindsResetDone =>
      'أُعيدت الأنواع المضمّنة إلى التلميحات المرفقة. أنواعك الأخرى دون تغيير.‏';

  @override
  String extractionHistoryKindCount(String name, int count) {
    return '$name: $count';
  }

  @override
  String get ledgerKindFilterAll => 'الكل';

  @override
  String ledgerNoteLabel(String note) {
    return 'ملاحظة: $note';
  }

  @override
  String get ledgerNoteFieldLabel => 'ملاحظة';

  @override
  String ledgerKindCount(String name, int count) {
    return '$name: $count';
  }

  @override
  String reviewKindGeneric(String name) {
    return '$name';
  }

  @override
  String get extractionCustomKindsGuidance =>
      'استخرج أيضاً كل تطابق للأنواع المخصّصة المفعّلة في الكتالوج (مثل names أو groceries أو follow-ups). الإشارات غير الرسمية تُحسب إن طابق التلميح. لا تتخطَّ نوعاً مخصّصاً لأن السطر ليس التزاماً أو قراراً رسمياً. لا تُخرج decision أو commitment ما لم يكونا في قائمة المفعّل. مثال: المحادثة \"Emila did pick up her child Manolis from school\" مع النوع names يجب أن تُنتج مرشّحين لـ Emila وManolis ببيانات قصيرة واقتباسات من الجملة.‏';

  @override
  String get captureUrlFieldLabel => 'رابط موقع ويب';

  @override
  String get captureUrlFieldHint => 'https://example.com/article';

  @override
  String get captureUrlFetchButton => 'جلب نص الصفحة';

  @override
  String get captureUrlFetching => 'جارٍ جلب الصفحة…‏';

  @override
  String get captureUrlHelp =>
      'الصق رابطاً أو شارك عنوان صفحة، ثم اجلب النص الرئيسي للاستخراج.‏';

  @override
  String get captureUrlInvalid => 'أدخل رابط http أو https صالحاً.‏';

  @override
  String get captureUrlFetchFailed =>
      'تعذّر جلب تلك الصفحة. الصق النص بدلاً من ذلك.‏';

  @override
  String get sourceConversationWebsiteLabel => 'من موقع ويب';

  @override
  String get sourceConversationOpenWebsite => 'فتح الصفحة';

  @override
  String get conversationUnarchiveTitle => 'استعادة إلى النشطة؟‏';

  @override
  String get conversationUnarchiveBody =>
      'سيُعاد نقل المحادثة إلى النشطة حتى تتمكن من الاستخراج منها مرة أخرى.‏';

  @override
  String get conversationUnarchiveConfirm => 'استعادة‏';

  @override
  String get conversationUnarchiveSuccess => 'أُعيدت المحادثة إلى النشطة.‏';

  @override
  String get conversationUnarchiveFailed =>
      'تعذّر استعادة المحادثة. حاول مرة أخرى.‏';

  @override
  String get conversationUnarchiveHint => 'اضغط مطوّلاً للاستعادة‏';

  @override
  String get extractionKindExamplesIncomplete =>
      'أكمل كل مثال تعليمي (عنوان السجل واقتباس الدليل) أو احذفه قبل الحفظ.‏';

  @override
  String get extractionHistoryDetailTitle => 'تفاصيل الاستخراج';

  @override
  String get extractionHistoryResultsTitle => 'النتائج';

  @override
  String get extractionHistoryKindsTitle => 'الأنواع المفعّلة';

  @override
  String get extractionHistoryNoKinds => 'لا أنواع مسجّلة لهذا التشغيل.‏';

  @override
  String get extractionHistorySourceTitle => 'محادثة الإدخال';

  @override
  String get extractionHistorySourceMissing =>
      'محادثة المصدر لم تعد متاحة على هذا الجهاز.‏';

  @override
  String get extractionHistoryOpenSource => 'فتح المحادثة';

  @override
  String get appUpdateAvailableTitle => 'يتوفر تحديث‏';

  @override
  String appUpdateAvailableBody(String latestVersion, String installedVersion) {
    return 'يتوفر الإصدار $latestVersion من كوريڤيل. إصدارك هو $installedVersion. حدّث عندما تستطيع عبر Play — أو اختر لاحقاً وسنذكّرك خلال أسبوع.‏';
  }

  @override
  String get appUpdateLater => 'لاحقاً';

  @override
  String get appUpdateOpenStore => 'فتح متجر Play‏';

  @override
  String get teachingStatementHelp =>
      'اسم قصير لخانة اختيار السجل (حليب، سكر). وليس جملة كاملة.‏';

  @override
  String get teachingSourceSentenceHelp =>
      'الجملة الكاملة من محادثة تذكر العنصر.‏';

  @override
  String get teachingQuoteHelp =>
      'بضع كلمات حرفية من المحادثة كدليل (نحتاج حليباً). يجب أن يختلف عن عنوان السجل.‏';

  @override
  String get teachingSourceSentenceVsQuote =>
      'سطر المحادثة هو الجملة الداعمة كاملة. اقتباس الدليل هو كلمات الإثبات داخلها فقط. عنوان السجل هو التسمية القصيرة للمراجعة أو التأشير.‏';

  @override
  String get extractionSystemCommitmentRules =>
      'COMMITMENT: شخص مسمّى يقبل عملاً (التزم صراحةً، سيسلّم، سأجهّز بحلول). عيّن owner لذلك الشخص. استخدم kind \"commitment\" فقط.‏';

  @override
  String get extractionSystemDecisionRules =>
      'DECISION: اتجاه مُثبَّت (قرر الفريق رسمياً، المضي قدماً بالخيار). فضّل الاختيار النهائي. owner عادة null. استخدم kind \"decision\" فقط. dueDate دائماً null.‏';

  @override
  String extractionSystemBuiltInExamplesBoth(
    String openBrace,
    String closeBrace,
  ) {
    return 'مثال 1:\nالمحادثة: خلال مزامنة اليوم التزم أليكس صراحةً بتسليم وثائق API بحلول 15 أكتوبر. قيّمنا تصميمين للصفحة الرئيسية وقرر الفريق رسمياً المضي قدماً بالخيار أ. ذكر مارك أنه قد يراجع أداء قاعدة البيانات دون التزام رسمي.\nالإجابة: $openBrace\"candidates\":[$openBrace\"kind\":\"commitment\",\"statement\":\"أليكس سيسلّم وثائق API بحلول 15 أكتوبر\",\"owner\":\"Alex\",\"dueDate\":\"2026-10-15\",\"quoteSnippet\":\"التزم أليكس صراحةً بتسليم وثائق API بحلول 15 أكتوبر\"$closeBrace,$openBrace\"kind\":\"decision\",\"statement\":\"المضي بالخيار أ للصفحة الرئيسية\",\"owner\":null,\"dueDate\":null,\"quoteSnippet\":\"قرر الفريق رسمياً المضي قدماً بالخيار أ\"$closeBrace]$closeBrace\n\nمثال 2 (حوار):\nالمحادثة: Alex: نمضي رسمياً مع Flutter.\nJamie: سأجهّز مخططات الخصوصية بحلول الجمعة.\nالإجابة: $openBrace\"candidates\":[$openBrace\"kind\":\"decision\",\"statement\":\"استخدام Flutter للعميل المحمول\",\"owner\":null,\"dueDate\":null,\"quoteSnippet\":\"نمضي رسمياً مع Flutter\"$closeBrace,$openBrace\"kind\":\"commitment\",\"statement\":\"Jamie سيجهّز مخططات موافقة الخصوصية بحلول الجمعة\",\"owner\":\"Jamie\",\"dueDate\":null,\"quoteSnippet\":\"سأجهّز مخططات الخصوصية بحلول الجمعة\"$closeBrace]$closeBrace‏';
  }

  @override
  String extractionSystemBuiltInExamplesDecision(
    String openBrace,
    String closeBrace,
  ) {
    return 'مثال (قرار فقط):\nالمحادثة: قيّمنا تصميمين وقرر الفريق رسمياً المضي قدماً بالخيار أ.\nالإجابة: $openBrace\"candidates\":[$openBrace\"kind\":\"decision\",\"statement\":\"المضي بالخيار أ\",\"owner\":null,\"dueDate\":null,\"quoteSnippet\":\"قرر الفريق رسمياً المضي قدماً بالخيار أ\"$closeBrace]$closeBrace‏';
  }

  @override
  String extractionSystemBuiltInExamplesCommitment(
    String openBrace,
    String closeBrace,
  ) {
    return 'مثال (التزام فقط):\nالمحادثة: التزم أليكس صراحةً بتسليم وثائق API بحلول 15 أكتوبر. قد يراجع مارك الأداء لاحقاً.\nالإجابة: $openBrace\"candidates\":[$openBrace\"kind\":\"commitment\",\"statement\":\"أليكس سيسلّم وثائق API بحلول 15 أكتوبر\",\"owner\":\"Alex\",\"dueDate\":\"2026-10-15\",\"quoteSnippet\":\"التزم أليكس صراحةً بتسليم وثائق API بحلول 15 أكتوبر\"$closeBrace]$closeBrace‏';
  }

  @override
  String get extractionCustomKindsOnePerItemGuidance =>
      'مرشّح واحد لكل عنصر: عندما يذكر السطر عدة مطابقات (حليب وبيض وخبز؛ Alice وBob) أو يذكر سطر مكوّن مُقاس عنصراً (1.5 كوب دقيق متعدد الأغراض؛ 3 ملاعق كبيرة زبدة مذابة؛ بيضة واحدة) أخرج مرشّحاً منفصلاً لكل مطابقة. يجب أن يكون statement اسم العنصر القصير وحده (دقيق، بيكنغ باودر، حليب، زبدة، بيض، Emila) — وليس السطر المقاس كاملاً ولا اشترِ حليباً. quoteSnippet كلمات دليل من المحادثة ويجب أن يختلف عن statement. لا تدمج قائمة كاملة في مرشّح واحد. لا تتخطَّ قوائم المكوّنات فقط لأنها في وصفة.‏';

  @override
  String get extractionPromptDueDateClause =>
      ' عندما يسمح النوع بالتاريخ عيّن dueDate بصيغة ISO عند ذكر يوم تقويمي (مثل 15 أكتوبر). أيام الأسبوع مثل الجمعة تبقى null. المواعيد النسبية (الأسبوع القادم، نهاية اليوم) تبقى null.‏';

  @override
  String get extractionKindTeachingWalkthroughTitle => 'مثال للحقلين';

  @override
  String get extractionKindTeachingWalkthroughBody =>
      'قالت المحادثة: \"ما زلنا نحتاج حليباً وسكراً.\"\n• عنوان السجل: حليب\n• اقتباس الدليل: نحتاج حليباً\nأضف مثالاً آخر للسكر بالطريقة نفسها — اسم قصير لكل مثال.‏';

  @override
  String get extractionKindInsertSampleExample => 'إدراج مثال جاهز';

  @override
  String get extractionKindSampleExcerptMilk =>
      'ما زلنا نحتاج حليباً لهذا الأسبوع.';

  @override
  String get extractionKindSampleQuoteMilk => 'نحتاج حليباً';

  @override
  String get extractionKindSampleStatementMilk => 'حليب';

  @override
  String get extractionKindSampleExcerptEggs => 'أضف بيضتين إلى العجينة.';

  @override
  String get extractionKindSampleQuoteEggs => 'بيضتين';

  @override
  String get extractionKindSampleStatementEggs => 'بيض';

  @override
  String get extractionKindSampleExcerptBread => 'كوب سكر';

  @override
  String get extractionKindSampleQuoteBread => 'كوب سكر';

  @override
  String get extractionKindSampleStatementBread => 'سكر';
}
