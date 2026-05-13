import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/app/shell/models/shell_destination.dart';
import 'package:spend_wise/core/theme/app_colors.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class MainShellNavigationBar extends StatelessWidget {
  const MainShellNavigationBar({
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
    super.key,
  });

  final int currentIndex;
  final List<ShellDestination> destinations;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);

          return Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);

          return IconThemeData(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            size: 24.w,
          );
        }),
        indicatorColor: colorScheme.primaryContainer,
      ),
      child: NavigationBar(
        height: AppSpacing.spacing76.h,
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        surfaceTintColor: AppColors.transparent,
        animationDuration: const Duration(milliseconds: 260),
        onDestinationSelected: onDestinationSelected,
        destinations: destinations
            .map(
              (item) => NavigationDestination(
                icon: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs.h),
                  child: Icon(item.icon),
                ),
                selectedIcon: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs.h),
                  child: Icon(item.selectedIcon),
                ),
                label: item.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
