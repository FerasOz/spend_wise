import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/core/widgets/responsive_page_content.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_form/category_form.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_loading_overlay.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

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
            title: Text(
              state.isEditing
                  ? LocaleKeys.categories_form_title_edit.tr()
                  : LocaleKeys.categories_form_title_add.tr(),
            ),
            elevation: 0,
          ),
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8.h,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ResponsivePageContent(child: CategoryForm()),
                  ),
                ),
              ),
              if (state.submissionStatus == RequestsStatus.loading)
                CategoryLoadingOverlay(
                  message: LocaleKeys.categories_form_fields_saving.tr(),
                ),
            ],
          ),
        );
      },
    );
  }
}
