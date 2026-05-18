import 'package:flutter/material.dart';
import 'package:spend_wise/app/shell/models/shell_destination.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expenses_page.dart';
import 'package:spend_wise/features/recurring/presentation/pages/recurring_expenses_page.dart';
import 'package:spend_wise/features/recurring/presentation/widgets/recurring_expense_form_page.dart';

List<ShellDestination> buildShellDestinations() {
  return [
    const ShellDestination(
      title: 'Dashboard',
      label: 'Dashboard',
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard,
      page: DashboardPage(showScaffold: false),
    ),
    ShellDestination(
      title: 'Expenses',
      label: 'Expenses',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      page: const ExpensesPage(showScaffold: false),
      fab: (context) => ExpensesPage.openExpenseFormPage(context),
      fabIcon: Icons.add,
    ),
    ShellDestination(
      title: 'Recurring',
      label: 'Recurring',
      icon: Icons.repeat_outlined,
      selectedIcon: Icons.repeat,
      page: RecurringExpensesPage(showScaffold: false),
      fab: (context) => RecurringExpenseFormPage.open(context),
      fabIcon: Icons.add,
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
