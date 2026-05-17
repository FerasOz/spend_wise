import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../core/utils/category_resolver.dart';
import '../../../../core/widgets/responsive_page_content.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../../categories/presentation/cubit/category_state.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import '../models/expense_details_view_data.dart';
import '../utils/expense_management_flow.dart';
import '../widgets/expense_details_actions.dart';
import '../widgets/expense_details_header.dart';
import '../widgets/expense_details_metadata.dart';
import '../widgets/expense_details_missing_state.dart';
import '../widgets/expense_details_note_card.dart';
import '../widgets/expense_details_overview.dart';
import 'expense_form_page.dart';

class ExpenseDetailsRouteArgs {
  const ExpenseDetailsRouteArgs({
    required this.expenseId,
    required this.expenseCubit,
    required this.categoryCubit,
  });

  final String expenseId;
  final ExpenseCubit expenseCubit;
  final CategoryCubit categoryCubit;
}

class ExpenseDetailsPage extends StatelessWidget {
  const ExpenseDetailsPage({required this.expenseId, super.key});

  final String expenseId;

  static Future<void> open(BuildContext context, {required String expenseId}) {
    return Navigator.of(context).pushNamed(
      RouteNames.expenseDetailsPage,
      arguments: ExpenseDetailsRouteArgs(
        expenseId: expenseId,
        expenseCubit: context.read<ExpenseCubit>(),
        categoryCubit: context.read<CategoryCubit>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense details')),
      body: BlocSelector<ExpenseCubit, ExpenseState, Expense?>(
        selector: (state) => _findExpense(state.expenses),
        builder: (context, expense) {
          if (expense == null) {
            return const ExpenseDetailsMissingState();
          }

          return BlocSelector<CategoryCubit, CategoryState, ExpenseDetailsViewData>(
            selector: (state) => ExpenseDetailsViewData(
              expense: expense,
              category: CategoryResolver.resolveCategory(
                expense.categoryId,
                state.categories,
              ),
            ),
            builder: (context, viewData) => _ExpenseDetailsView(viewData: viewData),
          );
        },
      ),
    );
  }

  Expense? _findExpense(List<Expense> expenses) {
    for (final expense in expenses) {
      if (expense.id == expenseId) {
        return expense;
      }
    }

    return null;
  }
}

class _ExpenseDetailsView extends StatelessWidget {
  const _ExpenseDetailsView({required this.viewData});

  final ExpenseDetailsViewData viewData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsivePageContent(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          children: [
            ExpenseDetailsHeader(
              expense: viewData.expense,
              category: viewData.category,
            ),
            SizedBox(height: 20.h),
            ExpenseDetailsOverview(
              expense: viewData.expense,
              category: viewData.category,
            ),
            if (viewData.hasNote) ...[
              SizedBox(height: 20.h),
              ExpenseDetailsNoteCard(note: viewData.expense.note!.trim()),
            ],
            SizedBox(height: 20.h),
            ExpenseDetailsMetadata(expense: viewData.expense),
            SizedBox(height: 24.h),
            ExpenseDetailsActions(
              onEdit: () =>
                  ExpenseFormPage.open(context, expense: viewData.expense),
              onDelete: () => ExpenseManagementFlow.deleteExpense(
                context,
                expenseId: viewData.expense.id,
                onDeleted: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
