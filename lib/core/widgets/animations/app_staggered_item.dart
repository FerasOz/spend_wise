import 'package:flutter/material.dart';
import 'app_fade_slide.dart';

class AppStaggeredItem extends StatelessWidget {
  const AppStaggeredItem({
    required this.index,
    required this.child,
    this.maxDelay = const Duration(milliseconds: 180),
    super.key,
  });

  final int index;
  final Widget child;
  final Duration maxDelay;

  @override
  Widget build(BuildContext context) {
    final delayMs = (index * 45).clamp(0, maxDelay.inMilliseconds);

    return AppFadeSlide(
      delay: Duration(milliseconds: delayMs),
      child: child,
    );
  }
}
