import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/core/widgets/responsive_page_content.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_form.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_loading_overlay.dart';

class CategoryFormBody extends StatelessWidget {
  const CategoryFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (previous, current) =>
          previous.editingCategory != current.editingCategory ||
          previous.submissionStatus != current.submissionStatus,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isEditing ? 'Edit Category' : 'Add Category'),
            elevation: 0,
          ),
          body: Stack(
            children: [
              SafeArea(child: ResponsivePageContent(child: CategoryForm())),
              if (state.submissionStatus == RequestsStatus.loading)
                const CategoryLoadingOverlay(message: 'Saving category...'),
            ],
          ),
        );
      },
    );
  }
}
