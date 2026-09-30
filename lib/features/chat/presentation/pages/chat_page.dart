import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../assistant/presentation/controllers/review_controller.dart';
import '../../../meeting_notes/presentation/controllers/incoming_share_controller.dart';
import '../../../onboarding/presentation/local_model_required_dialog.dart';
import '../../data/providers/chat_providers.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../controllers/chat_session_controller.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_message_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _composerController = TextEditingController();
  final _listController = ScrollController();
  var _listScrollable = false;
  var _processTextBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_consumeIncomingProcessText());
    });
  }

  @override
  void dispose() {
    _composerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _setListScrollable(bool scrollable) {
    if (_listScrollable == scrollable) return;
    setState(() => _listScrollable = scrollable);
  }

  Future<void> _send() async {
    if (ref.read(extractionRunningControllerProvider)) return;
    final text = _composerController.text;
    final gate = await ensureLocalModelConfigured(context: context, ref: ref);
    if (!mounted) return;
    switch (gate) {
      case LocalModelGateResult.configure:
        context.go('/account/model');
        return;
      case LocalModelGateResult.dismissed:
        return;
      case LocalModelGateResult.ready:
        break;
    }
    _composerController.clear();
    await ref.read(chatSessionControllerProvider.notifier).send(text);
  }

  Future<void> _consumeIncomingProcessText() async {
    if (_processTextBusy) return;
    final pending = ref.read(incomingShareControllerProvider);
    if (pending == null || !pending.isProcessText) return;
    if (ref.read(extractionRunningControllerProvider)) return;
    if (ref.read(chatSessionControllerProvider).isGenerating) return;

    _processTextBusy = true;
    try {
      final gate = await ensureLocalModelConfigured(context: context, ref: ref);
      if (!mounted) return;
      switch (gate) {
        case LocalModelGateResult.configure:
          context.go('/account/model');
          return;
        case LocalModelGateResult.dismissed:
          return;
        case LocalModelGateResult.ready:
          break;
      }
      ref.read(incomingShareControllerProvider.notifier).discard();
      await ref
          .read(chatSessionControllerProvider.notifier)
          .sendSummarizeSelection(pending.text);
    } finally {
      _processTextBusy = false;
    }
  }

  void _applySuggestion(String suggestion) {
    if (ref.read(extractionRunningControllerProvider)) return;
    _composerController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Watch session chrome only. Streaming tokens must not rebuild the
    // transcript list or composer — that is what flashed the growing bubble.
    final threadId = ref.watch(
      chatSessionControllerProvider.select((s) => s.threadId),
    );
    final isGenerating = ref.watch(
      chatSessionControllerProvider.select((s) => s.isGenerating),
    );
    final autoScrollEnabled = ref.watch(
      chatSessionControllerProvider.select((s) => s.autoScrollEnabled),
    );
    final sendFailure = ref.watch(
      chatSessionControllerProvider.select((s) => s.sendFailure),
    );
    final showStreaming = ref.watch(
      chatSessionControllerProvider.select(
        (s) => s.isGenerating || s.streamingText.isNotEmpty,
      ),
    );
    final isExtracting = ref.watch(extractionRunningControllerProvider);
    ref.listen(incomingShareControllerProvider, (previous, next) {
      if (next != null && next.isProcessText && next.id != previous?.id) {
        unawaited(_consumeIncomingProcessText());
      }
    });
    final thread = threadId == null
        ? null
        : ref.watch(chatThreadByIdProvider(threadId));
    final messages = threadId == null
        ? null
        : ref.watch(chatMessagesProvider(threadId));

    final title = thread?.asData?.value?.title ?? l10n.chatTitle;
    final hasTranscript =
        (messages?.asData?.value.isNotEmpty ?? false) || isGenerating;
    final chatEnabled = !isExtracting;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final current = ref.read(chatSessionControllerProvider);
        if (current.threadId != null &&
            !current.draftNew &&
            !current.isGenerating) {
          ref.read(chatSessionControllerProvider.notifier).startNewChat();
        }
        _composerController.clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_square),
              tooltip: l10n.chatNewTooltip,
              onPressed: isGenerating || isExtracting
                  ? null
                  : () => ref
                        .read(chatSessionControllerProvider.notifier)
                        .startNewChat(),
            ),
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: l10n.chatHistoryTooltip,
              onPressed: () => context.push('/chat/threads'),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _ChatBody(
                    isGenerating: isGenerating,
                    showStreaming: showStreaming,
                    streamingText: () =>
                        ref.read(chatSessionControllerProvider).streamingText,
                    messages: messages,
                    listController: _listController,
                    autoScrollEnabled: autoScrollEnabled,
                    suggestionsEnabled: chatEnabled,
                    onSuggestion: _applySuggestion,
                    onNearBottomChanged: (nearBottom) {
                      ref
                          .read(chatSessionControllerProvider.notifier)
                          .setAutoScrollEnabled(nearBottom);
                    },
                    onScrollableChanged: _setListScrollable,
                  ),
                  if (hasTranscript && _listScrollable)
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      end: AppSpacing.md,
                      bottom: AppSpacing.md,
                      child: _ChatAutoScrollButton(
                        enabled: autoScrollEnabled,
                        onPressed: () {
                          ref
                              .read(chatSessionControllerProvider.notifier)
                              .setAutoScrollEnabled(true);
                          if (_listController.hasClients) {
                            _listController.jumpTo(
                              _listController.position.maxScrollExtent,
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            if (isExtracting)
              const _ChatExtractionPausedBanner()
            else if (sendFailure != null)
              _ChatSendErrorBanner(
                message: failureMessage(l10n, sendFailure),
                onRetry: threadId == null
                    ? null
                    : () => ref
                          .read(chatSessionControllerProvider.notifier)
                          .retry(),
              ),
            ChatComposer(
              controller: _composerController,
              enabled: chatEnabled,
              isGenerating: isGenerating,
              onSend: _send,
              onStop: () =>
                  ref.read(chatSessionControllerProvider.notifier).stop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({
    required this.isGenerating,
    required this.showStreaming,
    required this.streamingText,
    required this.messages,
    required this.listController,
    required this.autoScrollEnabled,
    required this.suggestionsEnabled,
    required this.onSuggestion,
    required this.onNearBottomChanged,
    required this.onScrollableChanged,
  });

  final bool isGenerating;
  final bool showStreaming;
  final ValueGetter<String> streamingText;
  final AsyncValue<List<AiChatMessage>>? messages;
  final ScrollController listController;
  final bool autoScrollEnabled;
  final bool suggestionsEnabled;
  final ValueChanged<String> onSuggestion;
  final ValueChanged<bool> onNearBottomChanged;
  final ValueChanged<bool> onScrollableChanged;

  void _markNotScrollable() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onScrollableChanged(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (messages == null) {
      _markNotScrollable();
      return _ChatEmptyState(
        suggestionsEnabled: suggestionsEnabled,
        onSuggestion: onSuggestion,
      );
    }

    return messages!.when(
      loading: () {
        _markNotScrollable();
        return const LoadingState();
      },
      error: (_, _) {
        _markNotScrollable();
        return EmptyState(
          icon: Icons.error_outline,
          title: l10n.chatUnavailable,
        );
      },
      data: (items) {
        if (items.isEmpty && !isGenerating) {
          _markNotScrollable();
          return _ChatEmptyState(
            suggestionsEnabled: suggestionsEnabled,
            onSuggestion: onSuggestion,
          );
        }
        return _ChatMessageList(
          controller: listController,
          messages: items,
          autoScrollEnabled: autoScrollEnabled,
          showStreaming:
              showStreaming &&
              chatShouldShowStreamingBubble(
                streamingText: streamingText(),
                messages: items,
              ),
          onNearBottomChanged: onNearBottomChanged,
          onScrollableChanged: onScrollableChanged,
          onCopied: () {
            // Feedback is shown under the tapped bubble.
          },
        );
      },
    );
  }
}

/// Distance from the newest edge that still counts as "pinned to latest".
@visibleForTesting
const chatNearBottomThreshold = 72.0;

@visibleForTesting
const chatStreamingItemKey = ValueKey<String>('chat-streaming');

/// Hides the in-flight bubble once Drift has caught up with the same text so
/// the completed row does not flash in as a duplicate.
@visibleForTesting
bool chatShouldShowStreamingBubble({
  required String streamingText,
  required List<AiChatMessage> messages,
}) {
  if (messages.isEmpty || streamingText.isEmpty) return true;
  final last = messages.last;
  return !(last.role == AiChatRole.assistant && last.content == streamingText);
}

/// Chronological (non-reverse) chat list: oldest at offset 0, newest at
/// [maxScrollExtent]. Growth at the newest edge leaves an unpinned viewport
/// alone — no reverse-list compensation needed.
///
/// When pinned ([autoScrollEnabled]) and not mid-gesture, stick to
/// [nextMaxScrollExtent] so streaming tokens keep the latest reply in view.
/// Never override an active user scroll — that trapped readers at the bottom.
@visibleForTesting
double? chatPinToBottomCorrection({
  required bool autoScrollEnabled,
  required double nextMaxScrollExtent,
  bool isScrolling = false,
}) {
  if (!autoScrollEnabled || isScrolling) return null;
  return nextMaxScrollExtent;
}

/// Pins a chronological chat list to the newest edge while auto-scroll is on.
class ChatPinToBottomScrollPhysics extends ClampingScrollPhysics {
  const ChatPinToBottomScrollPhysics({
    super.parent,
    required this.autoScrollEnabled,
  });

  final ValueGetter<bool> autoScrollEnabled;

  @override
  ChatPinToBottomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ChatPinToBottomScrollPhysics(
      parent: buildParent(ancestor),
      autoScrollEnabled: autoScrollEnabled,
    );
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    final pinned = chatPinToBottomCorrection(
      autoScrollEnabled: autoScrollEnabled(),
      nextMaxScrollExtent: newPosition.maxScrollExtent,
      isScrolling: isScrolling,
    );
    if (pinned != null) return pinned;
    return super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );
  }
}

@visibleForTesting
bool chatListIsNearBottom({
  required double pixels,
  required double maxScrollExtent,
  double threshold = chatNearBottomThreshold,
}) {
  return pixels >= maxScrollExtent - threshold;
}

/// True when the chat list has overflow content the user can scroll.
@visibleForTesting
bool chatListIsScrollable(double maxScrollExtent) => maxScrollExtent > 0;

class _ChatMessageList extends StatefulWidget {
  const _ChatMessageList({
    required this.controller,
    required this.messages,
    required this.autoScrollEnabled,
    required this.showStreaming,
    required this.onCopied,
    required this.onNearBottomChanged,
    required this.onScrollableChanged,
  });

  final ScrollController controller;
  final List<AiChatMessage> messages;
  final bool autoScrollEnabled;
  final bool showStreaming;
  final VoidCallback onCopied;
  final ValueChanged<bool> onNearBottomChanged;
  final ValueChanged<bool> onScrollableChanged;

  @override
  State<_ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<_ChatMessageList> {
  late final _physics = ChatPinToBottomScrollPhysics(
    autoScrollEnabled: () => widget.autoScrollEnabled,
  );
  var _pinScheduled = false;

  @override
  void initState() {
    super.initState();
    _scheduleScrollableCheck();
    _schedulePinToBottomIfEnabled();
  }

  @override
  void didUpdateWidget(covariant _ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final autoScrollTurnedOn =
        !oldWidget.autoScrollEnabled && widget.autoScrollEnabled;
    final contentChanged =
        oldWidget.messages.length != widget.messages.length ||
        oldWidget.showStreaming != widget.showStreaming;
    if (autoScrollTurnedOn || (contentChanged && widget.autoScrollEnabled)) {
      // First layout skips adjustPositionForNewDimensions; pin after the frame.
      _schedulePinToBottomIfEnabled();
    }
    if (contentChanged || autoScrollTurnedOn) {
      _scheduleScrollableCheck();
    }
  }

  void _schedulePinToBottomIfEnabled() {
    if (!widget.autoScrollEnabled || _pinScheduled) return;
    _pinScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinScheduled = false;
      if (!mounted || !widget.controller.hasClients) return;
      if (!widget.autoScrollEnabled) return;
      final position = widget.controller.position;
      // Do not fight an in-progress drag / fling; wait until idle.
      if (position.isScrollingNotifier.value) return;
      if ((position.maxScrollExtent - position.pixels).abs() < 1) return;
      widget.controller.jumpTo(position.maxScrollExtent);
    });
  }

  void _scheduleScrollableCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notifyScrollable();
    });
  }

  void _notifyScrollable() {
    if (!widget.controller.hasClients) {
      widget.onScrollableChanged(false);
      return;
    }
    widget.onScrollableChanged(
      chatListIsScrollable(widget.controller.position.maxScrollExtent),
    );
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (!widget.controller.hasClients) return;
    if (notification is ScrollUpdateNotification ||
        notification is ScrollEndNotification ||
        notification is UserScrollNotification) {
      _notifyScrollable();
    }
    // Chronological list, AxisDirection.down: reverse = toward older turns.
    // Unpin immediately so streaming growth cannot yank the viewport back.
    if (notification is UserScrollNotification &&
        notification.direction == ScrollDirection.reverse) {
      widget.onNearBottomChanged(false);
      return;
    }
    final fromUser =
        notification is UserScrollNotification ||
        notification is ScrollEndNotification ||
        (notification is ScrollUpdateNotification &&
            notification.dragDetails != null);
    if (fromUser) {
      final position = widget.controller.position;
      widget.onNearBottomChanged(
        chatListIsNearBottom(
          pixels: position.pixels,
          maxScrollExtent: position.maxScrollExtent,
        ),
      );
    }
  }

  int? _childIndexOf(Key key) {
    if (key is! ValueKey<String>) return null;
    final id = key.value;
    if (id == chatStreamingItemKey.value) {
      return widget.showStreaming ? widget.messages.length : null;
    }
    final messageIndex = widget.messages.indexWhere(
      (message) => message.id == id,
    );
    if (messageIndex < 0) return null;
    return messageIndex;
  }

  @override
  Widget build(BuildContext context) {
    final showStreaming = widget.showStreaming;
    final count = widget.messages.length + (showStreaming ? 1 : 0);

    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (_) {
        _notifyScrollable();
        // Streaming tokens grow the trailing bubble without rebuilding this
        // list; re-pin after metrics settle when auto-scroll is on.
        _schedulePinToBottomIfEnabled();
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleScrollNotification(notification);
          return false;
        },
        child: ListView.builder(
          controller: widget.controller,
          physics: _physics,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xxl,
          ),
          findChildIndexCallback: _childIndexOf,
          itemCount: count,
          itemBuilder: (context, index) {
            if (showStreaming && index == widget.messages.length) {
              return const _ChatStreamingBubbleSlot(key: chatStreamingItemKey);
            }
            final message = widget.messages[index];
            return ChatMessageBubble(
              key: ValueKey(message.id),
              message: message,
              onCopied: widget.onCopied,
            );
          },
        ),
      ),
    );
  }
}

class _ChatStreamingBubbleSlot extends ConsumerWidget {
  const _ChatStreamingBubbleSlot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(
      chatSessionControllerProvider.select((s) => s.streamingText),
    );
    return ChatStreamingBubble(text: text);
  }
}

class _ChatEmptyState extends StatelessWidget {
  const _ChatEmptyState({
    required this.suggestionsEnabled,
    required this.onSuggestion,
  });

  final bool suggestionsEnabled;
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final suggestions = [
      l10n.chatSuggestion1,
      l10n.chatSuggestion2,
      l10n.chatSuggestion3,
    ];
    final short = EmptyState.useCompactLayout(context);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      children: [
        EmptyState(
          icon: Icons.auto_awesome,
          title: l10n.chatEmptyTitle,
          subtitle: l10n.chatEmptySubtitle,
        ),
        Center(
          child: TextButton(
            onPressed: () => context.push('/account/extraction'),
            child: Text(l10n.chatEmptyExtractionSettingsLink),
          ),
        ),
        SizedBox(height: short ? AppSpacing.md : AppSpacing.lg),
        Wrap(
          alignment: short ? WrapAlignment.start : WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final suggestion in suggestions)
              ActionChip(
                label: Text(suggestion),
                onPressed: suggestionsEnabled
                    ? () => onSuggestion(suggestion)
                    : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _ChatAutoScrollButton extends StatelessWidget {
  const _ChatAutoScrollButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: AppSpacing.xxl,
      height: AppSpacing.xxl,
      child: FloatingActionButton.small(
        heroTag: 'chatAutoScroll',
        tooltip: enabled
            ? l10n.chatAutoScrollOnTooltip
            : l10n.chatAutoScrollOffTooltip,
        onPressed: onPressed,
        child: Icon(
          enabled
              ? Icons.keyboard_double_arrow_down
              : Icons.pause_circle_outline,
        ),
      ),
    );
  }
}

class _ChatExtractionPausedBanner extends StatelessWidget {
  const _ChatExtractionPausedBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              Icons.hourglass_top_outlined,
              color: colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l10n.chatDisabledDuringExtraction,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatSendErrorBanner extends StatelessWidget {
  const _ChatSendErrorBanner({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: Text(l10n.chatRetryLabel)),
          ],
        ),
      ),
    );
  }
}
