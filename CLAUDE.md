# CLAUDE.md — Widgetin Project Knowledge Base

## Project Overview

**Widgetin** ("Widget I Need") is a Flutter mobile app for creating and managing Android home screen widgets. The MVP delivers a **Vietnamese Lunar Calendar widget** with customizable appearance. Android-first with iOS-ready architecture.

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.x + Dart (SDK >=3.0.0 <4.0.0) |
| State Management | Provider ^6.1.0 |
| Widget Bridge | `home_widget` ^0.5.0 |
| Lunar Logic | `lunar_calendar_converter` ^1.1.0 + custom Can Chi |
| Storage | SharedPreferences ^2.2.0 |
| Color Picker | `flex_color_picker` ^3.3.0 |
| Native Android | Kotlin AppWidgetProvider + XML RemoteViews |
| Design System | Material You / useMaterial3, pastel color tokens |
| Testing | flutter_test + flutter_lints ^3.0.0 |

## Architecture

```
lib/
├── main.dart              # Entry point — MultiProvider wraps WidgetinApp
├── app.dart               # MaterialApp with AppTheme.light, no debug banner
├── models/                # Immutable data classes (const constructors)
│   └── lunar_date.dart    # LunarDate: solar↔lunar, Can Chi, Hoang Dao
├── services/              # Business logic facades
│   └── lunar_calendar_service.dart  # Solar→Lunar + Can Chi + Hoang Dao
├── providers/             # Provider ChangeNotifiers (state management)
├── screens/               # Full-page screens (Dashboard, Editor, Settings)
├── widgets/               # Reusable UI components
├── theme/
│   ├── app_theme.dart     # ThemeData — Material You, rounded corners
│   └── color_tokens.dart  # Pastel palette constants
└── utils/
    ├── can_chi_helper.dart    # Thien Can + Dia Chi calculations
    └── hoang_dao_helper.dart  # Gio Hoang Dao lookup (6 patterns)
```

## Coding Conventions

### Dart/Flutter Style
- **Immutable models**: Use `const` constructors, `final` fields, `copyWith()` pattern
- **Private constructors** for utility classes: `ClassName._();`
- **Static methods** for pure helper functions (no instance state)
- **Linting**: `flutter_lints` enabled — no print statements, prefer const
- **Null safety**: Full null safety, use `!` only when guaranteed non-null (e.g., library output)
- **Import style**: Relative imports within `lib/`, package imports for dependencies

### Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Methods/variables: `camelCase`
- Constants: `camelCase` (Dart convention, not SCREAMING_SNAKE)
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

Theme uses `ColorScheme.fromSeed(seedColor: sageGreen)` with Material You (`useMaterial3: true`).

## Domain Knowledge — Vietnamese Lunar Calendar

### Key Concepts
- **Am Lich (Âm Lịch)**: Vietnamese lunar calendar
- **Can Chi (Thiên Can + Địa Chi)**: Sexagenary cycle — 10 Heavenly Stems + 12 Earthly Branches
- **Thien Can (10)**: Giáp, Ất, Bính, Đinh, Mậu, Kỷ, Canh, Tân, Nhâm, Quý
- **Dia Chi (12)**: Tý, Sửu, Dần, Mão, Thìn, Tỵ, Ngọ, Mùi, Thân, Dậu, Tuất, Hợi
- **Gio Hoang Dao (Giờ Hoàng Đạo)**: 6 auspicious hours per day, determined by day's Dia Chi
- **Nhuan (Nhuận)**: Leap month in lunar calendar

### Can Chi Formulas
- Year Can: `(lunarYear + 6) % 10`
- Year Chi: `(lunarYear + 8) % 12`
- Month Can: `(yearCanIndex * 2 + lunarMonth + 1) % 10`
- Month Chi: `(lunarMonth + 1) % 12`
- Day Can: `(JDN + 9) % 10`
- Day Chi: `(JDN + 1) % 12`

### Hoang Dao Patterns
6 static lookup groups indexed by day Chi pairs:
- Group 0: Tý/Ngọ → Group 1: Sửu/Mùi → Group 2: Dần/Thân
- Group 3: Mão/Dậu → Group 4: Thìn/Tuất → Group 5: Tỵ/Hợi
Each group returns 6 auspicious hours with Vietnamese time labels.

## Key Constraints

- **RemoteViews only** for Android widget — no custom fonts, limited View types
- **updatePeriodMillis** minimum 15 minutes; daily update sufficient for calendar
- **Lunar converter** verified range: 1900–2100
- **Can Chi**: Pure modular arithmetic, no lookup tables needed
- **Hoang Dao**: 6 static patterns, no astronomical calculation
- **Android**: minSdk 21 (required by `home_widget`), targetSdk 34

## Project Status

| Phase | Description | Status |
|-------|-------------|--------|
| 01 | Project Setup & Architecture | Done |
| 02 | Lunar Calendar Core Logic | Done |
| 03 | Dashboard UI (bottom nav, gallery, settings) | Pending |
| 04 | Widget Editor (customization UI) | Pending |
| 05 | Android Native Widget (Kotlin RemoteViews) | Pending |
| 06 | Polish & Testing (E2E, performance) | Pending |

## Testing Guidelines

- Tests mirror source structure: `test/services/`, `test/utils/`
- Use descriptive `group()` and `test()` names in Vietnamese context
- Verify against known dates (e.g., Tết 2024 = Feb 10, Tết 2025 = Jan 29)
- Test edge cases: leap months, year boundaries, JDN calculations
- Run: `flutter test`
- Analyze: `flutter analyze`

## Plans & Documentation

All implementation plans are in `plans/20260207-1200-widgetin-mvp/`:
- `plan.md` — Master plan with phase tracker
- `phase-0X-*.md` — Individual phase specs
- `research/` — Research documents (Flutter home_widget, lunar algorithms)
- `reports/` — Code review and test verification reports

## Common Commands

```bash
flutter test                    # Run all tests
flutter analyze                 # Static analysis
flutter run                     # Run on connected device
flutter build apk --release     # Build release APK
```
