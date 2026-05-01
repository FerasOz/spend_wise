import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_form_page.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_feedback_view.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_item.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_loading_overlay.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryCubit, CategoryState>(
      listenWhen: (previous, current) {
        return previous.loadErrorMessage != current.loadErrorMessage ||
            previous.deletionErrorMessage != current.deletionErrorMessage ||
            previous.userMessage != current.userMessage;
      },
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);

        if (state.loadErrorMessage != null) {
          messenger.showSnackBar(
            SnackBar(content: Text(state.loadErrorMessage!)),
          );
          context.read<CategoryCubit>().clearMessages();
          return;
        }

        if (state.deletionErrorMessage != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.deletionErrorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<CategoryCubit>().clearMessages();
          return;
        }

        if (state.deletionStatus == RequestsStatus.success &&
            state.userMessage != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.userMessage!),
              backgroundColor: Colors.green,
            ),
          );
          context.read<CategoryCubit>().clearMessages();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openFormPage(context),
          tooltip: 'Add Category',
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
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
                    child: _CategoryListContent(state: state),
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
        ),
      ),
    );
  }

  static Future<void> _openFormPage(
    BuildContext context, {
    Category? category,
  }) async {
    context.read<CategoryCubit>().initializeForm(category);

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<CategoryCubit>(),
          child: const CategoryFormPage(),
        ),
      ),
    );
  }

  static Future<void> _showDeleteConfirmation(
    BuildContext context,
    Category category,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text(
            'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      await context.read<CategoryCubit>().deleteCategory(category);
    }
  }
}

class _CategoryListContent extends StatelessWidget {
  const _CategoryListContent({required this.state});

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
        onPressed: () => CategoryListPage._openFormPage(context),
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
            onEdit: () => CategoryListPage._openFormPage(
              context,
              category: category,
            ),
            onDelete: () => CategoryListPage._showDeleteConfirmation(
              context,
              category,
            ),
          );
        },
      ),
    );
  }
}
