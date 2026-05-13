import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/core/widgets/responsive_page_content.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/pages/category_details_page.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_form_body.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_listeners.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_list_views.dart';
import 'package:spend_wise/features/expenses/presentation/cubit/expense_cubit.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key, this.showScaffold = true});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    const content = CategoryListListener(child: CategoryListBody());

    if (!showScaffold) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Categories'), elevation: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openCategoryFormPage(context),
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
      body: ResponsivePageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
          child: content,
        ),
      ),
    );
  }

  static Future<void> openCategoryFormPage(
    BuildContext context, {
    Category? category,
  }) async {
    context.read<CategoryCubit>().initializeForm(category);

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<CategoryCubit>(),
          child: const CategoryFormListener(child: CategoryFormBody()),
        ),
      ),
    );
  }

  static Future<void> openCategoryManagementPage(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<CategoryCubit>()),
            BlocProvider.value(value: context.read<ExpenseCubit>()),
          ],
          child: const CategoryListPage(),
        ),
      ),
    );
  }

  static Future<void> openCategoryDetailsPage(
    BuildContext context,
    Category category,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<CategoryCubit>()),
            BlocProvider.value(value: context.read<ExpenseCubit>()),
          ],
          child: CategoryDetailsPage(category: category),
        ),
      ),
    );
  }

  static Future<void> showCategoryDeleteConfirmation(
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
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
