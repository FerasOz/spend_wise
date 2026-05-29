import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/export_history_item.dart';
import '../../cubit/export_cubit.dart';
import '../export_tiles/export_type_chip.dart';
import 'export_history_tile_menu.dart';

class ExportHistoryTile extends StatelessWidget {
  const ExportHistoryTile({required this.item, super.key});

  final ExportHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      child: Row(
        children: [
          ExportTypeChip(type: item.type),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.fileName, style: theme.textTheme.titleSmall),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  LocaleKeys.export_history_meta.tr(
                    namedArgs: {
                      'date': DateFormat(
                        'yMMMd • HH:mm',
                      ).format(item.createdAt),
                      'size': _formatBytes(item.sizeBytes),
                    },
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          ExportHistoryTileMenu(
            onShare: () => context.read<ExportCubit>().share(item.path),
            onSave: () =>
                context.read<ExportCubit>().saveToDownloads(item.path),
            onDelete: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.export_history_delete_title.tr()),
        content: Text(LocaleKeys.export_history_delete_message.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(LocaleKeys.common_actions_cancel.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(LocaleKeys.common_actions_delete.tr()),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<ExportCubit>().deleteHistoryItem(item.id);
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}
