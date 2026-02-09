# Phase 01 — Configuration Model

## Context
- **Parent:** [plan.md](plan.md)
- **Status:** Pending

## Overview
Create the data model separating Layer 1 (WidgetType enum) from Layer 2 (StyleOptions). Refactor existing WidgetConfig to hold both layers.

## Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `lib/models/widget_type.dart` | Create | WidgetType enum + BackgroundType, TypographyStyle enums |
| `lib/models/widget_config.dart` | Rewrite | Add widgetType, backgroundType, typographyStyle, visibility toggles |

## Implementation

### 1. widget_type.dart
```dart
enum WidgetType { digitalClock, textBased, moonPhase, hybridCalendar }
enum BackgroundType { solid, gradient, transparent }
enum TypographyStyle { modern, classic, calligraphy }
```

### 2. Expanded WidgetConfig
Add to existing model:
- `WidgetType widgetType` (default: digitalClock)
- `BackgroundType backgroundType` (default: solid)
- `TypographyStyle typographyStyle` (default: modern)
- `bool showSolarTerms` (default: true)
- `bool showZodiacHours` (default: true)
- `bool showYearInfo` (default: true)
- `Color? gradientEndColor` (for gradient bg)
- Keep existing: backgroundColor, textColor, borderRadius

## Success Criteria
- Model compiles, copyWith works for all new fields
- Existing tests still pass (backward compatible defaults)
