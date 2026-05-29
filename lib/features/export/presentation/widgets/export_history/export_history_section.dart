import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/export_cubit.dart';
import '../export_states/export_empty_state.dart';
import 'export_history_tile.dart';

class ExportHistorySection extends StatelessWidget {
  const ExportHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ExportCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.export_history_title.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: context.read<ExportCubit>().loadHistory,
              child: Text(LocaleKeys.export_history_refresh.tr()),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        if (state.history.isEmpty)
          const ExportEmptyState()
        else
          ...state.history.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
              child: ExportHistoryTile(item: item),
            ),
          ),
      ],
    );
  }
}
