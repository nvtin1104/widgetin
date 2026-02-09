# Phase 04 — Editor UI Refactor

## Context
- **Parent:** [plan.md](plan.md)
- **Depends on:** Phase 02, 03
- **Status:** Pending

## Overview
Refactor WidgetEditorScreen to expose Layer 1 type selection + Layer 2 controls.
Update WidgetConfigProvider and sync service.

## Files to Modify

| File | Action | Purpose |
|------|--------|---------|
| `lib/providers/widget_config_provider.dart` | Modify | Handle all new config fields |
| `lib/screens/widget_editor_screen.dart` | Rewrite | Add type selector + style sections |
| `lib/widgets/widget_live_preview.dart` | Rewrite | Use WidgetFactory + Decorator |
| `lib/services/widget_data_sync_service.dart` | Modify | Sync widgetType to native |
| `lib/screens/dashboard_screen.dart` | Modify | Show type name in card subtitle |
| `android/.../LunarCalendarWidget.kt` | Modify | Read widget type for layout |

## Editor Layout
```
┌──────────────────────────────┐
│     [Live Preview]           │ ← WidgetDecorator(WidgetFactory.create())
├──────────────────────────────┤
│  Widget Type (SegmentedButton)│
│  [Clock] [Text] [Moon] [Cal] │
├──────────────────────────────┤
│  Background ────────── [▼]   │
│  Typography ────────── [▼]   │
│  Background Color ── [swatch]│
│  Text Color ──────── [swatch]│
│  Border Radius ───── [slider]│
├──────────────────────────────┤
│  ☑ Show Solar Terms          │
│  ☑ Show Zodiac Hours         │
│  ☑ Show Year Info            │
├──────────────────────────────┤
│  [💾 Save & Apply]           │
└──────────────────────────────┘
```

## Success Criteria
- Live preview updates reactively on any config change
- All Layer 2 settings apply to all Layer 1 types
- Config persists across app restarts
- Native widget receives updated config
