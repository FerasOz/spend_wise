import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/recurring/presentation/pages/recurring_expense_form_page.dart';
import '../../../../core/base/requests_status.dart';
import '../../../../core/widgets/responsive_page_content.dart';
import '../cubit/recurring_expense_cubit.dart';
import '../cubit/recurring_expense_state.dart';
import '../widgets/recurring_list/recurring_empty_state.dart';
import '../widgets/recurring_list/recurring_expenses_list_view.dart';

class RecurringExpensesPage extends StatelessWidget {
  const RecurringExpensesPage({super.key, this.showScaffold = true});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final content = BlocListener<RecurringExpenseCubit, RecurringExpenseState>(
      listenWhen: (previous, current) =>
          previous.submissionMessage != current.submissionMessage &&
          current.submissionMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.submissionMessage!)));
      },
      child: const _RecurringBody(),
    );

    if (!showScaffold) {
      return SafeArea(child: content);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => RecurringExpenseFormPage.open(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(child: content),
    );
  }
}

class _RecurringBody extends StatelessWidget {
  const _RecurringBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecurringExpenseCubit, RecurringExpenseState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.recurringExpenses != current.recurringExpenses ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return ResponsivePageContent(child: _buildContent(context, state));
      },
    );
  }

  Widget _buildContent(BuildContext context, RecurringExpenseState state) {
    if ((state.status == RequestsStatus.initial ||
            state.status == RequestsStatus.loading) &&
        state.recurringExpenses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == RequestsStatus.error &&
        state.recurringExpenses.isEmpty) {
      return Center(
        child: Text(state.errorMessage ?? 'Failed to load recurring expenses.'),
      );
    }
    if (state.recurringExpenses.isEmpty) {
      return RecurringEmptyState(
        onAddRecurring: () => RecurringExpenseFormPage.open(context),
      );
    }

    return RecurringExpensesListView(
      recurringExpenses: state.recurringExpenses,
    );
  }
}
