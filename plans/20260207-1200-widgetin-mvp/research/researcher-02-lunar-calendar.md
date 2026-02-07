# Vietnamese Lunar Calendar Implementation Research - Widgetin MVP

**Date:** 2026-02-07 | **Project:** Widgetin | **Focus:** Lunar calendar logic, Can Chi, Giờ Hoàng Đạo

## 1. Lunar Calendar Converter Packages

- **`lunar_calendar_converter` (pub.dev):** Pure Dart, core functions `convertSolar2Lunar()` / `convertLunar2Solar()`, verified 1900-2100+
- Limitations: No built-in Can-Chi; timezone-naive
- No other widely-adopted pure-Dart alternatives for Vietnamese calendars

## 2. Hồ Ngọc Đức Algorithm

Fully ported in `lunar_calendar_converter` package. Key functions:
- `jdFromDate()` - Convert Gregorian date → Julian Day Number
- `getNewMoonDay()` - Find new moon day from Julian Day
- `getSunLongitude()` - Sun's ecliptic longitude for month boundary
- `getLeapMonthOffset()` - Determine leap month position
- Leap month threshold: solar longitude ~355°
- Uses iterative approximation for new moon calculation

## 3. Can Chi (Thiên Can & Địa Chi)

**Thiên Can (10-cycle):** Giáp, Ất, Bính, Đinh, Mậu, Kỷ, Canh, Tân, Nhâm, Quý
**Địa Chi (12-cycle):** Tý, Sửu, Dần, Mão, Thìn, Tỵ, Ngọ, Mùi, Thân, Dậu, Tuất, Hợi

**Computation:**
- Year Can: `(year + 6) % 10` (index into Can array)
- Year Chi: `(year + 8) % 12` (index into Chi array)
- Month/Day: Similar modulo from epoch reference
- **Implementation:** Simple Dart enums + lookup maps, no external package needed

## 4. Giờ Hoàng Đạo (Auspicious Hours)

**12 Chi Hour System:** Each Chi → 2-hour block (Tý=23-01, Sửu=01-03, ..., Hợi=21-23)

**Approach:** Static lookup table
- 6 day-types based on lunar day's Chi → each maps to 6 auspicious hours
- Total: 6 patterns × 6 hours = compact table
- Table approach superior to complex astronomical calculation for mobile
- Source from Vietnamese ephemeris / traditional Thông Thư

**Patterns (Day Chi → Hoàng Đạo hours):**
- Tý/Ngọ days → Tý, Sửu, Mão, Ngọ, Mùi, Dậu
- Sửu/Mùi days → Dần, Mão, Tỵ, Thân, Dậu, Hợi
- Dần/Thân days → Tý, Sửu, Thìn, Tỵ, Mùi, Tuất
- Mão/Dậu days → Tý, Dần, Mão, Ngọ, Mùi, Dậu
- Thìn/Tuất days → Dần, Thìn, Tỵ, Thân, Tuất, Hợi
- Tỵ/Hợi days → Tý, Sửu, Thìn, Ngọ, Mùi, Tuất

## 5. Flutter UI Patterns for Calendar Widget

**Home Screen Widget Design:**
- Lunar date card (Material You pastel) + compact info layout
- Show: Solar date, Lunar date, Can Chi year, auspicious hours

**Color Tokens (Pastel):**
- Soft red: `#E8998D`, Cream: `#FAF8F3`, Sage green: `#C4DDC4`
- Dark text: `#2D2D2D`, Muted: `#8B8B8B`

**Widget Approach:**
- `Table` widget for calendar grid (faster than GridView)
- Lazy-load lunar data per visible month
- `ColorScheme.fromSeed()` + `useMaterial3: true` for Material You

## Unresolved Questions
- Exact Vietnamese ephemeris source for Giờ Hoàng Đạo validation
- DST handling verification in `lunar_calendar_converter`
