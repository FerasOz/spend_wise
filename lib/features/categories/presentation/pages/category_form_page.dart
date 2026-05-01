import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_form.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_loading_overlay.dart';

class CategoryFormPage extends StatelessWidget {
  const CategoryFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryCubit, CategoryState>(
      listenWhen: (previous, current) {
        return previous.submissionStatus != current.submissionStatus ||
            previous.submissionErrorMessage != current.submissionErrorMessage ||
            previous.userMessage != current.userMessage;
      },
      listener: (context, state) {
        if (state.submissionStatus == RequestsStatus.error &&
            state.submissionErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.submissionErrorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<CategoryCubit>().clearMessages();
          return;
        }

        if (state.submissionStatus == RequestsStatus.success &&
            state.userMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.userMessage!),
              backgroundColor: Colors.green,
            ),
          );
          context.read<CategoryCubit>().clearMessages();
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<CategoryCubit, CategoryState>(
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
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 720.w),
                      child: CategoryForm(),
                    ),
                  ),
                ),
                if (state.submissionStatus == RequestsStatus.loading)
                  const CategoryLoadingOverlay(message: 'Saving category...'),
              ],
            ),
          );
        },
      ),
    );
  }
}
