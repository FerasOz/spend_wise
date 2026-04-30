import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/routes/route_names.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import '../widgets/expenses_state_view.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SafeArea(child: _ExpensesPageBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddExpensePage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  static Future<void> _openAddExpensePage(BuildContext context) async {
    context.read<ExpenseCubit>().resetExpenseForm();
    await Navigator.of(context).pushNamed(RouteNames.addExpensePage);
  }
}

class _ExpensesPageBody extends StatelessWidget {
  const _ExpensesPageBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 700 ? 24.w : 16.w;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 720.w),
                child: Padding(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: ExpensesStateView(state: state),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
