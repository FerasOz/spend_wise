import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import 'expense_form_page.dart';
import '../../../../core/widgets/responsive_page_content.dart';
import '../widgets/expenses_state_view.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({
    super.key,
    this.showScaffold = true,
  });

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    if (!showScaffold) {
      return const SafeArea(child: _ExpensesPageBody());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SafeArea(child: _ExpensesPageBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddExpensePage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  static Future<void> openAddExpensePage(BuildContext context) async {
    context.read<ExpenseCubit>().resetExpenseForm();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<ExpenseCubit>(),
          child: const ExpenseFormPage(),
        ),
      ),
    );
  }
}

class _ExpensesPageBody extends StatelessWidget {
  const _ExpensesPageBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        return ResponsivePageContent(
          child: ExpensesStateView(state: state),
        );
      },
    );
  }
}
