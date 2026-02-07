# Phase 03 - Dashboard UI

## Context

- **Parent:** [plan.md](plan.md)
- **Dependencies:** Phase 01 (theme), Phase 02 (LunarCalendarService for preview data)
- **Research:** [Flutter Home Widget](research/researcher-01-flutter-home-widget.md)

## Overview

- **Date:** 2026-02-07
- **Description:** Build the main app shell with dashboard screen showing available widgets as preview cards, plus a basic settings screen.
- **Priority:** P0
- **Implementation Status:** Pending
- **Review Status:** Not started

## Key Insights

- MVP has only one widget (Lunar Calendar) but architecture supports adding more
- Widget gallery uses Card-based layout; each card shows a live preview
- Navigation: bottom tab bar (Dashboard / Settings) - simple, no deep nesting
- LunarCalendarService provides today's data for preview card

## Requirements

- MaterialApp shell with bottom navigation (2 tabs: Dashboard, Settings)
- Dashboard screen displays widget gallery as scrollable card list
- Each widget card shows: name, description, mini preview, "Customize" button
- Lunar Calendar card renders today's date info as preview
- Settings screen with placeholder items (theme toggle, about section)
- Wire LunarCalendarProvider into the widget tree

## Architecture

```
Navigation:
  BottomNavigationBar (2 tabs)
    ├── DashboardScreen (index 0)
    │     └── WidgetGalleryList
    │           └── WidgetPreviewCard (Lunar Calendar)
    └── SettingsScreen (index 1)

State:
  LunarCalendarProvider extends ChangeNotifier
    - LunarDate _todayLunar
    - Future<void> loadToday()
```

## Related Code Files

| File | Action | Purpose |
|------|--------|---------|
| `lib/app.dart` | Modify | Add routing, bottom nav |
| `lib/providers/lunar_calendar_provider.dart` | Create | Wraps LunarCalendarService |
| `lib/screens/home_shell.dart` | Create | Scaffold + BottomNavigationBar |
| `lib/screens/dashboard_screen.dart` | Create | Widget gallery list |
| `lib/screens/settings_screen.dart` | Create | Basic settings UI |
| `lib/widgets/widget_preview_card.dart` | Create | Reusable preview card |
| `lib/widgets/lunar_calendar_preview.dart` | Create | Lunar date mini preview |
| `lib/main.dart` | Modify | Register LunarCalendarProvider |

## Implementation Steps

1. **Create `lib/providers/lunar_calendar_provider.dart`**:
   ```dart
   class LunarCalendarProvider extends ChangeNotifier {
     final LunarCalendarService _service = LunarCalendarService();
     LunarDate? _todayLunar;
     LunarDate? get todayLunar => _todayLunar;

     Future<void> loadToday() async {
       _todayLunar = _service.getToday();
       notifyListeners();
     }
   }
   ```

2. **Update `lib/main.dart`** - register provider:
   ```dart
   MultiProvider(
     providers: [
       ChangeNotifierProvider(create: (_) => LunarCalendarProvider()..loadToday()),
     ],
     child: const WidgetinApp(),
   )
   ```

3. **Create `lib/screens/home_shell.dart`** - Scaffold with BottomNavigationBar, `IndexedStack` for tab persistence, 2 tabs: Dashboard (icon: `Icons.dashboard_rounded`), Settings (icon: `Icons.settings_rounded`).

4. **Create `lib/screens/dashboard_screen.dart`** - `ListView` with a header text "Your Widgets" and one `WidgetPreviewCard` for Lunar Calendar. Use `Consumer<LunarCalendarProvider>` to read today's lunar data.

5. **Create `lib/widgets/widget_preview_card.dart`** - Material `Card` with: widget icon, title, subtitle, preview area (child widget slot), and "Customize" `ElevatedButton` that navigates to editor screen (Phase 04 route, placeholder for now).

6. **Create `lib/widgets/lunar_calendar_preview.dart`** - Compact preview showing: solar date, lunar date (day/month), Can Chi year, top 3 Hoàng Đạo hours. Uses `ColorTokens` for styling.

7. **Create `lib/screens/settings_screen.dart`** - `ListView` with `ListTile` items: "Theme" (placeholder toggle), "About Widgetin" (show version dialog), "Licenses" (showLicensePage).

8. **Update `lib/app.dart`** - set `home: HomeShell()`, define named route `/editor` as placeholder.

## Todo List

- [ ] Create LunarCalendarProvider
- [ ] Register provider in main.dart
- [ ] Build HomeShell with bottom navigation
- [ ] Build DashboardScreen with widget gallery
- [ ] Build WidgetPreviewCard component
- [ ] Build LunarCalendarPreview component
- [ ] Build SettingsScreen with placeholder items
- [ ] Wire navigation and routes

## Success Criteria

- App shows bottom nav with Dashboard and Settings tabs
- Dashboard displays Lunar Calendar card with today's correct lunar info
- Tapping "Customize" navigates (even if to placeholder)
- Settings screen renders with list items
- Smooth tab switching with no flicker (IndexedStack)

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Provider not loading before build | Low | Use `..loadToday()` in create + null-safe UI |
| Preview card layout overflow | Low | Constrain card height, use `Flexible` |

## Security Considerations

None for this phase.

## Next Steps

Proceed to [Phase 04 - Widget Editor](phase-04-widget-editor.md).
