class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note,
    this.createdAt,
    this.updatedAt,
  }) : assert(amount >= 0, 'Expense amount cannot be negative.');

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? note,
    bool clearNote = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: clearNote ? null : (note ?? this.note),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Expense &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.categoryId == categoryId &&
        other.date == date &&
        other.note == note &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amount,
    categoryId,
    date,
    note,
    createdAt,
    updatedAt,
  );
}
