import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/export_cubit.dart';
import 'export_action_card.dart';

class ExportActionsSection extends StatelessWidget {
  const ExportActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExportCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.export_actions_title.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: AppSpacing.md.h),
        ExportActionCard(
          icon: Icons.table_view_outlined,
          title: LocaleKeys.export_actions_csv_title.tr(),
          subtitle: LocaleKeys.export_actions_csv_subtitle.tr(),
          onTap: cubit.exportCsv,
        ),
        SizedBox(height: AppSpacing.sm.h),
        ExportActionCard(
          icon: Icons.data_object_outlined,
          title: LocaleKeys.export_actions_json_title.tr(),
          subtitle: LocaleKeys.export_actions_json_subtitle.tr(),
          onTap: cubit.exportJson,
        ),
        SizedBox(height: AppSpacing.sm.h),
        ExportActionCard(
          icon: Icons.picture_as_pdf_outlined,
          title: LocaleKeys.export_actions_pdf_title.tr(),
          subtitle: LocaleKeys.export_actions_pdf_subtitle.tr(),
          onTap: cubit.exportPdf,
        ),
        SizedBox(height: AppSpacing.sm.h),
        ExportActionCard(
          icon: Icons.backup_outlined,
          title: LocaleKeys.export_actions_backup_title.tr(),
          subtitle: LocaleKeys.export_actions_backup_subtitle.tr(),
          onTap: cubit.exportBackup,
        ),
      ],
    );
  }
}
