import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/expenses/data/models/expense_model.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

void main() {
  group('ExpenseModel Tests', () {
    final tExpense = Expense(
      id: '1',
      title: 'Coffee',
      amount: 4.5,
      categoryId: 'cat_1',
      date: DateTime(2026, 6, 11),
      note: 'Morning coffee',
      createdAt: DateTime(2026, 6, 11, 8),
      updatedAt: DateTime(2026, 6, 11, 9),
    );

    final tExpenseJson = {
      'id': '1',
      'title': 'Coffee',
      'amount': 4.5,
      'categoryId': 'cat_1',
      'date': '2026-06-11T00:00:00.000',
      'note': 'Morning coffee',
      'createdAt': '2026-06-11T08:00:00.000',
      'updatedAt': '2026-06-11T09:00:00.000',
    };

    test('should return a valid model from JSON', () {
      final result = ExpenseModel.fromJson(tExpenseJson);
      expect(result.id, tExpense.id);
      expect(result.title, tExpense.title);
      expect(result.amount, tExpense.amount);
      expect(result.categoryId, tExpense.categoryId);
      expect(result.date, tExpense.date);
      expect(result.note, tExpense.note);
      expect(result.createdAt, tExpense.createdAt);
      expect(result.updatedAt, tExpense.updatedAt);
    });

    test('should return a JSON map containing the proper data', () {
      final model = ExpenseModel.fromEntity(tExpense);
      final result = model.toJson();
      expect(result['id'], tExpenseJson['id']);
      expect(result['title'], tExpenseJson['title']);
      expect(result['amount'], tExpenseJson['amount']);
      expect(result['categoryId'], tExpenseJson['categoryId']);
      expect(result['note'], tExpenseJson['note']);
    });

    test('should map model to domain entity', () {
      final model = ExpenseModel.fromEntity(tExpense);
      final entity = model.toEntity();
      expect(entity.id, tExpense.id);
      expect(entity.title, tExpense.title);
      expect(entity.amount, tExpense.amount);
      expect(entity.categoryId, tExpense.categoryId);
      expect(entity.date, tExpense.date);
      expect(entity.note, tExpense.note);
    });
  });
}
