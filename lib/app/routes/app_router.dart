import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/app/shell/cubit/shell_cubit.dart';
import 'package:spend_wise/app/shell/main_shell_page.dart';
import 'package:spend_wise/app/routes/route_names.dart';
import 'package:spend_wise/core/di/injection_container.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_form_page.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expense_form_page.dart';
import 'package:spend_wise/features/expenses/presentation/pages/expenses_page.dart';
import 'package:spend_wise/features/settings/presentation/pages/settings_page.dart';

class AppRouters {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainShellPage:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<ShellCubit>()),
              BlocProvider(
                create: (context) => sl<ExpenseCubit>()..loadExpenses(),
              ),
              BlocProvider(
                create: (context) => sl<CategoryCubit>()..loadCategories(),
              ),
            ],
            child: const MainShellPage(),
          ),
        );
      case RouteNames.expensePage:
        return MaterialPageRoute(builder: (_) => const ExpensesPage());
      case RouteNames.addExpensePage:
        final expense = settings.arguments as Expense?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ExpenseCubit>(),
            child: ExpenseFormPage(expense: expense),
          ),
        );

      case RouteNames.categoryListPage:
        return MaterialPageRoute(builder: (_) => const CategoryListPage());

      case RouteNames.categoryFormPage:
        final category = settings.arguments as Category?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<CategoryCubit>()..initializeForm(category),
            child: const CategoryFormPage(),
          ),
        );
      case RouteNames.settingsPage:
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      default:
        return null;
    }
  }
}
