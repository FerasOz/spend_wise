import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/budgets/presentation/pages/budget_form_page.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../core/base/requests_status.dart';
import '../../../../core/widgets/responsive_page_content.dart';
import '../../../expenses/presentation/cubit/expense_cubit.dart';
import '../../../expenses/presentation/cubit/expense_state.dart';
import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';
import '../widgets/budget_list/budget_empty_state.dart';
import '../widgets/budget_list/budget_list_view.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const BudgetPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ExpenseCubit, ExpenseState>(
          listenWhen: (previous, current) =>
              previous.expenses != current.expenses,
          listener: (context, _) => context.read<BudgetCubit>().loadBudgets(),
        ),
        BlocListener<BudgetCubit, BudgetState>(
          listenWhen: (previous, current) =>
              previous.submissionMessage != current.submissionMessage &&
              current.submissionMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.submissionMessage!)));
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.budgets_title.tr())),
        floatingActionButton: FloatingActionButton(
          onPressed: () => BudgetFormPage.open(context),
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: BlocBuilder<BudgetCubit, BudgetState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.budgets != current.budgets ||
                previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              return ResponsivePageContent(child: _BudgetBody(state: state));
            },
          ),
        ),
      ),
    );
  }
}

class _BudgetBody extends StatelessWidget {
  const _BudgetBody({required this.state});

  final BudgetState state;

  @override
  Widget build(BuildContext context) {
    if ((state.status == RequestsStatus.initial ||
            state.status == RequestsStatus.loading) &&
        state.budgets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == RequestsStatus.error && state.budgets.isEmpty) {
      return Center(
        child: Text(state.errorMessage ?? LocaleKeys.common_error.tr()),
      );
    }
    if (state.budgets.isEmpty) {
      return BudgetEmptyState(onAddBudget: () => BudgetFormPage.open(context));
    }

    return BudgetListView(budgets: state.budgets);
  }
}
