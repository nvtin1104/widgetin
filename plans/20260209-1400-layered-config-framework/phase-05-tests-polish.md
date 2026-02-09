# Phase 05 — Tests & Polish

## Context
- **Parent:** [plan.md](plan.md)
- **Depends on:** Phase 04
- **Status:** Pending

## Test Files

| File | Tests |
|------|-------|
| `test/models/widget_config_test.dart` | Config defaults, copyWith, serialization |
| `test/widgets/widget_factory_test.dart` | Factory returns correct view per type |
| `test/utils/moon_phase_helper_test.dart` | Known dates: new/full/quarter moons |
| `test/screens/widget_editor_screen_test.dart` | Update existing for new controls |

## Key Test Cases
- Moon phase: 2024-01-11 = New Moon (~0.0), 2024-01-25 = Full Moon (~0.5)
- Factory: each enum → correct widget runtimeType
- Config: all fields persist via SharedPreferences round-trip
- Visibility toggles: hiding elements doesn't break layout
- All existing 68 tests still pass

## Success Criteria
- All new + existing tests pass
- flutter analyze clean
- Code review passes
