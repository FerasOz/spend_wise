import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../features/categories/presentation/cubit/category_cubit.dart';
import '../../../../features/expenses/presentation/cubit/expense_cubit.dart';
import '../../../../features/expenses/presentation/cubit/expense_state.dart';

class ExpenseFilterBar extends StatefulWidget {
  const ExpenseFilterBar({super.key});

  @override
  State<ExpenseFilterBar> createState() => _ExpenseFilterBarState();
}

class _ExpenseFilterBarState extends State<ExpenseFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((ExpenseCubit cubit) => cubit.state);
    final categories = context.select(
      (CategoryCubit cubit) => cubit.state.categories,
    );

    if (_searchController.text != state.searchQuery) {
      _searchController.text = state.searchQuery;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          onChanged: context.read<ExpenseCubit>().setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search expenses by title',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: state.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ExpenseCubit>().setSearchQuery('');
                    },
                  )
                : null,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ChoiceChip(
              label: const Text('All categories'),
              selected: state.categoryFilterId == null,
              onSelected: (_) =>
                  context.read<ExpenseCubit>().setCategoryFilterId(null),
            ),
            ...categories.map((category) {
              return ChoiceChip(
                label: Text(category.name),
                selected: state.categoryFilterId == category.id,
                onSelected: (_) => context
                    .read<ExpenseCubit>()
                    .setCategoryFilterId(category.id),
              );
            }),
            InputChip(
              avatar: const Icon(Icons.date_range_outlined),
              label: Text(_rangeLabel(state)),
              onPressed: () => _pickDateRange(context, state),
            ),
            PopupMenuButton<ExpenseSortOption>(
              tooltip: 'Sort expenses',
              initialValue: state.sortOption,
              onSelected: context.read<ExpenseCubit>().setSortOption,
              itemBuilder: (_) => ExpenseSortOption.values
                  .map(
                    (option) => PopupMenuItem(
                      value: option,
                      child: Text(_sortLabel(option)),
                    ),
                  )
                  .toList(),
              child: InputChip(
                avatar: const Icon(Icons.sort),
                label: Text(_sortLabel(state.sortOption)),
              ),
            ),
            if (_hasActiveFilters(state))
              InputChip(
                avatar: const Icon(Icons.filter_alt_off),
                label: const Text('Clear filters'),
                onPressed: context.read<ExpenseCubit>().clearAllFilters,
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDateRange(BuildContext context, ExpenseState state) async {
    final selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange:
          state.filterStartDate != null && state.filterEndDate != null
          ? DateTimeRange(
              start: state.filterStartDate!,
              end: state.filterEndDate!,
            )
          : null,
    );

    if (selectedRange == null) {
      return;
    }

    context.read<ExpenseCubit>().setDateRange(
      selectedRange.start,
      selectedRange.end,
    );
  }

  String _rangeLabel(ExpenseState state) {
    if (state.filterStartDate == null || state.filterEndDate == null) {
      return 'Date range';
    }

    return '${_formatShortDate(state.filterStartDate!)} - ${_formatShortDate(state.filterEndDate!)}';
  }

  String _formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _hasActiveFilters(ExpenseState state) {
    return state.searchQuery.isNotEmpty ||
        state.categoryFilterId != null ||
        state.filterStartDate != null ||
        state.filterEndDate != null ||
        state.sortOption != ExpenseSortOption.newest;
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
