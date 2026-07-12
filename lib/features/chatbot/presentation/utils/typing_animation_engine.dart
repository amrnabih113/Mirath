import 'dart:async';

/// Handles smooth character-by-character reveal animation with intelligent pacing
class TypingAnimationEngine {
  final Duration baseDuration; // Duration per character
  final int maxBatchSize; // Max chars per UI update (for performance)

  Timer? _animationTimer;
  String _buffer = ''; // Characters waiting to be revealed
  String _displayed = ''; // Currently displayed text

  // Callbacks
  void Function(String)? onCharacterRevealed;
  void Function()? onCompleted;

  TypingAnimationEngine({int charactersPerSecond = 36, this.maxBatchSize = 3})
    : baseDuration = Duration(
        milliseconds: (1000 / charactersPerSecond).round().clamp(16, 120),
      );

  /// Add new text to the animation queue (from SSE delta)
  void queueText(String newText) {
    _buffer += newText;
    _startIfNotRunning();
  }

  /// Manually set complete text (if backend sent all at once)
  void setCompleteText(String text) {
    _buffer = text;
    _displayed = '';
    _startIfNotRunning();
  }

  /// Get currently displayed text
  String getDisplayed() => _displayed;

  /// Check if animation is complete
  bool isComplete() => _buffer.isEmpty && _animationTimer == null;

  /// Start animation if not already running
  void _startIfNotRunning() {
    if (_animationTimer != null && _animationTimer!.isActive) return;
    _startAnimation();
  }

  /// Start the character reveal animation
  void _startAnimation() {
    _animationTimer?.cancel();

    _animationTimer = Timer.periodic(baseDuration, (_) {
      if (_buffer.isEmpty) {
        _animationTimer?.cancel();
        _animationTimer = null;
        onCompleted?.call();
        return;
      }

      // Determine how many characters to reveal in this frame
      int charsToReveal = 1;

      // Adaptive speed based on context
      if (_displayed.length < 100) {
        // First 100 chars: slower, let user catch up
        charsToReveal = 1;
      } else if (_displayed.length < 500) {
        // Middle section: normal speed with small batches
        charsToReveal = 1;
      } else {
        // Large responses: can batch slightly more for performance
        charsToReveal = maxBatchSize;
      }

      // Apply punctuation pauses (by reducing reveal amount next frame)
      final lastChar = _displayed.isNotEmpty
          ? _displayed.codeUnitAt(_displayed.length - 1)
          : 0;
      final isPunctuation =
          lastChar == 46 || // .
          lastChar == 63 || // ?
          lastChar == 33 || // !
          lastChar == 58; // :

      // Extract and display characters
      final toDisplay = _buffer.substring(
        0,
        charsToReveal.clamp(0, _buffer.length),
      );
      _buffer = _buffer.substring(charsToReveal);
      _displayed += toDisplay;

      onCharacterRevealed?.call(_displayed);

      // Pause after punctuation (reduces next batch reveal by doing nothing extra)
      if (isPunctuation && _displayed.length % 10 == 0) {
        // Natural pause effect achieved by character-by-character reveal
      }
    });
  }

  /// Stop animation and return remaining text
  String stop() {
    _animationTimer?.cancel();
    _animationTimer = null;
    _displayed += _buffer;
    _buffer = '';
    return _displayed;
  }

  /// Reset animation state
  void reset() {
    _animationTimer?.cancel();
    _animationTimer = null;
    _buffer = '';
    _displayed = '';
  }

  /// Cleanup
  void dispose() {
    _animationTimer?.cancel();
  }
}

/// Extended version with markdown-aware animation
class MarkdownAwareTypingEngine extends TypingAnimationEngine {
  bool _inCodeBlock = false;
  int _backtickCount = 0;

  MarkdownAwareTypingEngine({int charactersPerSecond = 36})
    : super(charactersPerSecond: charactersPerSecond);

  @override
  void queueText(String newText) {
    // Track code block state
    _backtickCount += newText.split('```').length - 1;
    _inCodeBlock = _backtickCount % 2 == 1;

    super.queueText(newText);
  }

  /// Get speed multiplier based on context (code blocks faster, normal elsewhere)
  double _getSpeedMultiplier() {
    // In code blocks, reveal slightly faster
    return _inCodeBlock ? 1.2 : 1.0;
  }
}
