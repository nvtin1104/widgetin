# CLAUDE.md — Widgetin Project Knowledge Base

## Project Overview

**Widgetin** ("Widget I Need") is a Flutter mobile app for creating and managing Android home screen widgets. The MVP delivers a **Vietnamese Lunar Calendar widget** with customizable appearance. Android-first with iOS-ready architecture. **Monorepo structure** with `app/` (Flutter) and `website/` (future).

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.38+ / Dart 3.10+ |
| State Management | Provider ^6.1.0 |
| Widget Bridge | `home_widget` ^0.5.0 |
| Lunar Logic | `lunar_calendar_converter_new` ^2.0.0 + custom Can Chi |
| Storage | SharedPreferences ^2.2.0 |
| Color Picker | `flex_color_picker` ^3.3.0 |
| Native Android | Kotlin AppWidgetProvider + XML RemoteViews |
| Design System | Material You / useMaterial3, pastel color tokens |
| Testing | flutter_test + flutter_lints ^3.0.0 |

## Project Tree

```
widgetin/                          # Monorepo root
├── CLAUDE.md                      # Claude agent knowledge base
├── agent.md                       # Universal agent guidelines
├── gemini.md                      # Gemini agent knowledge base
├── LICENSE
├── .gitignore
├── .claude/settings.local.json    # Claude Code permissions
│
├── app/                           # Flutter application
│   ├── pubspec.yaml               # Dependencies & metadata
│   ├── pubspec.lock               # Resolved dependency versions
│   ├── analysis_options.yaml      # Dart linting rules
│   ├── lib/
│   │   ├── main.dart              # Entry point — MultiProvider → WidgetinApp
│   │   ├── app.dart               # MaterialApp → HomeShell, Material You theme
│   │   ├── models/
│   │   │   └── lunar_date.dart    # Immutable LunarDate data class
│   │   ├── services/
│   │   │   └── lunar_calendar_service.dart  # Solar→Lunar + Can Chi + Hoang Dao
│   │   ├── providers/
│   │   │   └── lunar_calendar_provider.dart # ChangeNotifier wrapping service
│   │   ├── screens/
│   │   │   ├── home_shell.dart        # Scaffold + NavigationBar + IndexedStack
│   │   │   ├── dashboard_screen.dart  # Widget gallery with preview cards
│   │   │   └── settings_screen.dart   # Theme, About, Licenses
│   │   ├── widgets/
│   │   │   ├── widget_preview_card.dart      # Reusable card (icon, title, preview, button)
│   │   │   └── lunar_calendar_preview.dart   # Lunar date + Can Chi + Hoang Dao preview
│   │   ├── theme/
│   │   │   ├── app_theme.dart         # ThemeData factory (Material You)
│   │   │   └── color_tokens.dart      # Pastel color constants
│   │   └── utils/
│   │       ├── can_chi_helper.dart    # Sexagenary cycle calculations
│   │       └── hoang_dao_helper.dart  # Auspicious hours lookup (6 patterns)
│   ├── test/
│   │   ├── widget_test.dart           # App integration test
│   │   ├── providers/
│   │   │   └── lunar_calendar_provider_test.dart  # 6 tests
│   │   ├── screens/
│   │   │   ├── home_shell_test.dart       # 4 tests
│   │   │   ├── dashboard_screen_test.dart # 7 tests
│   │   │   └── settings_screen_test.dart  # 5 tests
│   │   ├── services/
│   │   │   └── lunar_calendar_service_test.dart   # 8 tests
│   │   └── utils/
│   │       ├── can_chi_helper_test.dart   # 15 tests
│   │       └── hoang_dao_helper_test.dart # 10 tests
│   └── android/                   # Android native code
│       ├── app/build.gradle       # minSdk 21, targetSdk 34
│       └── app/src/main/
│           ├── AndroidManifest.xml
│           └── kotlin/com/widgetin/widgetin/MainActivity.kt
│
├── website/                       # Future — landing page / docs site
│
└── plans/20260207-1200-widgetin-mvp/
    ├── plan.md                    # Master plan with phase tracker
    ├── phase-01-project-setup.md
    ├── phase-02-lunar-calendar-logic.md
    ├── phase-03-dashboard-ui.md
    ├── phase-04-widget-editor.md
    ├── phase-05-android-native-widget.md
    ├── phase-06-polish-testing.md
    ├── research/                  # Technical research documents
    └── reports/                   # Code review & test reports
```

## Coding Conventions

### Dart/Flutter Style
- **Immutable models**: `const` constructors, `final` fields, `copyWith()` pattern
- **Private constructors** for utility classes: `ClassName._();`
- **Static methods** for pure helper functions (no instance state)
- **Linting**: `flutter_lints` enabled — no print statements, prefer const
- **Null safety**: Full null safety, use `!` only when guaranteed non-null
- **Import style**: Relative imports within `lib/`, package imports for dependencies

### Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Methods/variables: `camelCase`
- Constants: `camelCase` (Dart convention)
- Test files: `<source_file>_test.dart` in mirrored directory structure

### Architecture Patterns
- **Provider pattern**: ChangeNotifier classes in `providers/`
- **Service pattern**: Stateless facades combining multiple utilities
- **Model pattern**: Immutable data with `copyWith`, `toString`, computed getters
- **Utility pattern**: Static-only classes with private constructors

## Color Palette (Pastel Tokens)

| Name | Hex | Usage |
|------|-----|-------|
| Soft Red | `#E8998D` | Accent, highlights |
| Cream | `#FAF8F3` | Scaffold background |
| Sage Green | `#C4DDC4` | Primary seed color (ColorScheme.fromSeed) |
| Dark Text | `#2D2D2D` | Primary text |
| Muted Text | `#8B8B8B` | Secondary text |

## Domain Knowledge — Vietnamese Lunar Calendar

### Key Concepts
- **Âm Lịch**: Vietnamese lunar calendar
- **Can Chi**: Sexagenary cycle — 10 Heavenly Stems (Thiên Can) + 12 Earthly Branches (Địa Chi)
- **Giờ Hoàng Đạo**: 6 auspicious hours per day, determined by day's Địa Chi
- **Nhuận**: Leap month in lunar calendar

### Can Chi Formulas
- Year Can: `(lunarYear + 6) % 10` / Year Chi: `(lunarYear + 8) % 12`
- Day Can: `(JDN + 9) % 10` / Day Chi: `(JDN + 1) % 12`

### Verification Dates
- Tết 2024 = Feb 10 (Giáp Thìn) / Tết 2025 = Jan 29 (Ất Tỵ)

## Project Status

| Phase | Description | Status |
|-------|-------------|--------|
| 01 | Project Setup & Architecture | **Done** |
| 02 | Lunar Calendar Core Logic | **Done** |
| 03 | Dashboard UI (bottom nav, gallery, settings) | **Done** |
| 04 | Widget Editor (customization UI) | Pending |
| 05 | Android Native Widget (Kotlin RemoteViews) | Pending |
| 06 | Polish & Testing (E2E, performance) | Pending |

## Key Constraints

- RemoteViews only for Android widget — no custom fonts, limited View types
- `updatePeriodMillis` min 15min; daily update sufficient
- Lunar converter verified 1900–2100
- Android: minSdk 21, targetSdk 34
- Flutter path: `C:\code\flutter\bin`

## Common Commands

```bash
cd app/
flutter test                    # Run all tests (68 total)
flutter analyze                 # Static analysis
flutter run -d chrome           # Run on Chrome
flutter run                     # Run on connected device
flutter build apk --release     # Build release APK
```
