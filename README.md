# Spend Wise

Spend Wise is a Flutter application for managing personal expenses and recurring subscriptions. It provides category-based budgets, spending insights, data export, local storage, and optional synchronization through Supabase.

> Project status: advanced MVP. The application includes most core personal-finance workflows, but several areas still require hardening before production release. See [Future Improvements](#future-improvements).

## Contents

- [Overview](#overview)
- [Current Features](#current-features)
- [Application Flow](#application-flow)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Local Setup](#local-setup)
- [Supabase Setup](#supabase-setup)
- [Testing and Code Quality](#testing-and-code-quality)
- [Future Improvements](#future-improvements)
- [Suggested Roadmap](#suggested-roadmap)

## Overview

Spend Wise is a bilingual expense tracker for Arabic- and English-speaking users. It helps users understand daily and monthly spending through a focused dashboard, category breakdowns, budget tracking, recurring expenses, and exportable reports.

The project contains Flutter platform targets for Android, iOS, Windows, macOS, Linux, and Web. The interface supports light, dark, and system themes, as well as responsive layouts for different screen sizes.

## Current Features

### Authentication and Accounts

- User registration, sign-in, and sign-out through Supabase Auth.
- Email verification flow.
- An `AuthGate` that separates authenticated and unauthenticated application states.
- User-scoped local storage to prevent data from different accounts being mixed on the same device.

### Expense Management

- Create expenses with an amount, category, date, and description.
- Edit, delete, and view expense details.
- Search and filter by category, date, and amount.
- Sort expense results.
- Empty, no-results, loading, and error states.
- Fast local writes with asynchronous synchronization through a sync queue.

### Categories

- Create, edit, and delete categories.
- Select a category name, icon, and color.
- Default categories for a faster first-time setup.
- Protection against deleting categories that are still referenced by existing data.

### Budgets

- Create budgets linked to categories or periods.
- Edit and delete budgets.
- Calculate spending progress against a defined limit.
- Display remaining amounts.
- Show warnings when spending approaches or exceeds a budget.

### Recurring Expenses and Subscriptions

- Define weekly, monthly, or yearly recurring expenses.
- Active and paused states.
- Generate due expenses from recurring definitions.
- Edit and delete recurring expense entries.

### Dashboard and Insights

- Spending summary and recent expenses.
- Weekly spending chart.
- Category spending distribution charts.
- Budget status and budget alerts.
- Spending insights including the highest-spending category, spending trend, daily average, highest-spending day, and spending streak.
- A recommendation based on the user's current expense data.

### Export and Backup

- Export expenses to CSV.
- Export expenses to JSON.
- Generate a simple PDF spending report.
- Export all local Hive data as a backup file.
- Save exported files locally and share them through `share_plus`.
- Keep an export history and remove entries from that history.

### Settings and Personalization

- English and Arabic localization.
- Light, dark, and system theme modes.
- Display currencies: USD, EUR, ILS, JOD, SAR, and GBP.
- Notification and automatic-backup preferences.
- Reset application settings to their default values.

> Currency note: amounts are stored in USD and converted for display only. The current implementation does not include live exchange rates or automatic exchange-rate updates.

## Application Flow

1. [`lib/main.dart`](lib/main.dart) initializes Flutter, Supabase, Easy Localization, and dependency injection.
2. [`SpendWiseApp`](lib/spend_wise_app.dart) loads settings, applies the selected language and theme, and configures routing.
3. [`AuthGate`](lib/features/auth/presentation/widgets/auth_gate.dart) selects the correct application state based on the Supabase session.
4. The main interface uses a shell based on `IndexedStack` and BLoC, with secondary routes for budgets, exports, and settings.
5. Write operations are saved locally first and then added to `SyncQueue` for asynchronous synchronization.
6. Read operations attempt to synchronize with Supabase and fall back to local storage when the network is unavailable.

This offline-first approach keeps the application usable during poor connectivity. It also requires explicit conflict-resolution testing when the same record is edited locally and remotely.

## Architecture

The project follows a practical, feature-oriented version of Clean Architecture:

```text
lib/
|-- app/              Routing and the main application shell
|-- core/             Constants, services, theme, utilities, and DI
|-- features/         auth, expenses, categories, budgets, recurring,
|                     dashboard, insights, export, and settings
|-- generated/        Generated localization files
|-- main.dart         Application entry point
`-- spend_wise_app.dart
```

Most features are divided into `data`, `domain`, and `presentation` layers. Repositories isolate data sources from the UI, while BLoC and Cubit classes manage presentation state.

## Technology Stack

| Area | Technology |
| --- | --- |
| Framework | Flutter / Dart 3.10.8 |
| State management | `flutter_bloc` |
| Dependency injection | `get_it` |
| Local storage | `hive` and `hive_flutter` |
| Authentication and sync | `supabase_flutter` |
| Localization | `easy_localization` |
| Charts | `fl_chart` |
| Export and reports | `csv`, `json_serializable`, `pdf`, `printing` |
| Sharing and file paths | `share_plus`, `path_provider` |
| Responsive layout | `flutter_screenutil` |
| Testing and code generation | `flutter_test`, `build_runner` |

## Testing and Code Quality

The repository currently includes tests for models, selected repositories, visible-expense filtering, and email verification, including:

- `test/expense_model_test.dart`
- Budget, category, and recurring-expense model tests.
- Expense and category repository tests.
- `get_visible_expenses` tests.
- Email verification page tests.

Coverage is currently limited for full synchronization, export, settings, dashboard, and budget workflows. Repository tests should also be kept aligned with any changes to synchronization dependencies or constructor contracts.

## Future Improvements

### High Priority Before Production

- Complete or document domain-table migrations and Row Level Security policies in Supabase.
- Move Supabase configuration to environment-specific settings or `--dart-define` values.
- Add integration tests for authentication, synchronization, logout, and switching accounts on the same device.
- Define and test a conflict-resolution policy for simultaneous local and remote edits.
- Add structured error logging instead of silently swallowing authentication or synchronization failures.
- Validate imported data before restoring an invalid or incompatible backup.

### Product Improvements

- Implement actual notifications for budget limits and recurring expenses; the current settings represent preferences only.
- Implement scheduled automatic backups with a retention policy.
- Add CSV/JSON import and backup restoration, not only export.
- Support live exchange rates from a trusted provider and store the rate timestamp.
- Add a dedicated insights screen with custom date ranges and period comparisons.
- Make weekly, monthly, and yearly budget periods more explicit.
- Add expense tags, notes, and optional receipt attachments.
- Improve recurring-expense search and clearly display the next due date.

### Engineering and UX Improvements

- Increase unit coverage for critical business rules and add golden/responsive tests for primary screens.
- Add production monitoring for performance and synchronization failure rates.
- Improve loading, retry, and user-facing error states.
- Review accessibility, including text scaling, contrast, screen readers, and desktop keyboard navigation.
- Document the contracts between repositories and `SyncQueue`.
- Add CI that runs `flutter analyze`, `flutter test`, and a release build for pull requests.

## Suggested Roadmap

1. **Stabilize the foundation:** complete the Supabase schema and RLS policies, separate environments, and add structured logging.
2. **Protect user data:** add synchronization and conflict tests, then implement validated import and restoration.
3. **Automate recurring work:** add budget notifications, recurring-expense reminders, and scheduled backups.
4. **Improve insights:** add customizable reports, period comparisons, and updated exchange rates.
5. **Prepare for release:** add CI/CD, device testing, accessibility review, privacy documentation, and a clear backup policy.

## Expected Data Model

The application is built around the following entities:

- `profiles`: user profile data linked to Supabase Auth.
- `user_settings`: language, theme, currency, and user preferences.
- `categories`: spending categories, colors, and icons.
- `expenses`: daily expenses linked to users and categories.
- `budgets`: spending limits associated with categories and periods.
- `recurring_expenses`: recurring expense definitions, status, and due dates.

Domain tables should include synchronization fields such as `updated_at`, a user reference, and indexes suitable for queries by user and date.

## Contributing

1. Create a feature branch.
2. Run `flutter analyze` and `flutter test` before opening a pull request.
3. Add or update tests for new behavior.
4. Update both English and Arabic translations when adding user-facing text.
5. Explain any impact on local storage or the Supabase schema in the pull request.

## License

No license has been defined for this project yet. Add a `LICENSE` file before distributing the application or accepting external contributions.
