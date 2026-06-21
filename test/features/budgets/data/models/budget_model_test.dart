import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/budgets/data/models/budget_model.dart';
import 'package:spend_wise/features/budgets/domain/entities/budget.dart';

void main() {
  group('BudgetModel', () {
    final tCreatedAt = DateTime(2026, 6, 1, 12);

    final tBudget = Budget(
      id: 'budget_1',
      categoryId: 'cat_food',
      limitAmount: 500.0,
      period: BudgetPeriod.monthly,
      createdAt: tCreatedAt,
    );

    final tBudgetJson = <String, dynamic>{
      'id': 'budget_1',
      'categoryId': 'cat_food',
      'limitAmount': 500.0,
      'period': 'monthly',
      'createdAt': '2026-06-01T12:00:00.000',
    };

    test('fromJson should return a valid model', () {
      final result = BudgetModel.fromJson(tBudgetJson);

      expect(result.id, tBudget.id);
      expect(result.categoryId, tBudget.categoryId);
      expect(result.limitAmount, tBudget.limitAmount);
      expect(result.period, 'monthly');
      expect(result.createdAt, tBudget.createdAt);
    });

    test('toJson should return a map with correct data', () {
      final model = BudgetModel.fromEntity(tBudget);
      final result = model.toJson();

      expect(result['id'], tBudgetJson['id']);
      expect(result['categoryId'], tBudgetJson['categoryId']);
      expect(result['limitAmount'], tBudgetJson['limitAmount']);
      expect(result['period'], tBudgetJson['period']);
    });

    test('toEntity should map model to domain entity with correct period', () {
      final model = BudgetModel.fromEntity(tBudget);
      final entity = model.toEntity();

      expect(entity.id, tBudget.id);
      expect(entity.categoryId, tBudget.categoryId);
      expect(entity.limitAmount, tBudget.limitAmount);
      expect(entity.period, BudgetPeriod.monthly);
      expect(entity.createdAt, tBudget.createdAt);
    });

    test('toEntity should default to monthly for unknown period', () {
      final json = Map<String, dynamic>.from(tBudgetJson);
      json['period'] = 'unknown_period';
      final model = BudgetModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.period, BudgetPeriod.monthly);
    });

    test('yearly period should round-trip correctly', () {
      final yearlyBudget = tBudget.copyWith(period: BudgetPeriod.yearly);
      final model = BudgetModel.fromEntity(yearlyBudget);
      final entity = model.toEntity();

      expect(entity.period, BudgetPeriod.yearly);
    });

    test('round-trip fromEntity → toJson → fromJson → toEntity', () {
      final model = BudgetModel.fromEntity(tBudget);
      final json = model.toJson();
      final restored = BudgetModel.fromJson(json);
      final entity = restored.toEntity();

      expect(entity.id, tBudget.id);
      expect(entity.categoryId, tBudget.categoryId);
      expect(entity.limitAmount, tBudget.limitAmount);
      expect(entity.period, tBudget.period);
      expect(entity.createdAt, tBudget.createdAt);
    });
  });
}
