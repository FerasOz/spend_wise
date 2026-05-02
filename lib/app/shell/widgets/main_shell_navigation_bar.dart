import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/app/shell/models/shell_destination.dart';

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

          return TextStyle(
            fontSize: 12.sp,
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
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: item.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
