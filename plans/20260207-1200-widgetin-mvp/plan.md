# Widgetin MVP - Implementation Plan

**Widgetin** ("Widget I Need") is a Flutter mobile app for managing home screen widgets.
MVP delivers a Vietnamese Lunar Calendar widget with customizable appearance.
Android-first with iOS-ready architecture.

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.x + Dart |
| State | Provider |
| Widget Bridge | `home_widget` ^0.5.x |
| Lunar Logic | `lunar_calendar_converter` + custom Can Chi |
| Storage | SharedPreferences |
| Native | Kotlin AppWidgetProvider + XML RemoteViews |
| Design | Material You / useMaterial3, pastel tokens |

## Phases

| # | Phase | Status | Progress | File |
|---|-------|--------|----------|------|
| 01 | Project Setup & Architecture | Done | 100% | [phase-01](phase-01-project-setup.md) |
| 02 | Lunar Calendar Core Logic | Done | 100% | [phase-02](phase-02-lunar-calendar-logic.md) |
| 03 | Dashboard UI | Done | 100% | [phase-03](phase-03-dashboard-ui.md) |
| 04 | Widget Editor | Done | 100% | [phase-04](phase-04-widget-editor.md) |
| 05 | Android Native Widget | Pending | 0% | [phase-05](phase-05-android-native-widget.md) |
| 06 | Polish & Testing | Pending | 0% | [phase-06](phase-06-polish-testing.md) |

## Research

- [Flutter Home Widget Integration](research/researcher-01-flutter-home-widget.md)
- [Vietnamese Lunar Calendar](research/researcher-02-lunar-calendar.md)

## Key Constraints

- RemoteViews only for Android widget (no custom fonts, limited Views)
- `updatePeriodMillis` minimum 15min; daily update sufficient for calendar
- Lunar converter verified 1900-2100; Can Chi via simple modular arithmetic
- Giờ Hoàng Đạo: 6 static lookup patterns, no astronomical calculation needed

---

**Phase 01 completed: 2026-02-08**
**Phase 02 completed: 2026-02-08**
**Phase 03 completed: 2026-02-08**
**Phase 04 completed: 2026-02-09**
