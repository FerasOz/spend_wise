import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/constants/currencies.dart';
import '../cubit/settings_cubit.dart';

void showCurrencyBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl.r),
      ),
    ),
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
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xxl.w,
            AppSpacing.lg.h,
            AppSpacing.xxl.w,
            AppSpacing.xxl.h,
          ),
          child: Column(
            children: [
              const _SheetHandle(),
              SizedBox(height: AppSpacing.lg.h),
              const _SheetHeader(),
              SizedBox(height: AppSpacing.lg.h),
              Expanded(
                child: BlocSelector<SettingsCubit, SettingsState, String>(
                  selector: (state) => state.settings?.currency.code ?? 'USD',
                  builder: (context, selectedCode) {
                    return ListView.separated(
                      itemCount: supportedCurrencies.length,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (_, index) =>
                          SizedBox(height: AppSpacing.sm.h),
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

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 52.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(32),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.currency_selection.tr(),
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                LocaleKeys.currency_displayHint.tr(),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
        ),
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
          onTap: () async {
            await context.read<SettingsCubit>().updateCurrency(option.currency);
            if (context.mounted) Navigator.of(context).pop();
          },
          splashColor: theme.colorScheme.primary.withAlpha(36),
          highlightColor: theme.colorScheme.primary.withAlpha(20),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: Row(
              children: [
                Text(option.currency.code, style: theme.textTheme.titleSmall),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.translationKey.tr(),
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        option.currency.symbol,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                          key: const ValueKey('selected'),
                        )
                      : SizedBox(key: const ValueKey('unselected')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
