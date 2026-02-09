# Agent Guidelines — Widgetin Project

Universal knowledge base for any AI agent working on this project.

---

## 1. Project Definition

| Field | Value |
|-------|-------|
| **Name** | Widgetin ("Widget I Need") |
| **Type** | Flutter mobile application (monorepo) |
| **Platform** | Android-first (minSdk 21), iOS-ready |
| **Purpose** | Vietnamese Lunar Calendar home screen widgets |
| **Language** | Dart 3.10+ / Flutter 3.38+ |
| **Package** | `com.widgetin.widgetin` |

## 2. Monorepo Structure

```
widgetin/                          # Repository root
├── CLAUDE.md                      # Claude agent knowledge base
├── agent.md                       # Universal agent guidelines (this file)
├── gemini.md                      # Gemini agent knowledge base
├── LICENSE / .gitignore
│
├── app/                           # Flutter application
│   ├── pubspec.yaml               # Dependencies (provider, home_widget, etc.)
│   ├── analysis_options.yaml      # Dart linting
│   ├── lib/
│   │   ├── main.dart              # MultiProvider → WidgetinApp
│   │   ├── app.dart               # MaterialApp → HomeShell
│   │   ├── models/
│   │   │   └── lunar_date.dart    # Immutable LunarDate
│   │   ├── services/
│   │   │   └── lunar_calendar_service.dart
│   │   ├── providers/
│   │   │   └── lunar_calendar_provider.dart
│   │   ├── screens/
│   │   │   ├── home_shell.dart        # NavigationBar + IndexedStack
│   │   │   ├── dashboard_screen.dart  # Widget gallery
│   │   │   └── settings_screen.dart   # Theme, About, Licenses
│   │   ├── widgets/
│   │   │   ├── widget_preview_card.dart
│   │   │   └── lunar_calendar_preview.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart     # Material You ThemeData
│   │   │   └── color_tokens.dart  # Pastel palette
│   │   └── utils/
│   │       ├── can_chi_helper.dart
│   │       └── hoang_dao_helper.dart
│   ├── test/                      # 68 tests total
│   │   ├── widget_test.dart
│   │   ├── providers/             # 6 tests
│   │   ├── screens/               # 16 tests
│   │   ├── services/              # 8 tests
│   │   └── utils/                 # 25 tests
│   └── android/                   # Native Android (Kotlin)
│
├── website/                       # Future — landing page
│
└── plans/20260207-1200-widgetin-mvp/
    ├── plan.md                    # Master plan
    ├── phase-0X-*.md              # Phase specs (01-06)
    ├── research/                  # Research docs
    └── reports/                   # Review & test reports
```

## 3. Development Guidelines

### Core Principles
1. **YAGNI/KISS/DRY** — Minimal code, no over-engineering
2. **Immutability** — Models are immutable; state changes via Provider only
3. **Separation of concerns** — models/services/providers/screens
4. **Vietnamese accuracy** — Correct diacritics on all Âm Lịch terms
5. **Material You** — Material 3 design with pastel palette
6. **Test coverage** — All business logic must have unit tests

### Dependencies (do not add without justification)
- `provider` ^6.1.0 — State management
- `home_widget` ^0.5.0 — Flutter ↔ Android widget bridge
- `lunar_calendar_converter_new` ^2.0.0 — Solar-to-lunar conversion
- `shared_preferences` ^2.2.0 — Local storage
- `flex_color_picker` ^3.3.0 — Color picker UI

### Git Convention
```
feat: <description>     # New feature
fix: <description>      # Bug fix
test: <description>     # Test changes
refactor: <description> # Code restructuring
docs: <description>     # Documentation
```

## 4. Design System

### Color Tokens
```
Soft Red:   #E8998D → Accent, highlights
Cream:      #FAF8F3 → Scaffold background
Sage Green: #C4DDC4 → Primary seed color
Dark Text:  #2D2D2D → Primary text
Muted Text: #8B8B8B → Secondary text
```

### Theme: Material You (`useMaterial3: true`)
- `ColorScheme.fromSeed(seedColor: sageGreen)`
- Card radius: 16dp, Button radius: 12dp
- AppBar: centered, no elevation

## 5. Domain: Vietnamese Lunar Calendar

- **Thiên Can (10)**: Giáp, Ất, Bính, Đinh, Mậu, Kỷ, Canh, Tân, Nhâm, Quý
- **Địa Chi (12)**: Tý, Sửu, Dần, Mão, Thìn, Tỵ, Ngọ, Mùi, Thân, Dậu, Tuất, Hợi
- **Giờ Hoàng Đạo**: 6 auspicious hours/day, 6 pattern groups
- **Verification**: Tết 2024 = Feb 10 (Giáp Thìn), Tết 2025 = Jan 29 (Ất Tỵ)

## 6. Project Phases

| # | Phase | Status |
|---|-------|--------|
| 01 | Project Setup & Architecture | **Done** |
| 02 | Lunar Calendar Core Logic | **Done** |
| 03 | Dashboard UI | **Done** |
| 04 | Widget Editor | Pending |
| 05 | Android Native Widget | Pending |
| 06 | Polish & Testing | Pending |

## 7. Agent Rules

1. **Working directory**: All Flutter commands run from `app/`
2. **Read before write** — Understand existing code first
3. **Follow patterns** — Match existing code style exactly
4. **Edit over create** — Prefer modifying existing files
5. **Verify changes** — Run `flutter analyze` + `flutter test`
6. **Vietnamese accuracy** — Double-check diacritics
7. **No scope creep** — Stay within task boundaries
8. **Flutter path**: `C:\code\flutter\bin\flutter.bat`
