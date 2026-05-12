import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextTheme buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      headlineSmall: TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
