import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/category.dart';

extension CategoryDisplayName on Category {
  String get localizedName {
    if (!isDefault) return name;

    return switch (id) {
      'cat_shopping' => LocaleKeys.categories_defaultCategories_shopping.tr(),
      'cat_food' => LocaleKeys.categories_defaultCategories_food.tr(),
      'cat_transport' =>
        LocaleKeys.categories_defaultCategories_transportation.tr(),
      'cat_entertainment' =>
        LocaleKeys.categories_defaultCategories_entertainment.tr(),
      'cat_utilities' => LocaleKeys.categories_defaultCategories_utilities.tr(),
      'cat_health' => LocaleKeys.categories_defaultCategories_health.tr(),
      _ => name,
    };
  }
}
