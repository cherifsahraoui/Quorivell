import 'package:flutter_test/flutter_test.dart';

import 'package:quorivell/features/assistant/domain/entities/ai_processing_consent.dart';

AiProcessingConsent _consent({
  AiProcessingConsentStatus status = AiProcessingConsentStatus.unknown,
}) => AiProcessingConsent(status: status, updatedAt: DateTime.utc(2026, 9, 7));

void main() {
  test('compares by value', () {
    expect(_consent(), _consent());
  });

  test('round-trips through json', () {
    expect(AiProcessingConsent.fromJson(_consent().toJson()), _consent());
  });

  test('isAffirmative only after an explicit grant', () {
    expect(_consent().isAffirmative, isFalse);
    expect(
      _consent(status: AiProcessingConsentStatus.declined).isAffirmative,
      isFalse,
    );
    expect(
      _consent(status: AiProcessingConsentStatus.granted).isAffirmative,
      isTrue,
    );
  });
}
