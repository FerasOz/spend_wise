# Expenses & Categories Integration Guide

## Overview

This document explains the comprehensive integration of the Expenses and Categories features in SpendWise. The integration transforms the app from using manual text-based category input to a structured, visually-rich category selection and display system.

---

## Architecture Overview

### Key Components

```
┌─────────────────────────────────────────────────────────────────┐
│                    Expense Feature                              │
├─────────────────────────────────────────────────────────────────┤
│  ├─ Domain Layer                                                 │
│  │  └─ Expense Entity (categoryId: String)                      │
│  ├─ Presentation Layer                                           │
│  │  ├─ ExpenseCubit (state management)                          │
│  │  ├─ ExpenseForm (now uses CategoryPicker)                    │
│  │  └─ ExpenseListItem (displays with CategoryBadge)            │
│  └─ Data Layer                                                   │
│     └─ Manages expense persistence                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                    (categoryId reference)
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                  Categories Feature                             │
├─────────────────────────────────────────────────────────────────┤
│  ├─ Domain Layer                                                 │
│  │  └─ Category Entity (id, name, icon, color, ...)            │
│  ├─ Presentation Layer                                           │
│  │  ├─ CategoryCubit (state management)                         │
│  │  └─ Category management UI                                   │
│  └─ Data Layer                                                   │
│     └─ Local storage via Hive                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Core Utilities

```
CategoryResolver
├─ resolveCategory()        → Map categoryId to Category object
├─ createFallbackCategory() → Handle missing categories gracefully
└─ resolveCategoriesBatch() → Efficiently resolve multiple categories
```

---

## Data Flow

### 1. Expense Creation Flow

```
User Opens Expense Form
         ↓
[ExpenseFormContent reads CategoryCubit]
         ↓
[CategoryPicker displays available categories]
         ↓
User selects category (visual: icon + color + name)
         ↓
[Category object stored in _selectedCategory state]
         ↓
User submits form
         ↓
[Expense created with category.id (reference)]
         ↓
Expense stored with categoryId in Hive
```

### 2. Expense Display Flow

```
ExpensesPage loads
         ↓
[ExpensesStateView reads both ExpenseCubit & CategoryCubit]
         ↓
[ExpensesListView passes categories to each ExpenseListItem]
         ↓
ExpenseListItem resolves categoryId using CategoryResolver
         ↓
[CategoryBadge displays with icon + color]
```

---

## New Widgets

### 1. CategoryBadge
**Location:** `lib/core/widgets/category_badge.dart`

Displays a category with its icon, color, and name in three variants:

- **Small:** Inline badge with icon and text (used in lists)
- **Medium:** Slightly larger, for forms
- **Large:** Grid item with centered icon and text (used in pickers)

**Features:**
- Visual feedback (selection border)
- Tap callback support
- Automatic color styling
- Icon resolution from CategoryPresentationData

**Usage:**
```dart
CategoryBadge(
  category: category,
  size: CategoryBadgeSize.small,
  isSelected: false,
)
```

### 2. CategoryPicker
**Location:** `lib/core/widgets/category_picker.dart`

Allows users to select from available categories in a grid layout.

**Features:**
- Grid display (3 columns)
- Visual selection feedback
- Empty state handling
- Callback on category selection

**Usage:**
```dart
CategoryPicker(
  categories: categories,
  onCategorySelected: (category) {
    setState(() => _selectedCategory = category);
  },
  selectedCategoryId: _selectedCategory?.id,
)
```

---

## Utilities

### CategoryResolver
**Location:** `lib/core/utils/category_resolver.dart`

Handles mapping categoryId to Category objects with intelligent fallback handling.

**Key Methods:**

1. **resolveCategory()**
   ```dart
   static Category resolveCategory(
     String categoryId,
     List<Category> categories,
   )
   ```
   - Finds category by ID
   - Returns fallback if not found
   - Never throws exceptions

2. **resolveCategoriesBatch()**
   ```dart
   static Map<String, Category> resolveCategoriesBatch(
     List<String> categoryIds,
     List<Category> categories,
   )
   ```
   - Efficiently resolves multiple categories
   - Caches results to avoid duplicate lookups
   - Useful for expense list rendering

3. **createFallbackCategory()**
   - Creates a "Unknown Category" placeholder
   - Prevents UI crashes when category is deleted

---

## Modified Components

### 1. ExpenseFormContent
**Changes:**
- Now reads both `ExpenseCubit` and `CategoryCubit`
- Passes categories list to `ExpenseForm`
- Uses nested `BlocBuilder` for selective rebuilds

**Before:**
```dart
BlocBuilder<ExpenseCubit, ExpenseState>(
  builder: (context, state) {
    return ExpenseForm(
      selectedDate: state.selectedDate,
      // ...
    );
  },
)
```

**After:**
```dart
BlocBuilder<CategoryCubit, CategoryState>(
  buildWhen: (previous, current) =>
      previous.categories != current.categories,
  builder: (context, categoryState) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, expenseState) {
        return ExpenseForm(
          categories: categoryState.categories,
          // ...
        );
      },
    );
  },
)
```

### 2. ExpenseForm
**Major Changes:**
- Replaced `_categoryController` TextField with category state management
- Replaced category TextField with `CategoryPicker` widget
- Validation now checks if category is selected
- Form submission uses `category.id` instead of text input

**Key State:**
```dart
late Category? _selectedCategory;
```

**Category Section:**
```dart
Widget _buildCategorySection(BuildContext context) {
  return CategoryPicker(
    categories: widget.categories,
    onCategorySelected: (category) {
      setState(() => _selectedCategory = category);
    },
    selectedCategoryId: _selectedCategory?.id,
  );
}
```

### 3. ExpenseListItem
**Changes:**
- Now accepts `categories` parameter
- Uses `CategoryResolver` to resolve categoryId
- Displays category using `CategoryBadge` instead of plain text
- Container color now matches category color

**Before:**
```dart
Text(
  expense.categoryId,
  style: theme.textTheme.bodyMedium?.copyWith(...),
)
```

**After:**
```dart
CategoryBadge(
  category: category,
  size: CategoryBadgeSize.small,
  isSelected: false,
)
```

### 4. ExpensesListView
**Changes:**
- Now accepts and passes `categories` to each item

**Updated Signature:**
```dart
const ExpensesListView({
  required this.expenses,
  required this.categories,
  super.key,
});
```

### 5. ExpensesStateView
**Changes:**
- Now reads `CategoryCubit` state
- Uses nested `BlocBuilder` to pass categories to `ExpensesListView`
- Smart rebuilding when categories change

**Key Addition:**
```dart
BlocBuilder<CategoryCubit, CategoryState>(
  buildWhen: (previous, current) =>
      previous.categories != current.categories,
  builder: (context, categoryState) {
    return ExpensesListView(
      expenses: state.expenses,
      categories: categoryState.categories,
    );
  },
)
```

---

## State Management Flow

### Initialization
```
App Start (MainShellPage)
├─ MultiBlocProvider
│  ├─ ShellCubit
│  ├─ ExpenseCubit..loadExpenses()
│  └─ CategoryCubit..loadCategories()
└─ Both cubits initialized before any screens load
```

### Context Availability
- **MainShellPage:** Both cubits available
- **ExpensesPage:** Inherits both cubits from parent
- **ExpenseFormPage:** Has access to parent cubits via context

### Rebuild Optimization
- `ExpensesStateView` only rebuilds when categories change
- `ExpenseListItem` is stateless, rebuilds with parent
- `CategoryPicker` rebuilds only when categories list changes

---

## Edge Cases & Fallbacks

### 1. Missing Category (Deleted)
When a category is deleted but expenses still reference it:

```dart
// CategoryResolver creates fallback
final category = CategoryResolver.resolveCategory(
  expense.categoryId,
  categories, // missing category won't be found
);
// Returns: Category(
//   id: categoryId,
//   name: 'Unknown Category',
//   icon: 'shopping_cart',
//   color: 0xFFFF6B6B,
// )
```

### 2. No Categories Available
When user tries to add expense but no categories exist:

```dart
CategoryPicker(
  categories: [], // empty
  onCategorySelected: (category) { ... },
  emptyStateMessage: 'No categories available. Please create one first.',
)
// Displays: Empty state with icon and message
```

### 3. No Expenses
Handled by `ExpensesFeedbackView`:
```
"No expenses yet"
"Start tracking your spending by adding your first expense."
```

---

## Performance Considerations

### 1. Avoiding Repeated Lookups
**Problem:** For each expense in a list, we'd resolve the category separately

**Solution:** Use `CategoryResolver.resolveCategoriesBatch()`
```dart
final categoryMap = CategoryResolver.resolveCategoriesBatch(
  expenses.map((e) => e.categoryId).toList(),
  categories,
);
// Reuse categoryMap instead of resolving each expense individually
```

### 2. Selective Rebuilds
Using `buildWhen` to prevent unnecessary rebuilds:
```dart
BlocBuilder<CategoryCubit, CategoryState>(
  buildWhen: (previous, current) =>
      previous.categories != current.categories, // Only rebuild when categories change
  builder: (context, categoryState) { ... },
)
```

### 3. Immutable State
Categories are immutable entities, enabling:
- Reference equality checks
- Caching
- Predictable rebuilds

---

## Testing Checklist

### Unit Tests
- [ ] `CategoryResolver.resolveCategory()` with valid/missing categories
- [ ] `CategoryResolver.createFallbackCategory()` creates correct defaults
- [ ] `CategoryBadge` renders correctly with different sizes

### Widget Tests
- [ ] `CategoryPicker` displays all categories
- [ ] `CategoryPicker` highlights selected category
- [ ] `CategoryBadge` shows icon and name correctly
- [ ] `ExpenseForm` prevents submission without category
- [ ] `ExpenseListItem` displays category with correct color

### Integration Tests
- [ ] Create expense with selected category
- [ ] Edit expense and change category
- [ ] Delete category and verify expense displays fallback
- [ ] Expense list updates when categories are added
- [ ] Empty state shows when no categories exist

---

## Future Enhancements

### 1. Category Search in Picker
```dart
// Add search field in CategoryPicker
TextField(
  onChanged: (query) => filterCategories(query),
)
```

### 2. Quick Category Creation
```dart
// Add "Create new" button in picker
if (showCreateNew)
  GestureDetector(
    onTap: () => openCategoryCreation(),
    child: CategoryBadge(...),
  )
```

### 3. Category Suggestions
```dart
// Based on expense title, suggest category
final suggestedCategory = suggestCategory(expenseTitle);
```

### 4. Batch Category Updates
```dart
// When category is updated, auto-update all related expenses display
context.read<ExpenseCubit>().notifyCategategoryUpdate(category);
```

---

## Architecture Principles Applied

### 1. **Clean Architecture**
- ✅ Domain layer unchanged (Expense still uses categoryId)
- ✅ Presentation layer handles UI logic (CategoryResolver in utils, not domain)
- ✅ Separation of concerns (ExpenseForm, ExpenseListItem, CategoryBadge)

### 2. **BLoC Pattern**
- ✅ State-driven UI updates
- ✅ Separate cubits for different features
- ✅ Selective rebuilds with `buildWhen`

### 3. **Composition Over Inheritance**
- ✅ Reusable widgets (CategoryBadge, CategoryPicker)
- ✅ Utility-based resolution (CategoryResolver)
- ✅ Non-invasive integration

### 4. **Error Handling**
- ✅ Graceful fallbacks for missing data
- ✅ Empty states for edge cases
- ✅ No exceptions thrown, always safe defaults

---

## Summary of Changes

### New Files Created
1. `lib/core/widgets/category_badge.dart` - Display widget for categories
2. `lib/core/widgets/category_picker.dart` - Selection widget for categories
3. `lib/core/utils/category_resolver.dart` - Utility for resolving categories

### Files Modified
1. `lib/features/expenses/presentation/widgets/expense_form.dart` - Replaced TextField with CategoryPicker
2. `lib/features/expenses/presentation/widgets/expense_form_content.dart` - Added CategoryCubit integration
3. `lib/features/expenses/presentation/widgets/expense_list_item.dart` - Added CategoryBadge display
4. `lib/features/expenses/presentation/widgets/expenses_list_view.dart` - Added categories parameter
5. `lib/features/expenses/presentation/widgets/expenses_state_view.dart` - Added CategoryCubit BlocBuilder

### Key Improvements
✅ Visual category selection instead of text input
✅ Category icons and colors displayed in expense list
✅ Type-safe category references (ID-based, not text)
✅ Graceful handling of missing categories
✅ Optimized state management with selective rebuilds
✅ Reusable, composable widgets
✅ Clean architecture principles maintained
