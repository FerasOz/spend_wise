import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/recurring/data/models/recurring_expense_model.dart';
import 'package:spend_wise/features/recurring/domain/entities/recurring_expense.dart';

void main() {
  group('RecurringExpenseModel', () {
    final tDueDate = DateTime(2026, 7, 1);
    final tCreatedAt = DateTime(2026, 6, 1, 8);

    final tRecurringExpense = RecurringExpense(
      id: 'rec_1',
      title: 'Netflix',
      amount: 15.99,
      categoryId: 'cat_entertainment',
      repeatType: RecurringRepeatType.monthly,
      nextDueDate: tDueDate,
      isActive: true,
      createdAt: tCreatedAt,
    );

    final tRecurringJson = <String, dynamic>{
      'id': 'rec_1',
      'title': 'Netflix',
      'amount': 15.99,
      'categoryId': 'cat_entertainment',
      'repeatType': 'monthly',
      'nextDueDate': '2026-07-01T00:00:00.000',
      'isActive': true,
      'createdAt': '2026-06-01T08:00:00.000',
    };

    test('fromJson should return a valid model', () {
      final result = RecurringExpenseModel.fromJson(tRecurringJson);

      expect(result.id, tRecurringExpense.id);
      expect(result.title, tRecurringExpense.title);
      expect(result.amount, tRecurringExpense.amount);
      expect(result.categoryId, tRecurringExpense.categoryId);
      expect(result.repeatType, 'monthly');
      expect(result.nextDueDate, tRecurringExpense.nextDueDate);
      expect(result.isActive, tRecurringExpense.isActive);
      expect(result.createdAt, tRecurringExpense.createdAt);
    });

    test('toJson should return a map with correct data', () {
      final model = RecurringExpenseModel.fromEntity(tRecurringExpense);
      final result = model.toJson();

      expect(result['id'], tRecurringJson['id']);
      expect(result['title'], tRecurringJson['title']);
      expect(result['amount'], tRecurringJson['amount']);
      expect(result['categoryId'], tRecurringJson['categoryId']);
      expect(result['repeatType'], tRecurringJson['repeatType']);
      expect(result['isActive'], tRecurringJson['isActive']);
    });

    test('toEntity should map model to domain entity', () {
      final model = RecurringExpenseModel.fromEntity(tRecurringExpense);
      final entity = model.toEntity();

      expect(entity.id, tRecurringExpense.id);
      expect(entity.title, tRecurringExpense.title);
      expect(entity.amount, tRecurringExpense.amount);
      expect(entity.categoryId, tRecurringExpense.categoryId);
      expect(entity.repeatType, RecurringRepeatType.monthly);
      expect(entity.nextDueDate, tRecurringExpense.nextDueDate);
      expect(entity.isActive, tRecurringExpense.isActive);
    });

    test('toEntity should default to monthly for unknown repeatType', () {
      final json = Map<String, dynamic>.from(tRecurringJson);
      json['repeatType'] = 'daily';
      final model = RecurringExpenseModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.repeatType, RecurringRepeatType.monthly);
    });

    test('weekly repeatType should round-trip correctly', () {
      final weekly = tRecurringExpense.copyWith(
        repeatType: RecurringRepeatType.weekly,
      );
      final model = RecurringExpenseModel.fromEntity(weekly);
      final entity = model.toEntity();

      expect(entity.repeatType, RecurringRepeatType.weekly);
    });

    test('yearly repeatType should round-trip correctly', () {
      final yearly = tRecurringExpense.copyWith(
        repeatType: RecurringRepeatType.yearly,
      );
      final model = RecurringExpenseModel.fromEntity(yearly);
      final entity = model.toEntity();

      expect(entity.repeatType, RecurringRepeatType.yearly);
    });

    test('round-trip fromEntity → toJson → fromJson → toEntity', () {
      final model = RecurringExpenseModel.fromEntity(tRecurringExpense);
      final json = model.toJson();
      final restored = RecurringExpenseModel.fromJson(json);
      final entity = restored.toEntity();

      expect(entity.id, tRecurringExpense.id);
      expect(entity.title, tRecurringExpense.title);
      expect(entity.amount, tRecurringExpense.amount);
      expect(entity.repeatType, tRecurringExpense.repeatType);
      expect(entity.isActive, tRecurringExpense.isActive);
    });
  });
}
