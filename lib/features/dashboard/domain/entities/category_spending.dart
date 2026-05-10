import 'package:spend_wise/features/categories/domain/entities/category.dart';

class CategorySpending {
  const CategorySpending({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final Category category;
  final double amount;
  final double percentage;
}
