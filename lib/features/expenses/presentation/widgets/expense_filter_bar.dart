import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../features/categories/presentation/cubit/category_cubit.dart';
import '../../domain/entities/expense_filter.dart';
import '../cubit/expense_filter_cubit.dart';
import '../cubit/expense_filter_state.dart';

class ExpenseFilterBar extends StatelessWidget {
  const ExpenseFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((ExpenseFilterCubit cubit) => cubit.state);
    final categories = context.select(
      (CategoryCubit cubit) => cubit.state.sortedCategories,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: ValueKey(state.searchQuery.isEmpty),
          initialValue: state.searchQuery,
          onChanged: context.read<ExpenseFilterCubit>().setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search expenses by title',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: state.searchQuery.isEmpty
                ? null
                : IconButton(
                    onPressed: () =>
                        context.read<ExpenseFilterCubit>().setSearchQuery(''),
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        Wrap(
          spacing: AppSpacing.sm.w,
          runSpacing: AppSpacing.sm.h,
          children: [
            ChoiceChip(
              label: const Text('All categories'),
              selected: state.categoryFilterId == null,
              onSelected: (_) =>
                  context.read<ExpenseFilterCubit>().setCategoryFilterId(null),
            ),
            for (final category in categories)
              ChoiceChip(
                label: Text(category.name),
                selected: state.categoryFilterId == category.id,
                onSelected: (_) => context
                    .read<ExpenseFilterCubit>()
                    .setCategoryFilterId(category.id),
              ),
            InputChip(
              avatar: const Icon(Icons.date_range_outlined),
              label: Text(_rangeLabel(state)),
              onPressed: () => _pickDateRange(context, state),
            ),
            InputChip(
              avatar: const Icon(Icons.attach_money_outlined),
              label: Text(_amountLabel(state)),
              onPressed: () => _pickAmountRange(context, state),
            ),
            PopupMenuButton<ExpenseSortOption>(
              initialValue: state.sortOption,
              onSelected: context.read<ExpenseFilterCubit>().setSortOption,
              itemBuilder: (_) => ExpenseSortOption.values
                  .map((option) => PopupMenuItem(
                        value: option,
                        child: Text(_sortLabel(option)),
                      ))
                  .toList(),
              child: InputChip(
                avatar: const Icon(Icons.sort),
                label: Text(_sortLabel(state.sortOption)),
              ),
            ),
            if (state.hasActiveFilters)
              InputChip(
                avatar: const Icon(Icons.filter_alt_off),
                label: const Text('Clear filters'),
                onPressed: context.read<ExpenseFilterCubit>().clearAll,
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDateRange(
    BuildContext context,
    ExpenseFilterState state,
  ) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange:
          state.filterStartDate == null || state.filterEndDate == null
          ? null
          : DateTimeRange(start: state.filterStartDate!, end: state.filterEndDate!),
    );
    if (range == null || !context.mounted) return;
    context.read<ExpenseFilterCubit>().setDateRange(range.start, range.end);
  }

  Future<void> _pickAmountRange(
    BuildContext context,
    ExpenseFilterState state,
  ) async {
    String? minValue = state.minAmount?.toString();
    String? maxValue = state.maxAmount?.toString();

    final applied = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Amount range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: minValue,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Minimum amount'),
                onChanged: (value) => minValue = value,
              ),
              SizedBox(height: AppSpacing.md.h),
              TextFormField(
                initialValue: maxValue,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Maximum amount'),
                onChanged: (value) => maxValue = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
    if (applied != true || !context.mounted) return;

    context.read<ExpenseFilterCubit>().setAmountRange(
      double.tryParse((minValue ?? '').trim()),
      double.tryParse((maxValue ?? '').trim()),
    );
  }

  String _rangeLabel(ExpenseFilterState state) {
    if (state.filterStartDate == null || state.filterEndDate == null) {
      return 'Date range';
    }

    return '${AppFormatters.shortDate(state.filterStartDate!)} - ${AppFormatters.shortDate(state.filterEndDate!)}';
  }

  String _amountLabel(ExpenseFilterState state) {
    if (state.minAmount == null && state.maxAmount == null) {
      return 'Amount range';
    }

    final min = state.minAmount == null ? 'Any' : AppFormatters.currency(state.minAmount!);
    final max = state.maxAmount == null ? 'Any' : AppFormatters.currency(state.maxAmount!);
    return '$min - $max';
  }

  String _sortLabel(ExpenseSortOption option) {
    switch (option) {
      case ExpenseSortOption.newest:
        return 'Newest';
      case ExpenseSortOption.oldest:
        return 'Oldest';
      case ExpenseSortOption.highestAmount:
        return 'Highest amount';
      case ExpenseSortOption.lowestAmount:
        return 'Lowest amount';
    }
  }
}
