import 'package:flutter/material.dart';

class AppFadeSlide extends StatelessWidget {
  const AppFadeSlide({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 320),
    this.offset = const Offset(0, .08),
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration + delay,
      curve: curve,
      builder: (context, value, child) {
        final delayedProgress = _progressAfterDelay(value);

        return Opacity(
          opacity: delayedProgress,
          child: Transform.translate(
            offset: Offset(
              offset.dx * (1 - delayedProgress),
              offset.dy *
                  MediaQuery.sizeOf(context).height *
                  (1 - delayedProgress),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  double _progressAfterDelay(double value) {
    final totalMs = duration.inMilliseconds + delay.inMilliseconds;
    if (totalMs == 0) return 1;

    final delayFraction = delay.inMilliseconds / totalMs;
    if (value <= delayFraction) return 0;

    final normalized = (value - delayFraction) / (1 - delayFraction);
    return normalized.clamp(0, 1).toDouble();
  }
}
