import 'package:flutter/material.dart';
import 'package:spend_wise/app/shell/models/shell_destination.dart';
import 'package:spend_wise/app/shell/widgets/shell_placeholder_page.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expenses_page.dart';

List<ShellDestination> buildShellDestinations() {
  return [
    const ShellDestination(
      title: 'Dashboard',
      label: 'Dashboard',
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard,
      page: ShellPlaceholderPage(
        icon: Icons.insights_outlined,
        title: 'Dashboard coming next',
        description:
            'This is a good place for monthly summaries, trends, and upcoming subscription renewals.',
      ),
    ),
    ShellDestination(
      title: 'Expenses',
      label: 'Expenses',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      page: const ExpensesPage(showScaffold: false),
      fab: (context) => ExpensesPage.openAddExpensePage(context),
      fabIcon: Icons.add,
    ),
    const ShellDestination(
      title: 'Subscriptions',
      label: 'Subscriptions',
      icon: Icons.subscriptions_outlined,
      selectedIcon: Icons.subscriptions,
      page: ShellPlaceholderPage(
        icon: Icons.notifications_active_outlined,
        title: 'Subscriptions coming next',
        description:
            'We will surface recurring payments, reminders, and renewal insights here.',
      ),
    ),
    ShellDestination(
      title: 'Categories',
      label: 'Categories',
      icon: Icons.category_outlined,
      selectedIcon: Icons.category,
      page: const CategoryListPage(showScaffold: false),
      fab: (context) => CategoryListPage.openCategoryFormPage(context),
      fabIcon: Icons.add,
    ),
  ];
}
