import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/currencies.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/settings_cubit.dart';

void showCurrencyBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl.r))),
    builder: (_) => const _CurrencyBottomSheet(),
  );
}

class _CurrencyBottomSheet extends StatelessWidget {
  const _CurrencyBottomSheet();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.72,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.xxl.w, AppSpacing.lg.h, AppSpacing.xxl.w, AppSpacing.xxl.h),
          child: Column(
            children: [
              const _SheetHeader(),
              SizedBox(height: AppSpacing.lg.h),
              Expanded(
                child: BlocSelector<SettingsCubit, SettingsState, String>(
                  selector: (state) => state.settings?.currency.code ?? 'USD',
                  builder: (context, selectedCode) {
                    return ListView.separated(
                      itemCount: supportedCurrencies.length,
                      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
                      itemBuilder: (context, index) {
                        final option = supportedCurrencies[index];
                        return _CurrencyTile(
                          option: option,
                          isSelected: selectedCode == option.currency.code,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select currency', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                'Amounts stay stored in USD and are converted only for display.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
      ],
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({required this.option, required this.isSelected});

  final SupportedCurrencyOption option;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg.r),
      onTap: () async {
        await context.read<SettingsCubit>().updateCurrency(option.currency);
        if (context.mounted) Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
          border: Border.all(color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Text(option.currency.code, style: theme.textTheme.titleSmall),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.name, style: theme.textTheme.bodyLarge),
                  Text(option.currency.symbol, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
