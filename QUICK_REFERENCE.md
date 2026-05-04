# Quick Reference: Expenses & Categories Integration

## File Structure

```
lib/
├── core/
│   ├── widgets/
│   │   ├── category_badge.dart        (NEW) ✨
│   │   └── category_picker.dart       (NEW) ✨
│   └── utils/
│       └── category_resolver.dart     (NEW) ✨
└── features/
    ├── expenses/
    │   └── presentation/
    │       ├── widgets/
    │       │   ├── expense_form.dart           (MODIFIED) 🔄
    │       │   ├── expense_form_content.dart   (MODIFIED) 🔄
    │       │   ├── expense_list_item.dart      (MODIFIED) 🔄
    │       │   ├── expenses_list_view.dart     (MODIFIED) 🔄
    │       │   └── expenses_state_view.dart    (MODIFIED) 🔄
    │       └── cubit/ (No changes needed)
    └── categories/
        └── presentation/ (No changes needed)
```

## One-Minute Summary

### What Changed
1. **Expense Form:** TextField → CategoryPicker (visual selection)
2. **Expense List:** Text category name → CategoryBadge (icon + color)
3. **State Management:** Categories now flow through expense screens
4. **Data:** Expenses still store `categoryId` (no domain changes)

### How It Works
```dart
// User creates expense
1. Opens form
2. Sees CategoryPicker with all categories
3. Selects category (icon + color + name)
4. Form stores category.id in Expense
5. On display, CategoryResolver maps id → Category → CategoryBadge
```

## Import Reference

### When Using CategoryBadge
```dart
import 'package:spend_wise/core/widgets/category_badge.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';

// Simple usage
CategoryBadge(category: category)

// With selection state
CategoryBadge(
  category: category,
  size: CategoryBadgeSize.small,
  isSelected: true,
  onTap: () => print('Tapped!'),
)
```

### When Using CategoryPicker
```dart
import 'package:spend_wise/core/widgets/category_picker.dart';

CategoryPicker(
  categories: categories,
  onCategorySelected: (category) {
    setState(() => _selectedCategory = category);
  },
  selectedCategoryId: _selectedCategory?.id,
)
```

### When Using CategoryResolver
```dart
import 'package:spend_wise/core/utils/category_resolver.dart';

// Single resolution
final category = CategoryResolver.resolveCategory(
  expense.categoryId,
  categories,
);

// Batch resolution
final categoryMap = CategoryResolver.resolveCategoriesBatch(
  expenseIds,
  categories,
);
```

## Common Patterns

### Pattern 1: Display Expense Category
```dart
class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({
    required this.expense,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final category = CategoryResolver.resolveCategory(
      expense.categoryId,
      categories,
    );
    
    return CategoryBadge(category: category);
  }
}
```

### Pattern 2: Select Category in Form
```dart
class ExpenseForm extends StatefulWidget {
  final List<Category> categories;
  // ...
}

class _ExpenseFormState extends State<ExpenseForm> {
  late Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return CategoryPicker(
      categories: widget.categories,
      onCategorySelected: (category) {
        setState(() => _selectedCategory = category);
      },
      selectedCategoryId: _selectedCategory?.id,
    );
  }
}
```

### Pattern 3: Read Categories in Widget
```dart
BlocBuilder<CategoryCubit, CategoryState>(
  buildWhen: (previous, current) =>
      previous.categories != current.categories,
  builder: (context, categoryState) {
    return MyWidget(
      categories: categoryState.categories,
    );
  },
)
```

### Pattern 4: Pass Categories Through Widget Tree
```dart
class Parent extends StatelessWidget {
  final List<Category> categories;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Child(
          category: categories[index],
        );
      },
    );
  }
}
```

## Key Design Decisions

| Decision | Reason |
|----------|--------|
| Store `categoryId` in Expense | Type-safe reference, allows category updates without affecting expenses |
| CategoryResolver utility | Graceful fallbacks when categories are deleted |
| BlocBuilder with buildWhen | Performance optimization, prevents unnecessary rebuilds |
| Three sizes for CategoryBadge | Reusability across different contexts |
| CategoryPicker 3-column grid | Optimal for mobile screen size |
| Fallback category | UI never crashes even if category is missing |

## Debugging Tips

### Issue: Categories not appearing in form
**Check:**
1. CategoryCubit is initialized in MainShellPage
2. `loadCategories()` is called
3. categories list is passed to ExpenseForm
4. BlocBuilder is reading CategoryCubit

### Issue: Category color not showing
**Check:**
1. Category.color is set (int value)
2. CategoryBadge receives category correctly
3. Color(category.color) is valid

### Issue: Form submission fails
**Check:**
1. _selectedCategory is not null before submission
2. Category validation happens before form validation
3. User sees error message if no category selected

## Performance Notes

### What's Optimized
✅ Selective rebuilds with `buildWhen`
✅ Immutable Category entities
✅ Fallback resolution caching
✅ No repeated list lookups

### What Could Be Optimized
⚠️ Batch category resolution for large expense lists
⚠️ Category caching in ExpenseListItem
⚠️ Virtual scrolling for 1000+ expenses

## Testing Quick Start

```dart
// Test CategoryResolver
test('resolveCategory returns category when found', () {
  final category = CategoryResolver.resolveCategory('food', categories);
  expect(category.name, equals('Food'));
});

// Test fallback
test('resolveCategory returns fallback when not found', () {
  final category = CategoryResolver.resolveCategory('unknown', []);
  expect(category.name, equals('Unknown Category'));
});

// Test CategoryBadge
testWidgets('CategoryBadge displays icon and name', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CategoryBadge(category: mockCategory),
      ),
    ),
  );
  expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  expect(find.text('Food'), findsOneWidget);
});

// Test CategoryPicker
testWidgets('CategoryPicker shows all categories', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CategoryPicker(
          categories: categories,
          onCategorySelected: (_) {},
        ),
      ),
    ),
  );
  expect(find.byType(CategoryBadge), findsNWidgets(categories.length));
});
```

## Migration Guide (If Needed)

If you need to migrate from text-based categories to structured categories:

```dart
// Create Category from existing text
final textCategory = 'Food';
final category = CategoryResolver.createCategoryFromText(
  textCategory,
  color: 0xFFFF6B6B,
  icon: 'restaurant',
);

// Use batch resolution for existing expenses
final expenseTexts = expenses.map((e) => e.categoryId).toList();
final categoryMap = CategoryResolver.resolveCategoriesBatch(
  expenseTexts,
  categories,
);
```

## Contact & Support

For questions about the integration:
1. Check INTEGRATION_GUIDE.md for detailed documentation
2. Review CategoryResolver source for fallback behavior
3. Check CategoryPicker/CategoryBadge for UI customization

