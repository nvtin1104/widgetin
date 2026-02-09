# Layered Configuration Framework — Implementation Plan

Refactor Widgetin's single widget type into a multi-type factory with layered configuration.

## Architecture

```
Layer 1 (WidgetType)          Layer 2 (StyleOptions)
┌─────────────────┐           ┌─────────────────────┐
│ DigitalClock    │           │ BackgroundType       │
│ TextBased       │──Factory──│ TypographyStyle      │
│ MoonPhase       │   +      │ Visibility Toggles   │
│ HybridCalendar  │ Decorator│ (tiết khí, giờ, năm) │
└─────────────────┘           └─────────────────────┘
         │                              │
         └──────────┬───────────────────┘
                    ▼
            WidgetDecorator (applies L2 to L1 output)
                    ▼
            Native Android Widget (RemoteViews)
```

## Phases

| # | Phase | Status | Progress | File |
|---|-------|--------|----------|------|
| 01 | Configuration Model | Done | 100% | [phase-01](phase-01-config-model.md) |
| 02 | Layer 1 Widget Factory | Done | 100% | [phase-02](phase-02-widget-factory.md) |
| 03 | Layer 2 Decorator + Moon Engine | Done | 100% | [phase-03](phase-03-decorator-moon.md) |
| 04 | Editor UI Refactor | Done | 100% | [phase-04](phase-04-editor-refactor.md) |
| 05 | Tests & Polish | Done | 100% | [phase-05](phase-05-tests-polish.md) |

## Key Constraints

- Layer 2 must apply universally to all Layer 1 types
- RepaintBoundary on MoonPainter for performance
- mainAxisSize: MainAxisSize.min for hide/show toggles
- Keep existing Provider pattern (no Riverpod migration)
- Android RemoteViews can only show simplified version
