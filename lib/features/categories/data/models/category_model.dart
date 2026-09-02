import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/category.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int color;
  final bool isDefault;
  final DateTime createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isDefault,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.fromRemoteJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: (json['color'] as num).toInt(),
      isDefault: json['is_default'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      icon: category.icon,
      color: category.color,
      isDefault: category.isDefault,
      createdAt: category.createdAt,
    );
  }

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  Map<String, dynamic> toRemoteJson(String userId) => {
    'id': id,
    'user_id': userId,
    'name': name,
    'icon': icon,
    'color': color,
    'is_default': isDefault,
  };

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      icon: icon,
      color: color,
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }
}
