# Agent Guidelines — Widgetin Project

Universal knowledge base for any AI agent working on this project. This document defines system structure, development direction, workflow rules, and quality standards.

---

## 1. Project Definition

| Field | Value |
|-------|-------|
| **Name** | Widgetin ("Widget I Need") |
| **Type** | Flutter mobile application |
| **Platform** | Android-first (minSdk 21), iOS-ready architecture |
| **Purpose** | Vietnamese Lunar Calendar home screen widgets with customizable appearance |
| **Language** | Dart 3.x (null-safe) |
| **Framework** | Flutter 3.10+ |
| **Package** | `com.widgetin.widgetin` |

## 2. System Structure

### 2.1 Source Code Architecture

```
lib/
├── main.dart              # App bootstrap: MultiProvider → WidgetinApp
├── app.dart               # MaterialApp configuration
│
├── models/                # Data layer — immutable data classes
│   └── lunar_date.dart    #   LunarDate: core calendar model
│
├── services/              # Business logic — stateless facades
│   └── lunar_calendar_service.dart
│
├── providers/             # State layer — ChangeNotifier classes
│   └── (pending)          #   Will contain widget config, date state
│
├── screens/               # UI layer — full-page screens
│   └── (pending)          #   Dashboard, Editor, Settings
│
├── widgets/               # UI layer — reusable components
│   └── (pending)          #   Calendar cards, widget previews
│
├── theme/                 # Design system
│   ├── app_theme.dart     #   ThemeData factory (Material You)
│   └── color_tokens.dart  #   Color constants (pastel palette)
│
└── utils/                 # Pure utilities — static, stateless
    ├── can_chi_helper.dart    # Sexagenary cycle calculations
    └── hoang_dao_helper.dart  # Auspicious hours lookup
```

### 2.2 Test Structure

```
test/
├── widget_test.dart                    # Widget integration tests
├── services/
│   └── lunar_calendar_service_test.dart
└── utils/
    ├── can_chi_helper_test.dart
    └── hoang_dao_helper_test.dart
```

### 2.3 Android Native Structure

```
android/app/src/main/
├── AndroidManifest.xml
├── kotlin/com/widgetin/widgetin/
│   └── MainActivity.kt           # Flutter activity
└── res/
    ├── drawable/                  # Launch backgrounds
    └── values/                    # Styles, strings
```

### 2.4 Planning & Documentation

```
plans/20260207-1200-widgetin-mvp/
├── plan.md                        # Master implementation plan
├── phase-01-project-setup.md      # Phase specs (01-06)
├── phase-02-lunar-calendar-logic.md
├── phase-03-dashboard-ui.md
├── phase-04-widget-editor.md
├── phase-05-android-native-widget.md
├── phase-06-polish-testing.md
├── research/                      # Technical research documents
├── reports/                       # Code review & test reports
└── scout/                         # Codebase investigation docs
```

## 3. System Direction & Development Guidelines

### 3.1 Core Principles

1. **Simplicity first**: Minimal code to achieve the goal. No over-engineering.
2. **Immutability**: Models are immutable. State changes via Provider only.
3. **Separation of concerns**: Models hold data, services hold logic, providers hold state, screens hold UI.
4. **Vietnamese accuracy**: All Âm Lịch terms must use correct Vietnamese diacritics.
5. **Material You**: Follow Google's Material 3 design language with our pastel palette.
6. **Test coverage**: All business logic must have unit tests.

### 3.2 Development Workflow

```
1. Read & understand existing code
2. Check the phase plan for requirements
3. Follow established patterns (models, services, providers, screens)
4. Write implementation
5. Write/update tests
6. Run `flutter analyze` — zero warnings
7. Run `flutter test` — all pass
8. Commit with conventional commits (feat:, fix:, test:, refactor:)
```

### 3.3 Dependency Rules

**Current dependencies** (do not add without justification):

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.0 | State management |
| `home_widget` | ^0.5.0 | Flutter ↔ Android widget bridge |
| `lunar_calendar_converter` | ^1.1.0 | Solar-to-lunar date conversion |
| `shared_preferences` | ^2.2.0 | Local key-value storage |
| `flex_color_picker` | ^3.3.0 | Color picker UI component |

### 3.4 Git Convention

```
feat: <description>     # New feature
fix: <description>      # Bug fix
test: <description>     # Test changes
refactor: <description> # Code restructuring
docs: <description>     # Documentation
chore: <description>    # Build, config, tooling
```

## 4. Design System

### 4.1 Color Palette

```
Soft Red:   #E8998D (0xFFE8998D)  → Accent, highlights, interactive elements
Cream:      #FAF8F3 (0xFFFAF8F3)  → Scaffold background, light surfaces
Sage Green: #C4DDC4 (0xFFC4DDC4)  → Primary seed color, brand identity
Dark Text:  #2D2D2D (0xFF2D2D2D)  → Primary text, headings
Muted Text: #8B8B8B (0xFF8B8B8B)  → Secondary text, captions, disabled
```

### 4.2 Theme Configuration

- `useMaterial3: true`
- Seed color: Sage Green → `ColorScheme.fromSeed()`
- Card radius: 16dp
- Button radius: 12dp
- AppBar: centered, no elevation, surface color
- Scaffold: cream background

### 4.3 Typography

- Use Flutter default Material 3 typography
- Vietnamese text must render diacritics correctly
- No custom fonts in Android widget (RemoteViews limitation)

## 5. Domain Knowledge

### 5.1 Vietnamese Lunar Calendar System

The Vietnamese lunar calendar (Âm Lịch) uses a **sexagenary cycle** combining:
- **Thiên Can (Heavenly Stems)** — 10 elements: Giáp, Ất, Bính, Đinh, Mậu, Kỷ, Canh, Tân, Nhâm, Quý
- **Địa Chi (Earthly Branches)** — 12 elements: Tý, Sửu, Dần, Mão, Thìn, Tỵ, Ngọ, Mùi, Thân, Dậu, Tuất, Hợi

Combined: `Can + Chi` creates a 60-year cycle (e.g., "Giáp Tý", "Ất Sửu").

### 5.2 Giờ Hoàng Đạo (Auspicious Hours)

Each day has 6 auspicious hours determined by the day's Địa Chi:
- 6 pattern groups: {Tý,Ngọ}, {Sửu,Mùi}, {Dần,Thân}, {Mão,Dậu}, {Thìn,Tuất}, {Tỵ,Hợi}
- Each group maps to a fixed set of 6 auspicious hours with Vietnamese time labels

### 5.3 Key Verification Dates

| Event | Solar Date | Lunar Date | Can Chi Year |
|-------|-----------|------------|-------------|
| Tết 2024 | Feb 10, 2024 | 01/01 | Giáp Thìn |
| Tết 2025 | Jan 29, 2025 | 01/01 | Ất Tỵ |

## 6. Technical Constraints

| Constraint | Detail |
|-----------|--------|
| Android widget rendering | RemoteViews only — limited to basic Views (TextView, ImageView, LinearLayout) |
| Widget update frequency | `updatePeriodMillis` min 15min; calendar updates daily |
| Lunar converter range | Verified 1900–2100 |
| Can Chi calculation | Pure modular arithmetic on integers |
| Hoàng Đạo hours | Static lookup table — 6 groups, no computation |
| Android SDK | minSdk 21 (home_widget requirement), targetSdk 34 |
| Kotlin | Required for AppWidgetProvider in android/app |

## 7. Quality Standards

### 7.1 Code Quality
- Zero `flutter analyze` warnings
- All `flutter test` tests passing
- No `print()` statements (use `debugPrint` in dev)
- Prefer `const` everywhere possible
- Full null safety — no `dynamic` types

### 7.2 Test Requirements
- Unit tests for all utilities and services
- Widget tests for screen components
- Test against known Vietnamese calendar dates
- Edge cases: leap months, year boundaries, JDN calculations
- Test file mirrors source file path

### 7.3 Documentation
- Phase plans in `plans/` directory
- Code should be self-documenting — minimal comments
- Complex algorithms get doc comments (`///`)
- Research documents for non-obvious domain decisions

## 8. Implementation Phases

| # | Phase | Status | Focus Areas |
|---|-------|--------|-------------|
| 01 | Project Setup | **Done** | Flutter project, theme, dependencies, Android config |
| 02 | Lunar Logic | **Done** | LunarDate model, services, Can Chi, Hoàng Đạo, tests |
| 03 | Dashboard UI | Pending | Bottom navigation, widget gallery, settings screen |
| 04 | Widget Editor | Pending | Widget customization UI, color picker, preview |
| 05 | Native Widget | Pending | Kotlin AppWidgetProvider, RemoteViews XML, data bridge |
| 06 | Polish & QA | Pending | E2E tests, performance optimization, bug fixes |

### Current Priority: Phase 03 — Dashboard UI

## 9. Agent Interaction Rules

1. **Always read before write**: Understand existing code before modifying
2. **Follow established patterns**: Match the style of existing code exactly
3. **Edit over create**: Prefer modifying existing files over creating new ones
4. **Minimal changes**: Only change what is necessary for the task
5. **Verify changes**: Run tests and analysis after modifications
6. **Respect the plan**: Check phase documents before implementing features
7. **Vietnamese accuracy**: Double-check diacritics on all Vietnamese terms
8. **No scope creep**: Stay within the requested task boundaries
9. **Conventional commits**: Use semantic commit messages
10. **Ask when unclear**: If requirements are ambiguous, ask before implementing
