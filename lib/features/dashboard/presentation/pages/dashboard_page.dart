import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../core/widgets/responsive_page_content.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../../categories/presentation/cubit/category_state.dart';
import '../../../expenses/presentation/cubit/expense_cubit.dart';
import '../../../expenses/presentation/cubit/expense_state.dart';
import '../../../expenses/presentation/pages/expenses_page.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_empty_state.dart';
import '../widgets/dashboard_error_state.dart';
import '../widgets/dashboard_overview.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, this.showScaffold = true});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final content = MultiBlocListener(
      listeners: [
        BlocListener<ExpenseCubit, ExpenseState>(
          listenWhen: (previous, current) =>
              current.expensesStatus == RequestsStatus.success &&
              (previous.expenses != current.expenses ||
                  previous.expensesStatus != current.expensesStatus),
          listener: (context, _) =>
              context.read<DashboardCubit>().loadDashboard(),
        ),
        BlocListener<CategoryCubit, CategoryState>(
          listenWhen: (previous, current) =>
              current.categoriesStatus == RequestsStatus.success &&
              (previous.categories != current.categories ||
                  previous.categoriesStatus != current.categoriesStatus),
          listener: (context, _) =>
              context.read<DashboardCubit>().loadDashboard(),
        ),
      ],
      child: const _DashboardPageBody(),
    );

    if (!showScaffold) {
      return SafeArea(child: content);
    }

    return Scaffold(body: SafeArea(child: content));
  }
}

class _DashboardPageBody extends StatelessWidget {
  const _DashboardPageBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.summary != current.summary ||
          previous.insights != current.insights ||
          previous.weeklySpending != current.weeklySpending ||
          previous.recentExpenses != current.recentExpenses ||
          previous.topCategories != current.topCategories ||
          previous.categoriesById != current.categoriesById ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return ResponsivePageContent(
          maxWidth: 860,
          child: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, DashboardState state) {
    if ((state.status == RequestsStatus.initial ||
            state.status == RequestsStatus.loading) &&
        state.summary == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == RequestsStatus.error && state.summary == null) {
      return DashboardErrorState(
        message: state.errorMessage ?? 'Failed to load dashboard.',
        onRetry: context.read<DashboardCubit>().loadDashboard,
      );
    }

    if (!state.hasExpenses) {
      return DashboardEmptyState(
        onAddExpense: () => ExpensesPage.openExpenseFormPage(context),
      );
    }

    return DashboardOverview(state: state);
  }
}
