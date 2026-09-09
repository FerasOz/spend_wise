# Spend Wise

Spend Wise is an offline-first Flutter application for managing personal expenses and recurring subscriptions. It provides category-based budgets, spending insights, data export, local storage, and optional cloud synchronization through Supabase.

> Project status: Advanced MVP. The application includes most core personal-finance workflows, but several areas still require hardening before a production release. See [Future Improvements](#future-improvements).

## Contents

* [Overview](#overview)
* [Screenshots](#screenshots)
* [Current Features](#current-features)
* [Application Flow](#application-flow)
* [Architecture](#architecture)
* [Technology Stack](#technology-stack)
* [Local Setup](#local-setup)
* [Supabase Setup](#supabase-setup)
* [Testing and Code Quality](#testing-and-code-quality)
* [Future Improvements](#future-improvements)
* [Suggested Roadmap](#suggested-roadmap)
* [Expected Data Model](#expected-data-model)
* [Contributing](#contributing)
* [License](#license)

## Overview

Spend Wise is a bilingual expense tracker designed for Arabic- and English-speaking users. It helps users understand daily and monthly spending through a focused dashboard, category breakdowns, budget tracking, recurring expenses, spending insights, and exportable reports.

The application follows an offline-first approach. User data is stored locally and remains accessible without an internet connection. When connectivity is available, pending changes can be synchronized with Supabase in the background.

The project contains Flutter platform targets for Android, iOS, Windows, macOS, Linux, and Web. The interface supports light, dark, and system themes, as well as responsive layouts for different screen sizes.

## Screenshots

Screenshots are organized by major application areas to keep the README readable.

### Dashboard

<!-- Add dashboard screenshots here -->

### Expenses

<!-- Add expense list, expense details, and expense form screenshots here -->

### Categories and Budgets

<!-- Add category and budget screenshots here -->

### Insights

<!-- Add charts and insights screenshots here -->

### Settings and Personalization

<!-- Add settings, theme, and language screenshots here -->

### Authentication

<!-- Add login, registration, and email verification screenshots here -->

> Additional screenshots can be found in the `screenshots/` directory.

## Current Features

### Authentication and Accounts

* User registration, sign-in, and sign-out through Supabase Auth.
* Email verification flow.
* An `AuthGate` that separates authenticated and unauthenticated application states.
* User-scoped local storage to prevent data from different accounts being mixed on the same device.

### Expense Management

* Create expenses with an amount, category, date, and description.
* Edit, delete, and view expense details.
* Search and filter by category, date, and amount.
* Sort expense results.
* Empty, no-results, loading, and error states.
* Fast local writes with pending changes recorded in a synchronization queue.

### Categories

* Create, edit, and delete categories.
* Select a category name, icon, and color.
* Default categories for a faster first-time setup.
* Protection against deleting categories that are still referenced by existing data.

### Budgets

* Create budgets linked to categories or periods.
* Edit and delete budgets.
* Calculate spending progress against a defined limit.
* Display remaining amounts.
* Show warnings when spending approaches or exceeds a budget.

### Recurring Expenses and Subscriptions

* Define weekly, monthly, or yearly recurring expenses.
* Active and paused states.
* Generate due expenses from recurring definitions.
* Edit and delete recurring expense entries.

### Dashboard and Insights

* Spending summary and recent expenses.
* Weekly spending chart.
* Category spending distribution charts.
* Budget status and budget alerts.
* Spending insights including the highest-spending category, spending trend, daily average, highest-spending day, and spending streak.
* A recommendation based on the user's current expense data.

### Export and Backup

* Export expenses to CSV.
* Export expenses to JSON.
* Generate a simple PDF spending report.
* Export all local Hive data as a backup file.
* Save exported files locally and share them through `share_plus`.
* Keep an export history and remove entries from that history.

### Settings and Personalization

* English and Arabic localization.
* Light, dark, and system theme modes.
* Display currencies: USD, EUR, ILS, JOD, SAR, and GBP.
* Notification and automatic-backup preferences.
* Reset application settings to their default values.

> Currency note: amounts are currently stored in USD and converted for display only. The current implementation does not include live exchange rates or automatic exchange-rate updates.

## Application Flow

1. [`lib/main.dart`](lib/main.dart) initializes Flutter, Supabase, Easy Localization, and dependency injection.

2. [`SpendWiseApp`](lib/spend_wise_app.dart) loads settings, applies the selected language and theme, and configures application routing.

3. [`AuthGate`](lib/features/auth/presentation/widgets/auth_gate.dart) selects the appropriate application state based on the current Supabase authentication session.

4. The main interface uses a shell based on `IndexedStack` and BLoC, with secondary routes for features such as budgets, exports, and settings.

5. Write operations are applied to the local database first. Pending remote operations are then recorded in `SyncQueue`.

6. The user interface reads from local storage as its primary data source.

7. When connectivity is available, synchronization processes can send pending local changes to Supabase and update local data when remote changes are received.

This offline-first approach keeps the application usable during poor or unavailable connectivity. Reliable synchronization also requires clear handling and testing of situations where the same record is modified from multiple locations.

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

Most features are divided into `data`, `domain`, and `presentation` layers.

Repositories isolate the application's business logic from specific data sources. The presentation layer communicates with repositories through use cases, while BLoC and Cubit classes manage presentation state.

For data synchronization, local storage acts as the primary data source for the user experience, while Supabase provides remote persistence and synchronization.

```text
UI
│
▼
Cubit / BLoC
│
▼
Use Cases
│
▼
Repository
│
├──────────────► Local Data Source
│                       │
│                       ▼
│                  Local Storage
│
└──────────────► Sync Layer
                        │
                        ▼
                    Supabase
```

## Technology Stack

| Area                               | Technology                                    |
| ---------------------------------- | --------------------------------------------- |
| Framework                          | Flutter / Dart 3.10.8                         |
| State management                   | `flutter_bloc`                                |
| Dependency injection               | `get_it`                                      |
| Local storage                      | `hive` and `hive_flutter`                     |
| Authentication and synchronization | `supabase_flutter`                            |
| Localization                       | `easy_localization`                           |
| Charts                             | `fl_chart`                                    |
| Export and reports                 | `csv`, `json_serializable`, `pdf`, `printing` |
| Sharing and file paths             | `share_plus`, `path_provider`                 |
| Responsive layout                  | `flutter_screenutil`                          |
| Testing and code generation        | `flutter_test`, `build_runner`                |

## Local Setup

Instructions for installing Flutter and running the application locally should be added here.

A typical setup will include:

```bash
git clone <repository-url>
cd spend-wise
flutter pub get
flutter run
```

The application also requires Supabase configuration before authentication and synchronization features can be used.

## Supabase Setup

The project uses Supabase for authentication and remote synchronization.

Before running the application, create a Supabase project and configure the required environment values.

The expected database structure includes:

* `profiles`
* `user_settings`
* `categories`
* `expenses`
* `budgets`
* `recurring_expenses`

Row Level Security policies should ensure that users can only access their own data.

Supabase credentials should not be hardcoded in production builds. Environment-specific configuration or `--dart-define` values should be used instead.

## Testing and Code Quality

The repository currently includes tests for models, selected repositories, visible-expense filtering, and email verification, including:

* `test/expense_model_test.dart`
* Budget, category, and recurring-expense model tests.
* Expense and category repository tests.
* `get_visible_expenses` tests.
* Email verification page tests.

Coverage is currently limited for full synchronization, export, settings, dashboard, and budget workflows.

Repository tests should also be kept aligned with any changes to synchronization dependencies or constructor contracts.

## Future Improvements

### High Priority Before Production

* Complete and document domain-table migrations and Row Level Security policies in Supabase.
* Move Supabase configuration to environment-specific settings or `--dart-define` values.
* Add integration tests for authentication, synchronization, logout, and switching accounts on the same device.
* Define and test a conflict-resolution policy for simultaneous local and remote edits.
* Add structured error logging instead of silently swallowing authentication or synchronization failures.
* Validate imported data before restoring an invalid or incompatible backup.
* Define clear synchronization behavior for deleted records.

### Product Improvements

* Implement actual notifications for budget limits and recurring expenses; the current settings represent preferences only.
* Implement scheduled automatic backups with a retention policy.
* Add CSV/JSON import and backup restoration, not only export.
* Support live exchange rates from a trusted provider and store the rate timestamp.
* Add a dedicated insights screen with custom date ranges and period comparisons.
* Make weekly, monthly, and yearly budget periods more explicit.
* Add expense tags, notes, and optional receipt attachments.
* Improve recurring-expense search and clearly display the next due date.

### Engineering and UX Improvements

* Increase unit coverage for critical business rules and add golden/responsive tests for primary screens.
* Add production monitoring for performance and synchronization failure rates.
* Improve loading, retry, and user-facing error states.
* Review accessibility, including text scaling, contrast, screen readers, and desktop keyboard navigation.
* Document the contracts between repositories and `SyncQueue`.
* Add CI that runs `flutter analyze`, `flutter test`, and a release build for pull requests.

## Suggested Roadmap

1. **Stabilize the foundation:** Complete the Supabase schema and RLS policies, separate environments, and add structured logging.

2. **Protect user data:** Add synchronization and conflict-resolution tests, then implement validated import and restoration.

3. **Automate recurring work:** Add budget notifications, recurring-expense reminders, and scheduled backups.

4. **Improve insights:** Add customizable reports, period comparisons, and updated exchange rates.

5. **Prepare for release:** Add CI/CD, device testing, an accessibility review, privacy documentation, and a clear backup policy.

## Expected Data Model

The application is built around the following entities:

* `profiles`: User profile data linked to Supabase Auth.
* `user_settings`: Language, theme, currency, and user preferences.
* `categories`: Spending categories, colors, and icons.
* `expenses`: Daily expenses linked to users and categories.
* `budgets`: Spending limits associated with categories and periods.
* `recurring_expenses`: Recurring expense definitions, status, and due dates.

Domain tables used for synchronization should include appropriate fields such as:

* A unique record identifier.
* A user reference.
* `created_at`.
* `updated_at`.
* Appropriate indexes for common queries, such as queries by user and date.

The synchronization strategy should also explicitly define how deleted records are tracked and synchronized.

## Contributing

1. Create a feature branch.
2. Run `flutter analyze` and `flutter test` before opening a pull request.
3. Add or update tests for new behavior.
4. Update both English and Arabic translations when adding user-facing text.
5. Explain any impact on local storage or the Supabase schema in the pull request.

## License

No license has been defined for this project yet. Add a `LICENSE` file before distributing the application or accepting external contributions.
