# Phase 02 - Lunar Calendar Core Logic

## Context

- **Parent:** [plan.md](plan.md)
- **Dependencies:** Phase 01 (project compiles)
- **Research:** [Lunar Calendar](research/researcher-02-lunar-calendar.md)

## Overview

- **Date:** 2026-02-07
- **Description:** Build core lunar calendar logic: solar-to-lunar conversion, Can Chi calculation, Giờ Hoàng Đạo lookup, wrapped in a clean service layer.
- **Priority:** P0
- **Implementation Status:** Completed (2026-02-08)
- **Review Status:** Completed (2026-02-08) - PASS, 0 critical issues

## Key Insights

- `lunar_calendar_converter` uses Hồ Ngọc Đức algorithm, verified 1900-2100
- Can Chi: pure modular arithmetic, no external package needed
- Year Can = `(year + 6) % 10`, Year Chi = `(year + 8) % 12`
- Giờ Hoàng Đạo: 6 day-type patterns, static lookup table (compact, no astronomy)
- Package is timezone-naive; use local date only

## Requirements

- Convert any solar date to lunar date with leap month awareness
- Compute Can Chi for year, month, and day
- Look up Giờ Hoàng Đạo for any given lunar day
- Single `LunarCalendarService` facade for all calendar queries
- `LunarDate` model class encapsulating all display data

## Architecture

```
Service Layer Pattern:
  LunarCalendarService (facade)
    ├── lunar_calendar_converter (3rd party - solar↔lunar)
    ├── CanChiHelper (custom - Can Chi computation)
    └── HoangDaoHelper (custom - auspicious hours lookup)

Model:
  LunarDate {solarDate, lunarDay, lunarMonth, lunarYear, isLeapMonth,
             canChiYear, canChiMonth, canChiDay, hoangDaoHours}
```

## Related Code Files

| File | Action | Purpose |
|------|--------|---------|
| `lib/models/lunar_date.dart` | Create | LunarDate data class |
| `lib/utils/can_chi_helper.dart` | Create | Can Chi modular arithmetic |
| `lib/utils/hoang_dao_helper.dart` | Create | Giờ Hoàng Đạo lookup table |
| `lib/services/lunar_calendar_service.dart` | Create | Facade combining all logic |

## Implementation Steps

1. **Create `lib/models/lunar_date.dart`**:
   ```dart
   class LunarDate {
     final DateTime solarDate;
     final int lunarDay;
     final int lunarMonth;
     final int lunarYear;
     final bool isLeapMonth;
     final String canChiYear;   // e.g. "Bính Ngọ"
     final String canChiMonth;
     final String canChiDay;
     final List<String> hoangDaoHours; // e.g. ["Tý (23-01)", ...]
     // constructor, copyWith, toString
   }
   ```

2. **Create `lib/utils/can_chi_helper.dart`**:
   - Define `thienCan` list: `['Giáp','Ất','Bính','Đinh','Mậu','Kỷ','Canh','Tân','Nhâm','Quý']`
   - Define `diaChi` list: `['Tý','Sửu','Dần','Mão','Thìn','Tỵ','Ngọ','Mùi','Thân','Dậu','Tuất','Hợi']`
   - `String getCanChiYear(int lunarYear)` - `can[(year+6)%10] + ' ' + chi[(year+8)%12]`
   - `String getCanChiMonth(int lunarMonth, int lunarYear)` - month Can depends on year's Can stem; Chi fixed from Dần for month 1
   - `String getCanChiDay(int jdn)` - Julian Day Number mod 10/12 with epoch offset
   - Helper: `int julianDayNumber(DateTime date)` for day Can Chi input

3. **Create `lib/utils/hoang_dao_helper.dart`**:
   - Map day Chi index to pattern group: `{0,6}→0, {1,7}→1, {2,8}→2, {3,9}→3, {4,10}→4, {5,11}→5`
   - 6 pattern arrays per research data:
     ```dart
     static const patterns = [
       [0,1,3,6,7,9],   // Tý/Ngọ → Tý,Sửu,Mão,Ngọ,Mùi,Dậu
       [2,3,5,8,9,11],  // Sửu/Mùi → Dần,Mão,Tỵ,Thân,Dậu,Hợi
       [0,1,4,5,7,10],  // Dần/Thân → Tý,Sửu,Thìn,Tỵ,Mùi,Tuất
       [0,2,3,6,7,9],   // Mão/Dậu → Tý,Dần,Mão,Ngọ,Mùi,Dậu
       [2,4,5,8,10,11], // Thìn/Tuất → Dần,Thìn,Tỵ,Thân,Tuất,Hợi
       [0,1,4,6,7,10],  // Tỵ/Hợi → Tý,Sửu,Thìn,Ngọ,Mùi,Tuất
     ];
     ```
   - `List<String> getHoangDaoHours(int dayChiIndex)` returns formatted hour strings with time ranges

4. **Create `lib/services/lunar_calendar_service.dart`**:
   - Method `LunarDate getLunarDate(DateTime solarDate)`:
     1. Call `LunarCalendarConverter.convertSolar2Lunar(day, month, year, timeZone: 7)`
     2. Compute Can Chi for year/month/day via `CanChiHelper`
     3. Get day's Chi index, look up Hoàng Đạo hours
     4. Assemble and return `LunarDate`
   - Method `LunarDate getToday()` - convenience wrapper using `DateTime.now()`

5. **Write unit tests** in `test/utils/can_chi_helper_test.dart`:
   - Known date: 2026-02-07 → verify expected Can Chi output
   - Verify leap month handling
   - Verify Hoàng Đạo pattern correctness for each day type

## Todo List

- [x] Create LunarDate model class
- [x] Implement CanChiHelper with thienCan/diaChi arrays
- [x] Implement year/month/day Can Chi formulas
- [x] Implement HoangDaoHelper with 6 lookup patterns
- [x] Create LunarCalendarService facade
- [x] Write unit tests for Can Chi computation
- [x] Write unit tests for Hoàng Đạo lookup
- [x] Validate against known Vietnamese calendar dates

## Success Criteria

- `LunarCalendarService.getToday()` returns correct lunar date for current day
- Can Chi matches published Vietnamese calendar for 5+ test dates
- Hoàng Đạo hours match all 6 pattern groups
- All unit tests pass

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Month Can Chi formula off-by-one | Medium | Cross-reference 3+ sources |
| Leap month edge case | Medium | Test with known leap month years (2025 leap 6) |
| Timezone drift at midnight | Low | Always use local timezone offset +7 |

## Security Considerations

None. Pure computation, no network or storage.

## Next Steps

Proceed to [Phase 03 - Dashboard UI](phase-03-dashboard-ui.md).
