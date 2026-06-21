import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/categories/data/models/category_model.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';

void main() {
  group('CategoryModel', () {
    final tCreatedAt = DateTime(2026, 1, 15, 10, 30);

    final tCategory = Category(
      id: 'cat_1',
      name: 'Food',
      icon: '🍔',
      color: 0xFF4CAF50,
      isDefault: true,
      createdAt: tCreatedAt,
    );

    final tCategoryJson = <String, dynamic>{
      'id': 'cat_1',
      'name': 'Food',
      'icon': '🍔',
      'color': 0xFF4CAF50,
      'isDefault': true,
      'createdAt': '2026-01-15T10:30:00.000',
    };

    test('fromJson should return a valid model', () {
      final result = CategoryModel.fromJson(tCategoryJson);

      expect(result.id, tCategory.id);
      expect(result.name, tCategory.name);
      expect(result.icon, tCategory.icon);
      expect(result.color, tCategory.color);
      expect(result.isDefault, tCategory.isDefault);
      expect(result.createdAt, tCategory.createdAt);
    });

    test('toJson should return a map with correct data', () {
      final model = CategoryModel.fromEntity(tCategory);
      final result = model.toJson();

      expect(result['id'], tCategoryJson['id']);
      expect(result['name'], tCategoryJson['name']);
      expect(result['icon'], tCategoryJson['icon']);
      expect(result['color'], tCategoryJson['color']);
      expect(result['isDefault'], tCategoryJson['isDefault']);
    });

    test('toEntity should map model to domain entity', () {
      final model = CategoryModel.fromEntity(tCategory);
      final entity = model.toEntity();

      expect(entity, tCategory);
    });

    test('fromEntity should preserve all fields', () {
      final model = CategoryModel.fromEntity(tCategory);

      expect(model.id, tCategory.id);
      expect(model.name, tCategory.name);
      expect(model.icon, tCategory.icon);
      expect(model.color, tCategory.color);
      expect(model.isDefault, tCategory.isDefault);
      expect(model.createdAt, tCategory.createdAt);
    });

    test('round-trip fromEntity → toJson → fromJson → toEntity', () {
      final model = CategoryModel.fromEntity(tCategory);
      final json = model.toJson();
      final restored = CategoryModel.fromJson(json);
      final entity = restored.toEntity();

      expect(entity, tCategory);
    });
  });
}
