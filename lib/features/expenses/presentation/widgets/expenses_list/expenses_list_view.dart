import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import '../../cubit/expense_cubit.dart';
import 'expense_list_item.dart';

class ExpensesListView extends StatefulWidget {
  const ExpensesListView({
    required this.expenses,
    required this.categories,
    super.key,
  });

  final List<Expense> expenses;
  final List<Category> categories;

  @override
  State<ExpensesListView> createState() => _ExpensesListViewState();
}

class _ExpensesListViewState extends State<ExpensesListView> {
  late final GlobalKey<AnimatedListState> _listKey;
  late List<Expense> _currentExpenses;
  late List<Category> _currentCategories;
  late Map<String, Category> _categoryMap;

  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey<AnimatedListState>();
    _currentExpenses = List.from(widget.expenses);
    _currentCategories = List.from(widget.categories);
    _categoryMap = _buildCategoryMap(_currentCategories);
  }

  Map<String, Category> _buildCategoryMap(List<Category> categories) {
    return {for (var category in categories) category.id: category};
  }

  @override
  void didUpdateWidget(covariant ExpensesListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_listEquals(widget.expenses, oldWidget.expenses)) {
      _updateList(widget.expenses);
    }
    if (!_listEquals(widget.categories, oldWidget.categories)) {
      _currentCategories = List.from(widget.categories);
      _categoryMap = _buildCategoryMap(_currentCategories);
    }
  }

  bool _listEquals(List<dynamic> a, List<dynamic> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _updateList(List<Expense> newExpenses) {
    final oldIdSet = _currentExpenses.map((e) => e.id).toSet();
    final newIdSet = newExpenses.map((e) => e.id).toSet();

    // Items to remove: in old but not in new
    final toRemove = _currentExpenses.where((e) => !newIdSet.contains(e.id)).toList();
    // Items to add: in new but not in old
    final toAdd = newExpenses.where((e) => !oldIdSet.contains(e.id)).toList();

    // Remove items (in reverse order to avoid index shifting)
    for (final expense in toRemove.reversed) {
      final index = _currentExpenses.indexOf(expense);
      if (index >= 0) {
        _listKey.currentState?.removeItem(
          index,
          (context, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: Padding(
                padding: index < _currentExpenses.length - 1
                    ? EdgeInsets.only(bottom: 12.h)
                    : EdgeInsets.zero,
                child: ExpenseItem(
                  expense: expense,
                  category: _categoryMap[expense.categoryId]!,
                ),
              ),
            ),
          ),
          duration: const Duration(milliseconds: 300),
        );
        _currentExpenses.removeAt(index);
      }
    }

    // Insert items
    for (final expense in toAdd) {
      final index = newExpenses.indexOf(expense);
      _listKey.currentState?.insertItem(
        index,
        duration: const Duration(milliseconds: 300),
      );
      _currentExpenses.insert(index, expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(0.95),
      child: RefreshIndicator(
        onRefresh: context.read<ExpenseCubit>().loadExpenses,
        child: AnimatedList(
          key: _listKey,
          initialItemCount: _currentExpenses.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index, animation) {
            final expense = _currentExpenses[index];
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                child: Padding(
                  padding: index < _currentExpenses.length - 1
                      ? EdgeInsets.only(bottom: 12.h)
                      : EdgeInsets.zero,
                  child: ExpenseItem(
                    expense: expense,
                    category: _categoryMap[expense.categoryId]!,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}