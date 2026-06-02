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
