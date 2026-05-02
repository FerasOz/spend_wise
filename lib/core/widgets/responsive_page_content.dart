import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsivePageContent extends StatelessWidget {
  const ResponsivePageContent({
    required this.child,
    super.key,
    this.maxWidth = 720,
    this.mobilePadding = 16,
    this.desktopPadding = 24,
  });

  final Widget child;
  final double maxWidth;
  final double mobilePadding;
  final double desktopPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 700
            ? desktopPadding.w
            : mobilePadding.w;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth.w),
            child: Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
