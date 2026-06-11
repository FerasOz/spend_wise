import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/category_resolver.dart';
import '../../../../../features/categories/presentation/cubit/category_cubit.dart';
import '../../../domain/entities/recurring_expense.dart';
import 'recurring_expense_tile.dart';

class RecurringExpensesListView extends StatelessWidget {
  const RecurringExpensesListView({required this.recurringExpenses, super.key});

  final List<RecurringExpense> recurringExpenses;

  @override
  Widget build(BuildContext context) {
    final categories = context.select(
      (CategoryCubit cubit) => cubit.state.categories,
    );
    final categoriesById = CategoryResolver.indexCategories(categories);

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
      physics: const BouncingScrollPhysics(),
      itemCount: recurringExpenses.length + 1,
      separatorBuilder: (_, index) =>
          SizedBox(height: index == 0 ? 18.h : 12.h),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _RecurringListHeader(count: recurringExpenses.length);
        }

        final item = recurringExpenses[index - 1];
        final category = CategoryResolver.resolveCategoryFromMap(
          item.categoryId,
          categoriesById,
        );

        return RecurringExpenseTile(recurringExpense: item, category: category);
      },
    );
  }
}

class _RecurringListHeader extends StatelessWidget {
  const _RecurringListHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.xs.h,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            '$count',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
