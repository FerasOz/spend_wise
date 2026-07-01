import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import 'expense_category_field.dart';
import '../../cubit/expense_cubit.dart';

class ExpenseCategorySection extends StatefulWidget {
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
  State<ExpenseCategorySection> createState() => _ExpenseCategorySectionState();
}

class _ExpenseCategorySectionState extends State<ExpenseCategorySection> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseCubit, ExpenseState, String?>(
      selector: (state) => state.selectedCategoryId,
      builder: (context, selectedCategoryId) {
        return FadeTransition(
          opacity: const AlwaysStoppedAnimation(0.9),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: ExpenseCategoryField(
              key: ValueKey(selectedCategoryId ?? widget.initialExpense?.categoryId),
              categories: widget.categories,
              categoriesStatus: widget.categoriesStatus,
              initialValue:
                  selectedCategoryId ?? widget.initialExpense?.categoryId,
              onSaved: widget.onSaved,
              onCategorySelected: widget.onCategorySelected,
              focusNode: _focusNode,
            ),
          ),
        );
      },
    );
  }
}
