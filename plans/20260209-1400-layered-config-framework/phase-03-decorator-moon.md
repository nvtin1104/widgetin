# Phase 03 — Layer 2 Decorator + Moon Phase Engine

## Context
- **Parent:** [plan.md](plan.md)
- **Depends on:** Phase 01
- **Status:** Pending

## Overview
WidgetDecorator wraps any Layer 1 view with background + typography styling.
MoonPainter renders high-fidelity moon phase via CustomPainter.

## Files to Create

| File | Action | Purpose |
|------|--------|---------|
| `lib/widgets/widget_decorator.dart` | Create | Applies bg, font, visibility |
| `lib/widgets/painters/moon_painter.dart` | Create | CustomPainter moon phase |
| `lib/utils/moon_phase_helper.dart` | Create | Moon phase calculation |

## Moon Phase Calculation
```dart
// Synodic month = 29.530588853 days
// Reference new moon: Jan 6, 2000 18:14 UTC (JD 2451550.26)
static double getMoonPhase(DateTime date) {
  final jd = julianDayNumber(date);
  final daysSinceNew = jd - 2451550.26;
  final cycles = daysSinceNew / 29.530588853;
  return cycles - cycles.floor(); // 0.0-1.0
}
// 0.0 = new, 0.25 = first quarter, 0.5 = full, 0.75 = last quarter
```

## MoonPainter
- Draw base circle (moon color)
- Calculate terminator position from phase
- Draw shadow arc using Canvas path
- Wrap in RepaintBoundary + shouldRepaint checks date

## WidgetDecorator
```dart
class WidgetDecorator extends StatelessWidget {
  final Widget child;
  final WidgetConfig config;
  // Applies: background container, font theme, visibility filtering
}
```

### Background Modes
- Solid: single color container
- Gradient: LinearGradient(begin→end, [bgColor, gradientEndColor])
- Transparent: Colors.transparent with no border

### Typography
- Modern: default sans-serif
- Classic: serif fontFamily
- Calligraphy: brush-style fontFamily (bundled or Google Fonts fallback)

## Success Criteria
- MoonPainter renders correct phase for known dates
- Decorator applies bg/font independent of child widget type
- RepaintBoundary prevents unnecessary moon repaints
