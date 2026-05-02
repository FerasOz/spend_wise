import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';

class CategoryFormListener extends StatelessWidget {
  const CategoryFormListener({required this.child, super.key});

  final Widget child;

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
      child: child,
    );
  }
}

class CategoryListListener extends StatelessWidget {
  const CategoryListListener({required this.child, super.key});

  final Widget child;

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
      child: child,
    );
  }
}
