import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/category_resolver.dart';
import '../../../../../features/categories/presentation/cubit/category_cubit.dart';
import '../../../domain/entities/budget_progress.dart';
import '../../cubit/budget_cubit.dart';
import 'budget_card.dart';

class BudgetListView extends StatelessWidget {
  const BudgetListView({required this.budgets, super.key});

  final List<BudgetProgress> budgets;

  @override
  Widget build(BuildContext context) {
    final categories = context.select((CategoryCubit cubit) => cubit.state.categories);
    final categoriesById = CategoryResolver.indexCategories(categories);

    return ListView.separated(
      itemCount: budgets.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = budgets[index];
        final category = CategoryResolver.resolveCategoryFromMap(
          item.budget.categoryId,
          categoriesById,
        );

        return BudgetCard(
          budget: item,
          category: category,
          onDelete: () => context.read<BudgetCubit>().deleteBudget(item.budget.id),
        );
      },
    );
  }
}
