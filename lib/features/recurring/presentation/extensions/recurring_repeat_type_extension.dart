import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/features/recurring/domain/entities/recurring_expense.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

extension RecurringRepeatTypeExtension on RecurringRepeatType {
  String get localizedName {
    switch (this) {
      case RecurringRepeatType.weekly:
        return LocaleKeys.recurring_form_frequencies_weekly.tr();

      case RecurringRepeatType.monthly:
        return LocaleKeys.recurring_form_frequencies_monthly.tr();

      case RecurringRepeatType.yearly:
        return LocaleKeys.recurring_form_frequencies_yearly.tr();
    }
  }
}
