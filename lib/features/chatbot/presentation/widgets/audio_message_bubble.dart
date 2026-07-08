import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../data/models/chatbot_message_attachment.dart';

class AudioMessageBubble extends StatefulWidget {
  final MessageAttachment attachment;
  final bool isUser;

  const AudioMessageBubble({
    super.key,
    required this.attachment,
    required this.isUser,
  });

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  final AudioPlayer _player = AudioPlayer();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool _isPlaying = false;
  bool _isLoading = true;

  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _stateSub;

  late final String _source;

  @override
  void initState() {
    super.initState();

    _source = widget.attachment.url?.isNotEmpty == true
        ? widget.attachment.url!
        : widget.attachment.localPath!;

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final uri = Uri.tryParse(_source);
      final isRemote = uri != null && uri.hasScheme && uri.host.isNotEmpty;

      if (isRemote) {
        await _player.setSource(UrlSource(_source));
      } else {
        await _player.setSource(DeviceFileSource(_source));
      }

      // use saved duration immediately
      if (widget.attachment.durationSeconds != null) {
        _duration = Duration(seconds: widget.attachment.durationSeconds!);
      }

      final d = await _player.getDuration();
      if (d != null) {
        _duration = d;
      }

      _durationSub = _player.onDurationChanged.listen((d) {
        if (!mounted) return;
        setState(() => _duration = d);
      });

      _positionSub = _player.onPositionChanged.listen((p) {
        if (!mounted) return;
        setState(() => _position = p);
      });

      _stateSub = _player.onPlayerStateChanged.listen((state) {
        if (!mounted) return;

        switch (state) {
          case PlayerState.playing:
            setState(() => _isPlaying = true);
            break;

          case PlayerState.paused:
          case PlayerState.stopped:
            setState(() => _isPlaying = false);
            break;

          case PlayerState.completed:
            _player.seek(Duration.zero);

            setState(() {
              _position = Duration.zero;
              _isPlaying = false;
            });
            break;

          default:
            break;
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePlayback() async {
    if (_isLoading) return;

    if (_isPlaying) {
      await _player.pause();
      return;
    }

    if (_position >= _duration && _duration != Duration.zero) {
      await _player.seek(Duration.zero);
    }

    await _player.play(
      _source.startsWith('http')
          ? UrlSource(_source)
          : DeviceFileSource(_source),
    );
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _stateSub?.cancel();

    _player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration == Duration.zero
        ? 0.0
        : (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);

    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isUser ? MyColors.primaryShade100 : MyColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MyColors.primaryShade200),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: _isLoading ? null : _togglePlayback,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.primaryShade700,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (_, constraints) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) async {
                        if (_duration == Duration.zero) return;

                        final dx = details.localPosition.dx.clamp(
                          0.0,
                          constraints.maxWidth,
                        );

                        final percent = dx / constraints.maxWidth;

                        await _player.seek(
                          Duration(
                            milliseconds: (_duration.inMilliseconds * percent)
                                .round(),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 36,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 80),
                          builder: (_, value, __) {
                            return CustomPaint(
                              painter: _WaveformPainter(progress: value),
                              child: const SizedBox.expand(),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Spacer(),
                    Text(
                      "${_format(_position)} / ${_format(_duration)}",
                      style: context.bodySmall.copyWith(
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double progress;

  _WaveformPainter({required this.progress});

  static const List<double> bars = [
    .18,
    .35,
    .62,
    .45,
    .85,
    .42,
    .30,
    .58,
    .92,
    .48,
    .40,
    .78,
    .55,
    .28,
    .66,
    .82,
    .50,
    .26,
    .73,
    .96,
    .54,
    .40,
    .67,
    .36,
    .86,
    .44,
    .58,
    .78,
    .34,
    .64,
    .82,
    .47,
    .72,
    .39,
    .91,
  ];
  @override
  void paint(Canvas canvas, Size size) {
    final playedPaint = Paint()
      ..color = MyColors.primaryShade700
      ..strokeCap = StrokeCap.round;

    final remainingPaint = Paint()
      ..color = MyColors.primaryShade200
      ..strokeCap = StrokeCap.round;

    final playheadPaint = Paint()..color = MyColors.primaryShade700;

    const barWidth = 3.0;
    const spacing = 3.0;

    final totalWidth = bars.length * barWidth + (bars.length - 1) * spacing;

    final startX = (size.width - totalWidth) / 2;

    final progressX = startX + totalWidth * progress.clamp(0.0, 1.0);

    for (int i = 0; i < bars.length; i++) {
      final x = startX + i * (barWidth + spacing);

      final barHeight = bars[i] * size.height;

      final top = (size.height - barHeight) / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, barWidth, barHeight),
        const Radius.circular(30),
      );

      final center = x + barWidth / 2;

      canvas.drawRRect(
        rect,
        center <= progressX ? playedPaint : remainingPaint,
      );
    }

    canvas.drawCircle(Offset(progressX, size.height / 2), 5, playheadPaint);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
