import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../core/widgets/category_picker.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../domain/entities/budget.dart';
import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';

class BudgetFormPage extends StatelessWidget {
  const BudgetFormPage({super.key, this.budget});

  final Budget? budget;

  static Future<void> open(BuildContext context, {Budget? budget}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<BudgetCubit>()),
            BlocProvider.value(value: context.read<CategoryCubit>()),
          ],
          child: BudgetFormPage(budget: budget),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final isEditing = budget != null;
    final selectedCategoryId = ValueNotifier<String?>(budget?.categoryId);
    String? limitValue = budget?.limitAmount.toString();

    Future<void> submit() async {
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) return;
      formKey.currentState?.save();
      if (selectedCategoryId.value == null) return;

      final nextBudget = Budget(
        id: budget?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        categoryId: selectedCategoryId.value!,
        limitAmount: double.parse(limitValue!),
        period: budget?.period ?? BudgetPeriod.monthly,
        createdAt: budget?.createdAt ?? DateTime.now(),
      );

      if (isEditing) {
        await context.read<BudgetCubit>().updateBudget(nextBudget);
      } else {
        await context.read<BudgetCubit>().createBudget(nextBudget);
      }
      if (context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit budget' : 'Create budget')),
      body: SafeArea(
        child: BlocBuilder<BudgetCubit, BudgetState>(
          buildWhen: (previous, current) =>
              previous.submissionStatus != current.submissionStatus,
          builder: (context, state) {
            final categories = context.select(
              (CategoryCubit cubit) => cubit.state.sortedCategories,
            );

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: selectedCategoryId,
                      builder: (context, currentCategoryId, _) {
                        return CategorySelector(
                          categories: categories,
                          selectedCategoryId: currentCategoryId,
                          onCategorySelected: (category) {
                            selectedCategoryId.value = category.id;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      initialValue: limitValue,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Budget limit'),
                      validator: (value) {
                        final amount = double.tryParse((value ?? '').trim());
                        return amount == null || amount <= 0
                            ? 'Enter a valid budget limit'
                            : null;
                      },
                      onSaved: (value) => limitValue = value?.trim(),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: state.submissionStatus == RequestsStatus.loading
                            ? null
                            : submit,
                        icon: state.submissionStatus == RequestsStatus.loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.check),
                        label: Text(isEditing ? 'Save changes' : 'Create budget'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
