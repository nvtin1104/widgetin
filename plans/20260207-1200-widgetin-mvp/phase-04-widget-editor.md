# Phase 04 - Widget Editor

## Context

- **Parent:** [plan.md](plan.md)
- **Dependencies:** Phase 01 (theme), Phase 02 (lunar data for preview), Phase 03 (navigation)
- **Research:** [Flutter Home Widget](research/researcher-01-flutter-home-widget.md)

## Overview

- **Date:** 2026-02-07
- **Description:** Build widget customization editor with color pickers, border radius slider, and live preview. Persist config via SharedPreferences for the Android widget to read.
- **Priority:** P0
- **Implementation Status:** Done
- **Review Status:** Passed

## Key Insights

- Config stored in SharedPreferences, read by both Flutter and Android native widget
- `home_widget` package provides `saveWidgetData()` for cross-process storage
- Keys must be string-based; colors stored as hex int strings
- Live preview in-app mimics the actual home screen widget appearance
- `flex_color_picker` provides Material-style color selection

## Requirements

- Color picker for widget background color (default: cream `#FAF8F3`)
- Color picker for text color (default: dark `#2D2D2D`)
- Border radius slider (0-24dp, default 16)
- Live preview updating in real-time as user adjusts settings
- Save button persists config and triggers Android widget update
- WidgetConfigProvider manages state + persistence

## Architecture

```
WidgetConfigProvider extends ChangeNotifier
  - Color backgroundColor
  - Color textColor
  - double borderRadius
  - Future<void> loadConfig()       // Read from SharedPreferences
  - Future<void> saveConfig()       // Write via HomeWidget.saveWidgetData()
  - void updateBg/Text/Radius(...)  // Setters that call notifyListeners()

SharedPreferences Keys:
  "widget_bg_color"      → int (Color.value)
  "widget_text_color"    → int (Color.value)
  "widget_border_radius" → double
```

## Related Code Files

| File | Action | Purpose |
|------|--------|---------|
| `lib/models/widget_config.dart` | Create | WidgetConfig data class |
| `lib/providers/widget_config_provider.dart` | Create | State + persistence |
| `lib/screens/widget_editor_screen.dart` | Create | Editor UI |
| `lib/widgets/widget_live_preview.dart` | Create | Real-time preview |
| `lib/main.dart` | Modify | Register WidgetConfigProvider |
| `lib/screens/dashboard_screen.dart` | Modify | Navigate to editor |

## Implementation Steps

1. **Create `lib/models/widget_config.dart`**:
   ```dart
   class WidgetConfig {
     final Color backgroundColor;
     final Color textColor;
     final double borderRadius;
     const WidgetConfig({
       this.backgroundColor = const Color(0xFFFAF8F3),
       this.textColor = const Color(0xFF2D2D2D),
       this.borderRadius = 16.0,
     });
   }
   ```

2. **Create `lib/providers/widget_config_provider.dart`**:
   - Extends `ChangeNotifier`
   - `loadConfig()`: read 3 keys from `HomeWidget.getWidgetData()` with defaults
   - `saveConfig()`: write 3 keys via `HomeWidget.saveWidgetData()`, then call `HomeWidget.updateWidget(androidName: 'LunarCalendarWidget')`
   - Setter methods: `updateBackgroundColor(Color)`, `updateTextColor(Color)`, `updateBorderRadius(double)` - each calls `notifyListeners()`

3. **Register provider in `lib/main.dart`**:
   ```dart
   ChangeNotifierProvider(create: (_) => WidgetConfigProvider()..loadConfig()),
   ```

4. **Create `lib/screens/widget_editor_screen.dart`**:
   - `Scaffold` with AppBar title "Customize Widget"
   - Top section: `WidgetLivePreview` (takes current config)
   - Middle section: "Background Color" label + color picker tile (tap → dialog with `ColorPicker` from `flex_color_picker`)
   - "Text Color" label + color picker tile
   - "Border Radius" label + `Slider(min:0, max:24, divisions:24)`
   - Bottom: `ElevatedButton` "Save & Apply" → calls `provider.saveConfig()`
   - Show `SnackBar` on save success

5. **Create `lib/widgets/widget_live_preview.dart`**:
   - `Consumer2<WidgetConfigProvider, LunarCalendarProvider>`
   - Renders a `Container` with config's bg color, border radius, and text color
   - Shows solar date, lunar date, Can Chi, Hoàng Đạo hours - same layout as actual Android widget
   - Wrapped in `AspectRatio(aspectRatio: 2/1)` to mimic 4x2 widget proportion

6. **Update dashboard** - wire "Customize" button to `Navigator.pushNamed(context, '/editor')`.

7. **Update `lib/app.dart`** - add route: `'/editor': (_) => const WidgetEditorScreen()`.

## Todo List

- [ ] Create WidgetConfig model
- [ ] Create WidgetConfigProvider with load/save
- [ ] Register provider in main.dart
- [ ] Build WidgetEditorScreen layout
- [ ] Integrate flex_color_picker for color selection
- [ ] Build WidgetLivePreview component
- [ ] Wire save button to persist + trigger widget update
- [ ] Connect dashboard "Customize" button to editor route
- [ ] Test config persistence across app restart

## Success Criteria

- Editor screen renders with color pickers and slider
- Live preview updates instantly when adjusting colors/radius
- Config persists after app restart (re-read from SharedPreferences)
- "Save & Apply" writes data and calls `HomeWidget.updateWidget()`
- No crash on first launch (default config when no saved data)

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Color picker dialog UX poor on small screens | Medium | Use compact picker mode, test on 5" screen |
| SharedPreferences write race condition | Low | Await each save sequentially |
| HomeWidget.updateWidget fails silently | Medium | Wrap in try/catch, show error snackbar |

## Security Considerations

None. Local storage only, no sensitive data.

## Next Steps

Proceed to [Phase 05 - Android Native Widget](phase-05-android-native-widget.md).
