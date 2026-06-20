import 'package:flutter/material.dart';

/// Manages smart auto-scroll behavior during message streaming
class AutoScrollHelper {
  final ScrollController scrollController;
  final double scrollThreshold;

  /// Distance from bottom where auto-scroll should trigger (default 150px)
  bool _shouldAutoScroll = true;
  bool _userScrolling = false;

  AutoScrollHelper({
    required this.scrollController,
    this.scrollThreshold = 150.0,
  });

  /// Check if user is near bottom of scroll view
  bool isNearBottom() {
    if (!scrollController.hasClients) return true;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;

    return (maxScroll - currentScroll) < scrollThreshold;
  }

  /// Check if user is exactly at bottom
  bool isAtBottom() {
    if (!scrollController.hasClients) return true;
    return scrollController.offset >=
        scrollController.position.maxScrollExtent - 10;
  }

  /// Auto-scroll to bottom if user is near bottom
  void autoScrollIfNeeded() {
    if (!_shouldAutoScroll || !isNearBottom()) return;

    scrollToBottom();
  }

  /// Smooth scroll to bottom
  Future<void> scrollToBottom({
    Duration duration = const Duration(milliseconds: 200),
  }) async {
    if (!scrollController.hasClients) return;

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: duration,
      curve: Curves.easeOut,
    );
  }

  /// Jump to bottom immediately
  void jumpToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  /// Handle user scroll start (pause auto-scroll)
  void onUserScrollStart() {
    _userScrolling = true;
    _shouldAutoScroll = false;
  }

  /// Handle user scroll end (resume if near bottom)
  void onUserScrollEnd() {
    _userScrolling = false;

    // Resume auto-scroll if user ended scroll near bottom
    if (isNearBottom()) {
      _shouldAutoScroll = true;
    }
  }

  /// Reactivate auto-scroll (e.g., when user taps "scroll to latest" button)
  void reactivateAutoScroll() {
    _shouldAutoScroll = true;
    scrollToBottom();
  }

  /// Get remaining distance to bottom in pixels
  double getDistanceToBottom() {
    if (!scrollController.hasClients) return 0;
    return scrollController.position.maxScrollExtent - scrollController.offset;
  }

  /// Check if should show floating scroll button
  bool shouldShowFloatButton() {
    return !isNearBottom() && !_userScrolling;
  }

  /// Cleanup
  void dispose() {
    // Don't dispose the scroll controller here, let the parent handle it
  }
}

/// Widget that observes scroll and manages auto-scroll state
class AutoScrollObserver extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final void Function(bool isNearBottom)? onScrollPositionChanged;
  final double scrollThreshold;

  const AutoScrollObserver({
    Key? key,
    required this.scrollController,
    required this.child,
    this.onScrollPositionChanged,
    this.scrollThreshold = 150.0,
  }) : super(key: key);

  @override
  State<AutoScrollObserver> createState() => _AutoScrollObserverState();
}

class _AutoScrollObserverState extends State<AutoScrollObserver> {
  late ScrollPosition _lastPosition;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScrollChanged);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollChanged);
    super.dispose();
  }

  void _onScrollChanged() {
    if (!widget.scrollController.hasClients) return;

    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    final isNearBottom = (maxScroll - currentScroll) < widget.scrollThreshold;

    widget.onScrollPositionChanged?.call(isNearBottom);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
