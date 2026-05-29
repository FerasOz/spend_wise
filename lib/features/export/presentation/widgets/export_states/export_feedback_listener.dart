import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../cubit/export_cubit.dart';

class ExportFeedbackListener extends StatelessWidget {
  const ExportFeedbackListener({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExportCubit, ExportState>(
      listenWhen: (prev, next) =>
          prev.errorMessage != next.errorMessage ||
          prev.lastExport != next.lastExport ||
          prev.lastAction != next.lastAction,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.errorMessage != null) {
          messenger.showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<ExportCubit>().clearFeedback();
          return;
        }
        if (state.lastAction == ExportAction.saved) {
          messenger.showSnackBar(
            SnackBar(content: Text(LocaleKeys.export_snackbar_saved.tr())),
          );
          context.read<ExportCubit>().clearFeedback();
          return;
        }
        if (state.lastAction == ExportAction.shared) {
          messenger.showSnackBar(
            SnackBar(content: Text(LocaleKeys.export_snackbar_shared.tr())),
          );
          context.read<ExportCubit>().clearFeedback();
          return;
        }
        if (state.lastExport != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                LocaleKeys.export_snackbar_exported.tr(
                  namedArgs: {'file': state.lastExport!.fileName},
                ),
              ),
              action: SnackBarAction(
                label: LocaleKeys.common_actions_share.tr(),
                onPressed: () =>
                    context.read<ExportCubit>().share(state.lastExport!.path),
              ),
            ),
          );
          context.read<ExportCubit>().clearFeedback();
        }
      },
      child: child,
    );
  }
}
