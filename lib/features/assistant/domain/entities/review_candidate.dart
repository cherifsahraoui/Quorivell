import 'package:freezed_annotation/freezed_annotation.dart';

export '../../../../core/ai/built_in_kind_slugs.dart' show ReviewCandidateKind;

part 'review_candidate.freezed.dart';
part 'review_candidate.g.dart';

enum ReviewStatus { pending, accepted, rejected, deferred }

@freezed
abstract class ReviewCandidate with _$ReviewCandidate {
  const factory ReviewCandidate({
    required String id,
    required String userId,
    required String sourceConversationId,
    required int sourceRevision,
    required String kind,
    required String statement,
    required String? owner,
    required DateTime? dueDate,
    String? note,
    required int quoteStart,
    required int quoteEnd,
    required String quoteSnippet,
    required ReviewStatus reviewStatus,
  }) = _ReviewCandidate;

  factory ReviewCandidate.fromJson(Map<String, dynamic> json) =>
      _$ReviewCandidateFromJson(json);
}
