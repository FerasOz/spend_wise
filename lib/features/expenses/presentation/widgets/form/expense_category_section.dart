import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import 'package:spend_wise/features/expenses/presentation/widgets/expense_category_field.dart';
import '../../cubit/expense_cubit.dart';

class ExpenseCategorySection extends StatelessWidget {
  const ExpenseCategorySection({
    super.key,
    required this.categories,
    required this.categoriesStatus,
    required this.initialExpense,
    required this.onSaved,
    required this.onCategorySelected,
  });

  final List<Category> categories;
  final RequestsStatus categoriesStatus;
  final Expense? initialExpense;
  final ValueChanged<String?> onSaved;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseCubit, ExpenseState, String?>(
      selector: (state) => state.selectedCategoryId,
      builder: (context, selectedCategoryId) {
        return ExpenseCategoryField(
          categories: categories,
          categoriesStatus: categoriesStatus,
          initialValue: selectedCategoryId ?? initialExpense?.categoryId,
          onSaved: onSaved,
          onCategorySelected: onCategorySelected,
        );
      },
    );
  }
}
