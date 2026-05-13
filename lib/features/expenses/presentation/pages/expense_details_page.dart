import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../../../app/routes/route_names.dart';
import '../pages/expense_form_page.dart';

class ExpenseDetailsRouteArgs {
  const ExpenseDetailsRouteArgs({
    required this.expense,
    required this.category,
    required this.expenseCubit,
    required this.categoryCubit,
  });

  final Expense expense;
  final Category category;
  final ExpenseCubit expenseCubit;
  final CategoryCubit categoryCubit;
}

class ExpenseDetailsPage extends StatelessWidget {
  const ExpenseDetailsPage({
    required this.expense,
    required this.category,
    super.key,
  });

  final Expense expense;
  final Category category;

  static Future<void> open(
    BuildContext context, {
    required Expense expense,
    required Category category,
  }) async {
    await Navigator.of(context).pushNamed(
      RouteNames.expenseDetailsPage,
      arguments: ExpenseDetailsRouteArgs(
        expense: expense,
        category: category,
        expenseCubit: context.read<ExpenseCubit>(),
        categoryCubit: context.read<CategoryCubit>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              ExpenseFormPage.open(context, expense: expense);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSection(expense: expense, category: category),
              SizedBox(height: 24.h),
              _DetailsInfo(expense: expense, category: category),
              SizedBox(height: 24.h),
              _MetadataSection(expense: expense),
              SizedBox(height: 24.h),
              _ActionButtons(expense: expense),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.expense, required this.category});

  final Expense expense;
  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount spent', style: theme.textTheme.bodyMedium),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${expense.amount.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              CategoryBadge(
                category: category,
                size: CategoryBadgeSize.large,
                showLabel: false,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          CategoryBadge(
            category: category,
            size: CategoryBadgeSize.medium,
            showIcon: true,
            showLabel: true,
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 20.sp),
              SizedBox(width: 10.w),
              Text(
                _formattedDate(expense.date),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formattedDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year · $hour:$minute';
  }
}

class _DetailsInfo extends StatelessWidget {
  const _DetailsInfo({required this.expense, required this.category});

  final Expense expense;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Description', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 10.h),
        Text(
          expense.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 20.h),
        Text('Category', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 10.h),
        _CategoryInfo(category: category),
        if ((expense.note ?? '').trim().isNotEmpty) ...[
          SizedBox(height: 24.h),
          Text('Note', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 10.h),
          Text(
            expense.note!.trim(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ],
    );
  }
}

class _CategoryInfo extends StatelessWidget {
  const _CategoryInfo({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          CategoryBadge(category: category, size: CategoryBadgeSize.small),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              category.name,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetadataSection extends StatelessWidget {
  const _MetadataSection({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12.h),
          _MetadataRow(label: 'Created', value: _formatDate(expense.createdAt)),
          _MetadataRow(label: 'Updated', value: _formatDate(expense.updatedAt)),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Unavailable';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year · $hour:$minute';
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text('$label: ', style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => ExpenseFormPage.open(context, expense: expense),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
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

    if (confirmed != true) return;

    final cubit = context.read<ExpenseCubit>();
    await cubit.deleteExpense(expense.id);

    if (!context.mounted) return;
    final submissionStatus = cubit.state.submissionStatus;
    final message = submissionStatus == RequestsStatus.success
        ? 'Expense deleted successfully.'
        : cubit.state.submissionErrorMessage ?? 'Failed to delete expense.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

    if (submissionStatus == RequestsStatus.success) {
      Navigator.of(context).pop();
    }
  }
}
