import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/app/shell/cubit/shell_cubit.dart';
import 'package:spend_wise/app/shell/cubit/shell_state.dart';
import 'package:spend_wise/app/shell/models/shell_destination.dart';
import 'package:spend_wise/app/shell/widgets/main_shell_drawer.dart';
import 'package:spend_wise/app/shell/widgets/main_shell_navigation_bar.dart';
import 'package:spend_wise/app/shell/widgets/shell_destinations.dart';
import 'package:spend_wise/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_filter_cubit.dart';
import 'package:spend_wise/features/recurring/presentation/cubit/recurring_expense_cubit.dart';
import 'package:spend_wise/features/recurring/presentation/cubit/recurring_expense_state.dart';


class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  List<ShellDestination> get _destinations => buildShellDestinations();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RecurringExpenseCubit, RecurringExpenseState>(
          listenWhen: (previous, current) =>
              previous.generatedExpenseCount != current.generatedExpenseCount &&
              current.generatedExpenseCount > 0,
          listener: (context, _) {
            context.read<ExpenseCubit>().loadExpenses();
            context.read<ExpenseFilterCubit>().clearAll();
            context.read<DashboardCubit>().loadDashboard();
          },
        ),
        BlocListener<ShellCubit, ShellState>(
          listenWhen: (previous, current) =>
              previous.currentIndex != current.currentIndex &&
              current.currentIndex == 0,
          listener: (context, _) =>
              context.read<DashboardCubit>().loadDashboard(),
        ),
      ],
      child: BlocBuilder<ShellCubit, ShellState>(
        buildWhen: (previous, current) =>
            previous.currentIndex != current.currentIndex,
        builder: (context, state) {
          final currentDestination = _destinations[state.currentIndex];

          return Scaffold(
            appBar: AppBar(title: Text(currentDestination.title)),
            drawer: const MainShellDrawer(),
            body: IndexedStack(
              index: state.currentIndex,
              children: _destinations.map((item) => item.page).toList(growable: false),
            ),
            floatingActionButton: _buildFloatingActionButton(
              context,
              currentDestination,
            ),
            bottomNavigationBar: MainShellNavigationBar(
              currentIndex: state.currentIndex,
              destinations: _destinations,
              onDestinationSelected: context.read<ShellCubit>().changeTab,
            ),
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton(
    BuildContext context,
    ShellDestination currentDestination,
  ) {
    final fabAction = currentDestination.fab;
    if (fabAction == null) {
      return null;
    }

    return FloatingActionButton(
      onPressed: () => fabAction(context),
      child: Icon(currentDestination.fabIcon),
    );
  }
}
