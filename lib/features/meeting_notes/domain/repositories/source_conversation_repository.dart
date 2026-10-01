import '../entities/source_conversation.dart';

abstract interface class SourceConversationRepository {
  /// Persists paste or fetched webpage text.
  ///
  /// [sourceUrl] is the original http(s) page when Capture fetched the text;
  /// omit or null for plain paste.
  Future<SourceConversation> capture(String content, {String? sourceUrl});

  /// Newest non-deleted, non-archived conversation.
  Future<SourceConversation?> latest();

  /// One-shot list of non-deleted, non-archived captures.
  ///
  /// Extract-all uses [newestFirst] `false` (oldest → newest). The Review
  /// chooser uses newest first so recent captures appear at the top.
  Future<List<SourceConversation>> listActive({int? limit, bool newestFirst});

  /// Watches captured conversations, newest first.
  ///
  /// [limit] and [offset] keep the query bounded as history grows.
  /// When [archivedOnly] is false, only active conversations are returned;
  /// when true, only archived (already extracted) conversations.
  Stream<List<SourceConversation>> watchAll({
    int limit,
    int offset,
    bool archivedOnly,
  });

  Future<SourceConversation?> find(String id);

  /// Soft-deletes a captured conversation so it no longer appears in history.
  Future<void> delete(String id);

  /// Marks a conversation as archived after it has been used for extraction.
  Future<void> archive(String id);

  /// Restores an archived conversation so it can be extracted again.
  Future<void> unarchive(String id);
}
