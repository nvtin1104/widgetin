# Phase 01 - Project Setup & Architecture

## Context

- **Parent:** [plan.md](plan.md)
- **Dependencies:** None (first phase)
- **Research:** [Flutter Home Widget](research/researcher-01-flutter-home-widget.md)

## Overview

- **Date:** 2026-02-07
- **Description:** Initialize Flutter project, establish folder structure, configure dependencies, set up Material You theme and Provider state management.
- **Priority:** P0
- **Implementation Status:** Pending
- **Review Status:** Not started

## Key Insights

- Provider chosen over Riverpod for MVP (~20KB vs ~40KB, less boilerplate)
- Material You via `ColorScheme.fromSeed()` + `useMaterial3: true`
- `home_widget` requires minSdkVersion 21+
- Pastel tokens from research: Soft red `#E8998D`, Cream `#FAF8F3`, Sage green `#C4DDC4`

## Requirements

- Working Flutter project that builds on Android (minSdk 21)
- Clean folder structure following feature-based organization
- Theme system with Material You + pastel color tokens
- Provider wired at app root

## Architecture

```
lib/
  main.dart                   # App entry, MultiProvider wrapper
  app.dart                    # MaterialApp config, theme, routes
  models/                     # Data classes (LunarDate, WidgetConfig)
  providers/                  # ChangeNotifier providers
  screens/                    # Full-page screens (Dashboard, Editor, Settings)
  widgets/                    # Reusable UI components
  services/                   # Business logic (LunarCalendarService)
  utils/                      # Helpers (Can Chi, Giờ Hoàng Đạo tables)
  theme/
    app_theme.dart            # ThemeData, ColorScheme, Typography
    color_tokens.dart         # Pastel color constants
```

## Related Code Files

| File | Action | Purpose |
|------|--------|---------|
| `pubspec.yaml` | Create | Dependencies + metadata |
| `lib/main.dart` | Create | Entry point with MultiProvider |
| `lib/app.dart` | Create | MaterialApp, theme, routing |
| `lib/theme/app_theme.dart` | Create | Material You ThemeData |
| `lib/theme/color_tokens.dart` | Create | Pastel color constants |
| `android/app/build.gradle` | Modify | minSdkVersion 21 |

## Implementation Steps

1. **Run `flutter create widgetin --org com.widgetin`** in project root. Move generated files into repo root (or create directly in root if empty).
2. **Edit `pubspec.yaml`** - add dependencies:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     provider: ^6.1.0
     home_widget: ^0.5.0
     lunar_calendar_converter: ^1.1.0
     shared_preferences: ^2.2.0
     flex_color_picker: ^3.3.0
   ```
3. **Set `android/app/build.gradle`** - `minSdkVersion 21`, `compileSdkVersion 34`.
4. **Create folder structure** - all directories listed in Architecture section.
5. **Create `lib/theme/color_tokens.dart`**:
   ```dart
   class ColorTokens {
     static const Color softRed = Color(0xFFE8998D);
     static const Color cream = Color(0xFFFAF8F3);
     static const Color sageGreen = Color(0xFFC4DDC4);
     static const Color darkText = Color(0xFF2D2D2D);
     static const Color mutedText = Color(0xFF8B8B8B);
   }
   ```
6. **Create `lib/theme/app_theme.dart`** - build `ThemeData` with `ColorScheme.fromSeed(seedColor: ColorTokens.sageGreen)` and `useMaterial3: true`.
7. **Create `lib/main.dart`** - wrap app in `MultiProvider` with empty provider list (populated in later phases).
8. **Create `lib/app.dart`** - `MaterialApp` with theme, initial route `/dashboard`.
9. **Run `flutter pub get`** and **`flutter build apk --debug`** to verify compilation.

## Todo List

- [ ] Run flutter create and configure project
- [ ] Set up pubspec.yaml with all MVP dependencies
- [ ] Configure Android build.gradle (minSdk 21)
- [ ] Create folder structure under lib/
- [ ] Implement color_tokens.dart
- [ ] Implement app_theme.dart with Material You
- [ ] Create main.dart with MultiProvider shell
- [ ] Create app.dart with MaterialApp
- [ ] Verify project compiles on Android

## Success Criteria

- `flutter analyze` passes with zero errors
- `flutter build apk --debug` succeeds
- App launches on Android emulator showing blank scaffold
- Theme correctly applies Material You pastel palette

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| `home_widget` version conflict | Low | Pin exact version in pubspec |
| SDK version mismatch | Low | Verify Flutter 3.x + Dart 3.x installed |

## Security Considerations

None for this phase.

## Next Steps

Proceed to [Phase 02 - Lunar Calendar Core Logic](phase-02-lunar-calendar-logic.md).
