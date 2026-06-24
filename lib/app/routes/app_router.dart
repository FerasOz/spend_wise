import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/app/shell/cubit/shell_cubit.dart';
import 'package:spend_wise/app/shell/main_shell_page.dart';
import 'package:spend_wise/app/routes/route_names.dart';
import 'package:spend_wise/core/di/injection_container.dart';
import 'package:spend_wise/core/widgets/animations/app_page_transition.dart';
import 'package:spend_wise/features/auth/presentation/pages/login_page.dart';
import 'package:spend_wise/features/auth/presentation/pages/register_page.dart';
import 'package:spend_wise/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_form_page.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/features/budgets/presentation/cubit/budget_cubit.dart';
import 'package:spend_wise/features/budgets/presentation/pages/budget_page.dart';
import 'package:spend_wise/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_filter_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expense_details_page.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expense_form_page.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expenses_page.dart';
import 'package:spend_wise/features/recurring/presentation/cubit/recurring_expense_cubit.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spend_wise/features/settings/presentation/pages/settings_page.dart';
import 'package:spend_wise/features/export/presentation/cubit/export_cubit.dart';
import 'package:spend_wise/features/export/presentation/pages/export_page.dart';

class AppRouters {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainShellPage:
        return AppPageTransition.route(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<ShellCubit>()),
              BlocProvider(
                create: (context) => sl<ExpenseCubit>()..loadExpenses(),
              ),
              BlocProvider(create: (context) => sl<ExpenseFilterCubit>()),
              BlocProvider(
                create: (context) => sl<CategoryCubit>()..loadCategories(),
              ),
              BlocProvider(create: (context) => sl<RecurringExpenseCubit>()),
              BlocProvider(
                create: (context) => sl<DashboardCubit>()..loadDashboard(),
              ),
            ],
            child: const MainShellPage(),
          ),
        );
      case RouteNames.expensePage:
        return AppPageTransition.route(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<ExpenseCubit>()..loadExpenses(),
              ),
              BlocProvider(create: (context) => sl<ExpenseFilterCubit>()),
              BlocProvider(
                create: (context) => sl<CategoryCubit>()..loadCategories(),
              ),
            ],
            child: const ExpensesPage(),
          ),
        );
      case RouteNames.addExpensePage:
        final expense = settings.arguments as Expense?;

        return AppPageTransition.route(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    sl<ExpenseCubit>()..initializeForm(expense),
              ),
              BlocProvider(
                create: (context) => sl<CategoryCubit>()..loadCategories(),
              ),
            ],
            child: ExpenseFormPage(expense: expense),
          ),
        );

      case RouteNames.expenseDetailsPage:
        final args = settings.arguments as ExpenseDetailsRouteArgs;

        return AppPageTransition.route(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: args.expenseCubit),
              BlocProvider.value(value: args.categoryCubit),
            ],
            child: ExpenseDetailsPage(expenseId: args.expenseId),
          ),
        );

      case RouteNames.categoryListPage:
        return AppPageTransition.route(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<CategoryCubit>()..loadCategories(),
              ),
              BlocProvider(
                create: (context) => sl<ExpenseCubit>()..loadExpenses(),
              ),
            ],
            child: const CategoryListPage(),
          ),
        );

      case RouteNames.categoryFormPage:
        final category = settings.arguments as Category?;

        return AppPageTransition.route(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    sl<CategoryCubit>()..initializeForm(category),
              ),
              BlocProvider(create: (context) => sl<ExpenseCubit>()),
            ],
            child: const CategoryFormPage(),
          ),
        );
      case RouteNames.budgetPage:
        return AppPageTransition.route(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<BudgetCubit>()),
              BlocProvider(
                create: (context) => sl<ExpenseCubit>()..loadExpenses(),
              ),
              BlocProvider(
                create: (context) => sl<CategoryCubit>()..loadCategories(),
              ),
            ],
            child: const BudgetPage(),
          ),
        );
      case RouteNames.settingsPage:
        return AppPageTransition.route(
          settings: settings,
          builder: (context) => BlocProvider.value(
            value: context.read<SettingsCubit>(),
            child: const SettingsPage(),
          ),
        );

      case RouteNames.exportPage:
        return AppPageTransition.route(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => sl<ExportCubit>()..loadHistory(),
            child: const ExportPage(),
          ),
        );
      case RouteNames.loginPage:
        return AppPageTransition.route(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const LoginPage(),
          ),
        );
      case RouteNames.registerPage:
        return AppPageTransition.route(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const RegisterPage(),
          ),
        );

      default:
        return null;
    }
  }
}
