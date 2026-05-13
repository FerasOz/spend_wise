import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import 'expense_form_page.dart';
import '../../../../core/widgets/responsive_page_content.dart';
import '../widgets/expense_filter_bar.dart';
import '../widgets/expenses_state_view.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key, this.showScaffold = true});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    if (!showScaffold) {
      return const SafeArea(child: _ExpensesPageBody());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: const SafeArea(child: _ExpensesPageBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openExpenseFormPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  static Future<void> openExpenseFormPage(
    BuildContext context, {
    Expense? expense,
  }) async {
    context.read<ExpenseCubit>().initializeForm(expense);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ExpenseCubit>()),
            BlocProvider.value(value: context.read<CategoryCubit>()),
          ],
          child: ExpenseFormPage(expense: expense),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ExpenseFilterBar(),
              SizedBox(height: 16.h),
              Expanded(child: ExpensesStateView(state: state)),
            ],
          ),
        );
      },
    );
  }
}
