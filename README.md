# SpendWise

An offline-first Flutter application for managing personal expenses, budgets, and recurring subscriptions.

<img width="1600" height="900" alt="SpendWise" src="https://github.com/user-attachments/assets/68607ddb-0af0-42fa-848c-121b707139c9" />

## Overview

SpendWise is a bilingual expense tracker designed for Arabic- and English-speaking users. It helps users review daily and monthly spending through expense management, category-based budgets, recurring expenses, spending insights, and exportable reports.

The app follows an offline-first approach: user data is stored locally and remains available without an internet connection. When connectivity is available, pending changes can be synchronized with Supabase.

The project includes Flutter platform targets for Android, iOS, Windows, macOS, Linux, and Web. The interface supports light, dark, and system themes, with responsive layouts for different screen sizes.

> **Project status: Advanced MVP.** Core personal-finance workflows are implemented, while synchronization, data protection, testing, and release-readiness still need further hardening. See [Known Limitations and Future Work](#known-limitations-and-future-work).

## Screenshots

The showcase above provides a quick overview. The screenshots below show selected areas of the application in more detail.

### Dashboard

<p align="center">
  <img width="30%" alt="dashboard dark" src="https://github.com/user-attachments/assets/38fedcc2-d0ba-4373-b00b-c2767b06817b" />
  <img width="30%" alt="arabic dashboard" src="https://github.com/user-attachments/assets/4e89e09f-cd2a-4869-b7e5-56b909782c37" />
  <img width="30%" alt="Dashboard-stats" src="https://github.com/user-attachments/assets/d3444c18-3089-46d9-b8f9-cf9d392a81b1" />
</p>

### Expenses

<p align="center">
  <img width="30%" alt="expneses" src="https://github.com/user-attachments/assets/d4b99e08-9a14-47b7-92b6-a26f52d2da75" />
  <img width="30%" alt="add expense" src="https://github.com/user-attachments/assets/c3855c64-1d4e-4c48-8d4e-62738e0b4a33" />
</p>

### Categories

<p align="center">
  <img width="30%" alt="Categories" src="https://github.com/user-attachments/assets/ad9927cd-45af-4e51-b949-e31249b92b15" />
  <img width="30%" alt="add category" src="https://github.com/user-attachments/assets/eb58f836-7e70-41ce-a9a0-f566bf3ee3fb" />
</p>

### Recurring Expenses

<p align="center">
  <img width="30%" alt="add recurring" src="https://github.com/user-attachments/assets/6ab5df82-fd42-4c8b-9260-9d688a9d34d7" />
  <img width="30%" alt="recurring" src="https://github.com/user-attachments/assets/12897562-6308-42b4-b33a-d5af4d2ff500" />
</p>

### Budgets

<p align="center">
  <img width="30%" alt="create budget" src="https://github.com/user-attachments/assets/92ddd2ae-119b-42f0-896c-fa4295565080" />
  <img width="30%" alt="budgets" src="https://github.com/user-attachments/assets/b951e313-909b-4250-ae04-807fc1bfb6ab" />
</p>

### Authentication

<p align="center">
  <img width="30%" alt="create account dark" src="https://github.com/user-attachments/assets/aa2ee910-4c38-4a52-8e70-679b4ff2bf9a" />
  <img width="30%" alt="login arabic" src="https://github.com/user-attachments/assets/ae2d0428-be00-4a7d-917d-a35968d8a337" />
</p>

### Settings and Exports

<p align="center">
  <img width="30%" alt="settings" src="https://github.com/user-attachments/assets/9d454de4-22b9-490c-823a-079db9a8ab55" />
  <img width="30%" alt="export page" src="https://github.com/user-attachments/assets/1b5dc3f4-166b-44ab-9f6e-fbc23d3f00ad" />
</p>

## Key Features

### Accounts and Authentication
- Register, sign in, and sign out with Supabase Auth.
- Email verification flow.
- `AuthGate` separates authenticated and unauthenticated application states.
- User-scoped local storage helps prevent data from different accounts being mixed on the same device.

### Expense Management
- Create, view, edit, and delete expenses with an amount, category, date, and description.
- Search, filter by category/date/amount, and sort expense results.
- Empty, no-results, loading, and error states.
- Local writes are recorded first, with pending changes added to a synchronization queue.

### Categories and Budgets
- Create, edit, and delete categories with a name, icon, and color.
- Default categories for faster first-time setup.
- Prevent deletion of categories that are still referenced by existing data.
- Create budgets linked to categories or periods, then edit or delete them.
- Track spending progress and remaining amounts, with warnings when spending approaches or exceeds a budget.

### Recurring Expenses
- Define weekly, monthly, or yearly recurring expenses.
- Mark recurring items as active or paused.
- Generate due expenses from recurring definitions.
- Edit and delete recurring expense entries.

### Dashboard and Insights
- View a spending summary and recent expenses.
- Review weekly spending and category distribution charts.
- See budget status and budget alerts.
- Review insights such as the highest-spending category, spending trend, daily average, highest-spending day, and spending streak.
- Get a recommendation based on current expense data.

### Export and Backup
- Export expenses to CSV or JSON.
- Generate a PDF spending report.
- Export local Hive data to a backup file.
- Save exported files locally and share them through `share_plus`.
- View export history and remove entries from it.

### Settings
- Switch between Arabic and English.
- Choose light, dark, or system theme.
- Choose a display currency: USD, EUR, ILS, JOD, SAR, or GBP.
- Configure notification and automatic-backup preferences.
- Reset application settings to their defaults.

> **Currency note:** Amounts are stored in USD and converted for display only. Live exchange rates and automatic exchange-rate updates are not currently implemented.

## Application Flow

1. `lib/main.dart` initializes Flutter, Supabase, Easy Localization, and dependency injection.
2. `SpendWiseApp` loads settings, applies the selected language and theme, and configures application routing.
3. `AuthGate` selects the application state based on the current Supabase authentication session.
4. The main interface uses an `IndexedStack` shell with BLoC, alongside secondary routes for features such as budgets, exports, and settings.
5. Write operations are applied locally first, and pending remote operations are recorded in `SyncQueue`.
6. The user interface reads from local storage as its primary data source.
7. When connectivity is available, synchronization processes can send pending local changes to Supabase and update local data when remote changes are received.

This design keeps the app usable during poor or unavailable connectivity. Reliable synchronization still requires clear handling and testing when the same record is modified in multiple places.

## Architecture

SpendWise uses a practical, feature-oriented version of Clean Architecture. Most features are divided into `data`, `domain`, and `presentation` layers.

```text
lib/
├── app/              Routing and the main application shell
├── core/             Constants, services, theme, utilities, and DI
├── features/         auth, expenses, categories, budgets, recurring,
│                     dashboard, insights, export, and settings
├── generated/        Generated localization files
├── main.dart         Application entry point
└── spend_wise_app.dart
```

Repositories separate business logic from specific data sources. The presentation layer communicates with repositories through use cases, while BLoC and Cubit manage presentation state.

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
├── Local Data Source ──► Local Storage
│
└── Sync Layer ─────────► Supabase
```

Local storage is the primary data source for the user experience; Supabase provides remote persistence and synchronization.

## Technology Stack

| Area | Technologies |
|---|---|
| Framework | Flutter, Dart 3.10.8 |
| State management | `flutter_bloc` |
| Dependency injection | `get_it` |
| Local storage | `hive`, `hive_flutter` |
| Authentication and synchronization | `supabase_flutter` |
| Localization | `easy_localization` |
| Charts | `fl_chart` |
| Export and reports | `csv`, `json_serializable`, `pdf`, `printing` |
| Sharing and file paths | `share_plus`, `path_provider` |
| Responsive layout | `flutter_screenutil` |
| Testing and code generation | `flutter_test`, `build_runner` |

## Getting Started

### Prerequisites

- Flutter SDK compatible with the project.
- A Supabase project for authentication and remote synchronization.

### Run locally

```bash
git clone https://github.com/FerasOz/spend_wise.git
cd spend_wise
flutter pub get
flutter run
```

Supabase configuration is required to use authentication and synchronization features. Configure the project using environment-specific values; do not hardcode Supabase credentials in production builds.

## Supabase and Data Security

The expected database structure includes:

- `profiles`
- `user_settings`
- `categories`
- `expenses`
- `budgets`
- `recurring_expenses`

Row Level Security (RLS) policies should ensure that users can access only their own data. Domain-table migrations and policies should be reviewed and tested before a production release.

Use environment-specific configuration or `--dart-define` values for Supabase credentials rather than hardcoding them in production builds.

## Testing and Code Quality

The repository includes tests for models, selected repositories, visible-expense filtering, and email verification. Examples include:

- `test/expense_model_test.dart`
- Budget, category, and recurring-expense model tests.
- Expense and category repository tests.
- `get_visible_expenses` tests.
- Email verification page tests.

Test coverage remains limited for synchronization, export, settings, dashboard, and budget workflows. Repository tests should also stay aligned with changes to synchronization dependencies and constructor contracts.

## Known Limitations and Future Work

### Reliability and production readiness
- Complete and document Supabase domain-table migrations and Row Level Security policies.
- Move Supabase configuration to environment-specific settings or `--dart-define` values.
- Add integration tests for authentication, synchronization, logout, and switching accounts on the same device.
- Define and test a conflict-resolution policy for simultaneous local and remote edits.
- Add structured error logging instead of silently swallowing authentication or synchronization failures.
- Validate imported data before restoring an invalid or incompatible backup.
- Define clear synchronization behavior for deleted records.

### Product improvements
- Implement actual notifications for budget limits and recurring expenses; current settings represent preferences only.
- Implement scheduled automatic backups with a retention policy.
- Add CSV/JSON import and backup restoration, in addition to export.
- Support live exchange rates from a trusted provider and store the rate timestamp.
- Add custom date ranges and period comparisons to insights.
- Make weekly, monthly, and yearly budget periods more explicit.
- Add expense tags, notes, and optional receipt attachments.
- Improve recurring-expense search and clearly display the next due date.

### Engineering and UX
- Expand unit coverage for critical business rules and add golden/responsive tests for primary screens.
- Add production monitoring for performance and synchronization failures.
- Improve loading, retry, and user-facing error states.
- Review accessibility, including text scaling, contrast, screen readers, and desktop keyboard navigation.
- Document contracts between repositories and `SyncQueue`.
- Add CI to run `flutter analyze`, `flutter test`, and a release build for pull requests.

## Data Model

The application is built around these entities:

| Entity | Purpose |
|---|---|
| `profiles` | User profile data linked to Supabase Auth |
| `user_settings` | Language, theme, currency, and preferences |
| `categories` | Spending categories, colors, and icons |
| `expenses` | Daily expenses linked to users and categories |
| `budgets` | Spending limits associated with categories and periods |
| `recurring_expenses` | Recurring expense definitions, status, and due dates |

Domain tables used for synchronization should include a unique record identifier, a user reference, `created_at`, `updated_at`, and appropriate indexes for common queries such as queries by user and date. The synchronization strategy should also explicitly define how deleted records are tracked and synchronized.

## Contributing

1. Create a feature branch.
2. Run `flutter analyze` and `flutter test` before opening a pull request.
3. Add or update tests for new behavior.
4. Update both English and Arabic translations when adding user-facing text.
5. Explain any impact on local storage or the Supabase schema in the pull request.
