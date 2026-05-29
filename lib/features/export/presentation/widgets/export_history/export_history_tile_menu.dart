import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExportHistoryTileMenu extends StatelessWidget {
  const ExportHistoryTileMenu({
    required this.onShare,
    required this.onSave,
    required this.onDelete,
    super.key,
  });

  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Action>(
      icon: const Icon(Icons.more_vert),
      onSelected: (a) => switch (a) {
        _Action.share => onShare(),
        _Action.save => onSave(),
        _Action.delete => onDelete(),
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _Action.share,
          child: Text(LocaleKeys.common_actions_share.tr()),
        ),
        PopupMenuItem(
          value: _Action.save,
          child: Text(LocaleKeys.export_actions_saveLocal.tr()),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: _Action.delete,
          child: Text(LocaleKeys.common_actions_delete.tr()),
        ),
      ],
    );
  }
}

enum _Action { share, save, delete }
