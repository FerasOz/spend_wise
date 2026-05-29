import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/theme/app_spacing.dart';
import '../cubit/export_cubit.dart';
import '../widgets/export_actions/export_actions_section.dart';
import '../widgets/export_history/export_history_section.dart';
import '../widgets/export_states/export_feedback_listener.dart';
import '../widgets/export_states/export_loading_view.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExportFeedbackListener(
      child: _ExportPageBody(),
    );
  }
}

class _ExportPageBody extends StatelessWidget {
  const _ExportPageBody();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ExportCubit>().state;
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.export_title.tr())),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            children: [
              const ExportActionsSection(),
              SizedBox(height: AppSpacing.xl.h),
              const ExportHistorySection(),
              SizedBox(height: AppSpacing.xl.h),
            ],
          ),
          if (state.isExporting || state.isLoadingHistory)
            const ExportLoadingView(),
        ],
      ),
    );
  }
}

