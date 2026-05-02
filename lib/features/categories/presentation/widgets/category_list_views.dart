import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_list_page.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_feedback_view.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_item.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_loading_overlay.dart';

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
                child: CategoryListContent(state: state),
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

              return const CategoryLoadingOverlay(
                message: 'Deleting category...',
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
        title: 'Failed to load categories',
        description: 'Please try loading your categories again.',
        actionLabel: 'Retry',
        onPressed: context.read<CategoryCubit>().loadCategories,
      );
    }

    if (state.categories.isEmpty) {
      return CategoryFeedbackView(
        icon: Icons.category_outlined,
        title: 'No categories yet',
        description: 'Tap the + button to create your first category.',
        actionLabel: 'Create category',
        onPressed: () => CategoryListPage.openCategoryFormPage(context),
      );
    }

    return RefreshIndicator(
      onRefresh: context.read<CategoryCubit>().loadCategories,
      child: ListView.builder(
        itemCount: state.sortedCategories.length,
        itemBuilder: (context, index) {
          final category = state.sortedCategories[index];
          return CategoryItem(
            category: category,
            onEdit: () => CategoryListPage.openCategoryFormPage(
              context,
              category: category,
            ),
            onDelete: () => CategoryListPage.showCategoryDeleteConfirmation(
              context,
              category,
            ),
          );
        },
      ),
    );
  }
}
