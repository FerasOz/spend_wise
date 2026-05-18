import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/category_resolver.dart';
import '../../../../features/categories/presentation/cubit/category_cubit.dart';
import '../../domain/entities/recurring_expense.dart';
import 'recurring_expense_tile.dart';

class RecurringExpensesListView extends StatelessWidget {
  const RecurringExpensesListView({
    required this.recurringExpenses,
    super.key,
  });

  final List<RecurringExpense> recurringExpenses;

  @override
  Widget build(BuildContext context) {
    final categories = context.select((CategoryCubit cubit) => cubit.state.categories);
    final categoriesById = CategoryResolver.indexCategories(categories);

    return ListView.separated(
      itemCount: recurringExpenses.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = recurringExpenses[index];
        final category = CategoryResolver.resolveCategoryFromMap(
          item.categoryId,
          categoriesById,
        );
        return RecurringExpenseTile(recurringExpense: item, category: category);
      },
    );
  }
}
