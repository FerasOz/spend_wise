import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_expense_summary.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_list/category_feedback_view.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_list/category_item.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_loading_overlay.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_state.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class CategoryListBody extends StatelessWidget {
  const CategoryListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          BlocBuilder<CategoryCubit, CategoryState>(
            buildWhen: (previous, current) {
              return previous.categoriesStatus != current.categoriesStatus ||
                  previous.categories != current.categories ||
                  previous.deletionStatus != current.deletionStatus;
            },
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, child: child),
                ),
                child: CategoryListContent(
                  key: ValueKey(
                    '${state.categoriesStatus}-${state.categories.length}-${state.deletionStatus}',
                  ),
                  state: state,
                ),
              );
            },
          ),
          BlocBuilder<CategoryCubit, CategoryState>(
            buildWhen: (previous, current) =>
                previous.deletionStatus != current.deletionStatus,
            builder: (context, state) {
              if (state.deletionStatus != RequestsStatus.loading) {
                return const SizedBox.shrink();
              }

              return CategoryLoadingOverlay(
                message: LocaleKeys.categories_deleting.tr(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryListContent extends StatelessWidget {
  const CategoryListContent({required this.state, super.key});

  final CategoryState state;

  @override
  Widget build(BuildContext context) {
    if (state.categoriesStatus == RequestsStatus.loading &&
        state.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.categoriesStatus == RequestsStatus.error &&
        state.categories.isEmpty) {
      return CategoryFeedbackView(
        icon: Icons.error_outline,
        title: LocaleKeys.categories_errors_noCategory.tr(),
        description: LocaleKeys.categories_errors_noCategoryDescription.tr(),
        actionLabel: LocaleKeys.categories_errors_actionLabel.tr(),
        onPressed: context.read<CategoryCubit>().loadCategories,
      );
    }

    if (state.categories.isEmpty) {
      return CategoryFeedbackView(
        icon: Icons.category_outlined,
        title: LocaleKeys.categories_errors_empty.tr(),
        description: LocaleKeys.categories_errors_emptyDescription.tr(),
        actionLabel: LocaleKeys.categories_errors_emptyActionLabel.tr(),
        onPressed: () => CategoryListPage.openCategoryFormPage(context),
      );
    }

    return BlocSelector<ExpenseCubit, ExpenseState, List<Expense>>(
      selector: (expenseState) => expenseState.expenses,
      builder: (context, expenses) {
        return BlocSelector<SettingsCubit, SettingsState, String>(
          selector: (settingsState) =>
              settingsState.settings?.currency.code ?? 'USD',
          builder: (context, _) {
            final summaries = CategoryExpenseSummary.buildByCategoryId(
              expenses,
            );

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<CategoryCubit>().loadCategories(force: true),
              child: ListView.builder(
                itemCount: state.sortedCategories.length,
                itemBuilder: (context, index) {
                  final category = state.sortedCategories[index];
                  return CategoryItem(
                    category: category,
                    summary:
                        summaries[category.id] ?? CategoryExpenseSummary.empty,
                    onTap: () => CategoryListPage.openCategoryDetailsPage(
                      context,
                      category,
                    ),
                    onEdit: () => CategoryListPage.openCategoryFormPage(
                      context,
                      category: category,
                    ),
                    onDelete: category.isDefault
                        ? null
                        : () => CategoryListPage.showCategoryDeleteConfirmation(
                            context,
                            category,
                          ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
