# Gemini System Instructions — Widgetin Project

## Role

You are an AI development assistant working on **Widgetin**, a Flutter mobile app for Vietnamese Lunar Calendar home screen widgets. Follow these instructions precisely when generating code, reviewing, or assisting with this project.

## Project Identity

- **Name**: Widgetin ("Widget I Need")
- **Type**: Flutter mobile app (Android-first, iOS-ready)
- **Purpose**: Create customizable Vietnamese Lunar Calendar widgets for Android home screens
- **Language**: Dart / Flutter 3.x (SDK >=3.0.0 <4.0.0)
- **Target**: Android minSdk 21, targetSdk 34

## System Architecture

```
lib/
├── main.dart              → Entry point: MultiProvider → WidgetinApp
├── app.dart               → MaterialApp with Material You theme
├── models/                → Immutable data classes (const, final, copyWith)
├── services/              → Stateless business logic facades
├── providers/             → Provider ChangeNotifiers (state management)
├── screens/               → Full-page screen widgets
├── widgets/               → Reusable UI components
├── theme/
│   ├── app_theme.dart     → ThemeData (Material You, rounded corners)
│   └── color_tokens.dart  → Color constants (pastel palette)
└── utils/                 → Static utility classes (private constructors)
```

### Layer Responsibilities

| Layer | Responsibility | Pattern |
|-------|---------------|---------|
| `models/` | Data representation | Immutable, `const` constructor, `copyWith()`, computed getters |
| `services/` | Business logic | Stateless facades, combines utils + libraries |
| `providers/` | State management | `ChangeNotifier`, notify listeners on state change |
| `screens/` | Page-level UI | Full screens with scaffold, consume providers |
| `widgets/` | Reusable UI | Small, composable, accept data via constructor |
| `utils/` | Pure functions | Static methods, private `_()` constructor, no state |
| `theme/` | Visual design | Static tokens, `ThemeData` factory methods |

## Dependencies

```yaml
dependencies:
  provider: ^6.1.0                    # State management
  home_widget: ^0.5.0                 # Android home screen widget bridge
  lunar_calendar_converter: ^1.1.0    # Solar ↔ Lunar conversion
  shared_preferences: ^2.2.0         # Key-value local storage
  flex_color_picker: ^3.3.0          # Color picker for widget customization
```

## Coding Rules

### MUST Follow
1. **Immutable models**: All model classes use `const` constructors and `final` fields
2. **Null safety**: Full Dart null safety. Only use `!` when guaranteed non-null
3. **No print()**: Use proper logging or debugPrint. Linter enforces this
4. **Prefer const**: Use `const` for widgets, constructors, and values wherever possible
5. **Relative imports** within `lib/`, package imports for external dependencies
6. **File naming**: `snake_case.dart` for all files
7. **Class naming**: `PascalCase` for classes, `camelCase` for methods/variables
8. **Test naming**: `<source>_test.dart` in mirrored `test/` structure

### MUST NOT Do
1. Do NOT add unnecessary comments — code should be self-documenting
2. Do NOT create new files unless absolutely required
3. Do NOT change theme colors without explicit request — palette is intentional
4. Do NOT use `setState` in screens — use Provider for state management
5. Do NOT add dependencies without justification
6. Do NOT use deprecated Flutter APIs — use Material 3 equivalents

## Design System

### Color Tokens
```dart
softRed:   Color(0xFFE8998D)  // Accent, highlights
cream:     Color(0xFFFAF8F3)  // Scaffold background
sageGreen: Color(0xFFC4DDC4)  // Primary seed color
darkText:  Color(0xFF2D2D2D)  // Primary text
mutedText: Color(0xFF8B8B8B)  // Secondary text
```

### Theme Rules
- Material You (`useMaterial3: true`)
- `ColorScheme.fromSeed(seedColor: sageGreen)`
- Cards: `borderRadius: 16`, elevation 1
- Buttons: `borderRadius: 12`
- AppBar: centered title, no elevation, surface background

## Domain: Vietnamese Lunar Calendar (Âm Lịch)

### Key Vietnamese Terms
| Vietnamese | English | Code Reference |
|-----------|---------|----------------|
| Âm Lịch | Lunar Calendar | LunarDate model |
| Thiên Can | 10 Heavenly Stems | CanChiHelper.thienCan |
| Địa Chi | 12 Earthly Branches | CanChiHelper.diaChi |
| Can Chi | Sexagenary Cycle | year/month/day Can Chi strings |
| Giờ Hoàng Đạo | Auspicious Hours | HoangDaoHelper |
| Nhuận | Leap (month) | LunarDate.isLeapMonth |

### Calculation Formulas (Already Implemented)
- Year Can: `(lunarYear + 6) % 10`
- Year Chi: `(lunarYear + 8) % 12`
- Month Can: `(yearCanIndex * 2 + lunarMonth + 1) % 10`
- Month Chi: `(lunarMonth + 1) % 12`
- Day Can/Chi: via Julian Day Number (JDN)
- Hoang Dao: 6 static groups by day Chi index pairs

### Important Dates for Verification
- Tết 2024: Solar Feb 10, 2024 → Lunar 01/01 Giáp Thìn
- Tết 2025: Solar Jan 29, 2025 → Lunar 01/01 Ất Tỵ

## Android Widget Constraints

- **RemoteViews only**: Limited View types (TextView, ImageView, LinearLayout)
- **No custom fonts** in RemoteViews
- **Update frequency**: `updatePeriodMillis` min 15 min, daily refresh is enough
- **Communication**: Flutter ↔ Android via `home_widget` package (SharedPreferences bridge)
- **Native code**: Kotlin `AppWidgetProvider` + XML layout

## Project Phases

| # | Phase | Status | Key Files |
|---|-------|--------|-----------|
| 01 | Setup & Architecture | Done | main.dart, app.dart, theme/ |
| 02 | Lunar Calendar Logic | Done | models/, services/, utils/ |
| 03 | Dashboard UI | Pending | screens/, widgets/, providers/ |
| 04 | Widget Editor | Pending | screens/editor, flex_color_picker |
| 05 | Android Native Widget | Pending | android/app/src/main/kotlin/ |
| 06 | Polish & Testing | Pending | test/, E2E |

## Testing Standards

- Mirror source structure: `test/services/`, `test/utils/`
- Use `group()` to organize related tests
- Test with known Vietnamese calendar dates
- Cover: normal cases, edge cases (leap months, year boundaries), known date verification
- Commands: `flutter test`, `flutter analyze`

## File References

- Master plan: `plans/20260207-1200-widgetin-mvp/plan.md`
- Phase specs: `plans/20260207-1200-widgetin-mvp/phase-0X-*.md`
- Research: `plans/20260207-1200-widgetin-mvp/research/`

## Response Guidelines

When assisting with this project:
1. Read existing code before modifying — understand patterns first
2. Follow the established architecture strictly
3. Keep Vietnamese terminology accurate (diacritics matter)
4. Prefer editing existing files over creating new ones
5. Write tests for any new logic
6. Keep solutions minimal — no over-engineering
