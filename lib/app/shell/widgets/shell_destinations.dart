import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/app/shell/models/shell_destination.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expenses_page.dart';
import 'package:spend_wise/features/recurring/presentation/pages/recurring_expense_form_page.dart';
import 'package:spend_wise/features/recurring/presentation/pages/recurring_expenses_page.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

List<ShellDestination> buildShellDestinations() {
  return [
    ShellDestination(
      title: LocaleKeys.navigation_dashboard.tr(),
      label: LocaleKeys.navigation_dashboard.tr(),
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard,
      page: DashboardPage(showScaffold: false),
    ),
    ShellDestination(
      title: LocaleKeys.navigation_expenses.tr(),
      label: LocaleKeys.navigation_expenses.tr(),
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      page: const ExpensesPage(showScaffold: false),
      fab: (context) => ExpensesPage.openExpenseFormPage(context),
      fabIcon: Icons.add,
    ),
    ShellDestination(
      title: LocaleKeys.navigation_recurring.tr(),
      label: LocaleKeys.navigation_recurring.tr(),
      icon: Icons.repeat_outlined,
      selectedIcon: Icons.repeat,
      page: RecurringExpensesPage(showScaffold: false),
      fab: (context) => RecurringExpenseFormPage.open(context),
      fabIcon: Icons.add,
    ),
    ShellDestination(
      title: LocaleKeys.navigation_categories.tr(),
      label: LocaleKeys.navigation_categories.tr(),
      icon: Icons.category_outlined,
      selectedIcon: Icons.category,
      page: const CategoryListPage(showScaffold: false),
      fab: (context) => CategoryListPage.openCategoryFormPage(context),
      fabIcon: Icons.add,
    ),
  ];
}
