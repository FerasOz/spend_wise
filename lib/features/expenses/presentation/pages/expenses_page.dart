import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/widgets/responsive_page_content.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../../../features/expenses/domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_filter_cubit.dart';
import '../cubit/expense_filter_state.dart';
import '../cubit/expense_state.dart';
import 'expense_form_page.dart';
import '../widgets/expenses_list/expense_filter_bar.dart';
import '../widgets/expenses_list/expenses_state_view.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key, this.showScaffold = true});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final body = MultiBlocListener(
      listeners: [
        BlocListener<ExpenseCubit, ExpenseState>(
          listenWhen: (previous, current) =>
              previous.expenses != current.expenses,
          listener: (context, state) =>
              context.read<ExpenseFilterCubit>().syncExpenses(state.expenses),
        ),
      ],
      child: const SafeArea(child: _ExpensesPageBody()),
    );

    if (!showScaffold) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.expenses_title.tr())),
      body: body,
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
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ExpenseCubit>()),
            BlocProvider.value(value: context.read<CategoryCubit>()),
          ],
          child: ExpenseFormPage(expense: expense),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class _ExpensesPageBody extends StatelessWidget {
  const _ExpensesPageBody();

  @override
  Widget build(BuildContext context) {
    return ResponsivePageContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ExpenseFilterBar(),
          SizedBox(height: 16.h),
          Expanded(
            child: BlocBuilder<ExpenseFilterCubit, ExpenseFilterState>(
              buildWhen: (previous, current) =>
                  previous.visibleExpenses != current.visibleExpenses ||
                  previous.filter != current.filter,
              builder: (context, filterState) {
                return BlocBuilder<ExpenseCubit, ExpenseState>(
                  buildWhen: (previous, current) =>
                      previous.expensesStatus != current.expensesStatus ||
                      previous.expenses != current.expenses ||
                      previous.loadErrorMessage != current.loadErrorMessage,
                  builder: (context, expenseState) {
                    return ExpensesStateView(
                      expenseState: expenseState,
                      filterState: filterState,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
