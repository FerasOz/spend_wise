import 'package:flutter/material.dart';

class ShellDestination {
  const ShellDestination({
    required this.title,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
    this.fab,
    this.fabIcon = Icons.add,
  });

  final String title;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;
  final void Function(BuildContext context)? fab;
  final IconData fabIcon;
}
