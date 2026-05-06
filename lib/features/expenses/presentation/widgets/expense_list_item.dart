import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../core/utils/category_resolver.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../../../../features/categories/presentation/utils/category_presentation_data.dart';

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({
    required this.expense,
    required this.categories,
    super.key,
  });

  final Expense expense;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = CategoryResolver.resolveCategory(
      expense.categoryId,
      categories,
    );
    final categoryColor = Color(category.color);
    final categoryIcon = CategoryPresentationData.iconFor(category.icon);

    return InkWell(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(RouteNames.addExpensePage, arguments: expense),
      borderRadius: BorderRadius.circular(24.r),
      child: Card(
        elevation: 2,
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            expense.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '\$${expense.amount.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _buildCategoryIcon(categoryColor, categoryIcon),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CategoryBadge(
                            category: category,
                            size: CategoryBadgeSize.small,
                            showLabel: true,
                            showIcon: true,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) => _handleAction(context, value),
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          icon: Icon(
                            Icons.more_vert,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (expense.note != null &&
                        expense.note!.trim().isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      Text(
                        expense.note!.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          _formatDate(expense.date),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(Color categoryColor, IconData categoryIcon) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(categoryIcon, size: 26.sp, color: categoryColor),
    );
  }

  Future<void> _handleAction(BuildContext context, String action) async {
    if (action == 'edit') {
      Navigator.of(
        context,
      ).pushNamed(RouteNames.addExpensePage, arguments: expense);
      return;
    }

    final cubit = context.read<ExpenseCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      cubit.deleteExpense(expense.id);
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
