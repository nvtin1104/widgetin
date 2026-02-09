# Phase 02 — Layer 1 Widget Factory

## Context
- **Parent:** [plan.md](plan.md)
- **Depends on:** Phase 01
- **Status:** Pending

## Overview
Build 4 widget view components + a WidgetFactory dispatcher.

## Files to Create

| File | Action | Purpose |
|------|--------|---------|
| `lib/widgets/views/digital_clock_view.dart` | Create | Time + lunar date sub-text |
| `lib/widgets/views/text_based_view.dart` | Create | Minimalist text layout |
| `lib/widgets/views/moon_phase_view.dart` | Create | Moon graphic + time overlay |
| `lib/widgets/views/hybrid_calendar_view.dart` | Create | Grid/list with numbers + text |
| `lib/widgets/widget_factory.dart` | Create | Factory dispatcher |

## Implementation

### WidgetFactory
```dart
class WidgetFactory {
  static Widget create(WidgetType type, LunarDate lunar, Color textColor) {
    switch (type) {
      case WidgetType.digitalClock: return DigitalClockView(...);
      case WidgetType.textBased: return TextBasedView(...);
      case WidgetType.moonPhase: return MoonPhaseView(...);
      case WidgetType.hybridCalendar: return HybridCalendarView(...);
    }
  }
}
```

### View Contract
All views receive: LunarDate, textColor, TypographyStyle, visibility flags.
All views use `mainAxisSize: MainAxisSize.min` for safe hide/show.

## Success Criteria
- Each view renders standalone with mock data
- Factory returns correct view per enum value
