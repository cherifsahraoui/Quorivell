import 'package:freezed_annotation/freezed_annotation.dart';

part 'extraction_run.freezed.dart';
part 'extraction_run.g.dart';

enum ExtractionRunStatus { success, failure }

@freezed
abstract class ExtractionRun with _$ExtractionRun {
  const ExtractionRun._();

  const factory ExtractionRun({
    required String id,
    required String userId,
    String? sourceConversationId,
    String? sourceConversationTitle,
    required String modelId,
    String? modelDisplayName,
    required DateTime startedAt,
    required DateTime completedAt,
    required ExtractionRunStatus status,
    required int durationMs,
    @Default(['decision', 'commitment']) List<String> enabledKindSlugs,
    @Default({}) Map<String, int> kindCounts,
    @Default(0) int acceptedCount,
    @Default(0) int rejectedCount,
    @Default(0) int pendingCount,
  }) = _ExtractionRun;

  int get decisionCount => kindCounts['decision'] ?? 0;

  int get commitmentCount => kindCounts['commitment'] ?? 0;

  factory ExtractionRun.fromJson(Map<String, dynamic> json) =>
      _$ExtractionRunFromJson(json);
}
