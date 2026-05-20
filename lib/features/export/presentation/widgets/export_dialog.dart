import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../cubit/export_cubit.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';
import '../../data/services/export_service_impl.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({
    required this.expenses,
    required this.categoriesMap,
    super.key,
  });

  final List<Expense> expenses;
  final Map<String, Category> categoriesMap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExportCubit(ExportServiceImpl()),
      child: BlocBuilder<ExportCubit, ExportState>(
        builder: (context, state) {
          if (state.isLoading) {
            return _buildLoadingIndicator(context);
          } else if (state.filePath != null) {
            return _buildSuccess(
              context,
              state.filePath!,
              state.exportType ?? '',
            );
          } else if (state.error != null) {
            return _buildError(context, state.error!);
          } else if (state.isBackupSuccess) {
            return _buildBackupSuccess(context);
          } else {
            return _buildOptions(context);
          }
        },
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16.h),
            _buildExportOption(
              context,
              'CSV Export',
              'Export expenses as CSV',
              Icons.file_present_outlined,
              () => context.read<ExportCubit>().exportExpensesAsCSV(
                expenses,
                categoriesMap,
              ),
            ),
            SizedBox(height: 12.h),
            _buildExportOption(
              context,
              'Summary Export',
              'Export dashboard summary',
              Icons.summarize_outlined,
              () => context.read<ExportCubit>().exportDashboardSummaryAsPDF(
                expenses,
                categoriesMap,
              ),
            ),
            SizedBox(height: 12.h),
            _buildExportOption(
              context,
              'Create Backup',
              'Backup all app data',
              Icons.backup_outlined,
              () => context.read<ExportCubit>().createBackup(),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text('Exporting...', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, String filePath, String type) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Export Successful',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your $type file has been saved to:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 4.h),
            SelectableText(
              filePath,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              maxLines: 2,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                if (type != 'Backup')
                  ElevatedButton(
                    onPressed: () => _shareFile(context, filePath),
                    child: const Text('Share'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Export Failed',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: () => context.read<ExportCubit>().resetState(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupSuccess(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.backup_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Backup Successful',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your app data has been backed up successfully.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareFile(BuildContext context, String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await Share.shareXFiles([
        XFile(filePath),
      ], text: 'Check out this exported file from Spend Wise!');
    } else {
      // Show error if file doesn't exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File not found: $filePath'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Widget _buildExportOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
