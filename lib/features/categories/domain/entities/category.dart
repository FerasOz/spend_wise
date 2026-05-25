import 'package:easy_localization/easy_localization.dart';
import '../../../../generated/locale_keys.g.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final int color;
  final bool isDefault;
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isDefault,
    required this.createdAt,
  });

  String get displayName {
    if (isDefault) {
      switch (id) {
        case 'cat_shopping':
          return LocaleKeys.categories_defaultCategories_shopping.tr();
        case 'cat_food':
          return LocaleKeys.categories_defaultCategories_food.tr();
        case 'cat_transport':
          return LocaleKeys.categories_defaultCategories_transportation.tr();
        case 'cat_entertainment':
          return LocaleKeys.categories_defaultCategories_entertainment.tr();
        case 'cat_utilities':
          return LocaleKeys.categories_defaultCategories_utilities.tr();
        case 'cat_health':
          return LocaleKeys.categories_defaultCategories_health.tr();
      }
    }
    return name;
  }

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.color == color &&
        other.isDefault == isDefault &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, icon, color, isDefault, createdAt);
  }
}
