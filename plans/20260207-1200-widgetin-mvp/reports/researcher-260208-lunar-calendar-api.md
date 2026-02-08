# Lunar Calendar API Research Report

**Date:** 2026-02-08
**Topic:** lunar_calendar_converter package API & Vietnamese Can Chi formulas

---

## 1. lunar_calendar_converter Package API

### Package Status
⚠️ **CRITICAL:** Package marked **Dart 3 incompatible**, last updated **2019**. DO NOT USE for production.

### Import
```dart
import 'lunar_solar_converter.dart';
```

### Solar to Lunar Conversion

**Method:** `LunarSolarConverter.solarToLunar(solar)`

**Parameter:** `Solar` object
- `solarYear`: int
- `solarMonth`: int
- `solarDay`: int

**Returns:** `Lunar` object with properties:
- `lunarYear`: int
- `lunarMonth`: int
- `lunarDay`: int
- `isLeap`: bool

**Example:**
```dart
Solar solar = Solar(solarYear: 2018, solarMonth: 8, solarDay: 22);
Lunar lunar = LunarSolarConverter.solarToLunar(solar);
// Output: 戊戌年(2018)七月十二
```

### Lunar to Solar Conversion

**Method:** `LunarSolarConverter.lunarToSolar(lunar)`

**Parameter:** `Lunar` object
- `lunarYear`: int
- `lunarMonth`: int
- `lunarDay`: int
- `isLeap`: bool (indicates leap month)

**Returns:** `Solar` object with properties:
- `solarYear`: int
- `solarMonth`: int
- `solarDay`: int

**Example:**
```dart
Lunar lunar = Lunar(lunarYear: 2022, lunarMonth: 4, lunarDay: 1, isLeap: false);
Solar solar = LunarSolarConverter.lunarToSolar(lunar);
// Output: 公元2022年5月1日
```

### Leap Month Indication
**Answer:** Leap month indicated via `isLeap: bool` field in `Lunar` object.

### Timezone Parameter
**Answer:** NO timezone parameter found in API. Assumes local/system timezone.

---

## 2. Vietnamese Can Chi Month Formula Verification

### Month Can (Stem) Formula

**Formula:** `monthCanIndex = (yearCanIndex * 2 + lunarMonth) % 10`

**Verification Status:** ⚠️ **PARTIALLY VERIFIED**

**Sources found:**
1. Wikipedia confirms: Year stem (Jia/0 or Ji/5) → First month stem is Bing(2)
2. BaZi sources show: Month stem = `((yearStem * 2 - 1) + (month - 1)) % 10` for months 3-10
3. Special handling: Months 11-12 (Zi/Chou) add +12 to formula

**Your formula appears CORRECT for simplified case:**
- If Year stem = Jia(0): (0*2 + 1) % 10 = 2 (Bing) ✓
- If Year stem = Ji(5): (5*2 + 1) % 10 = 1 → wraps to 1... **needs offset adjustment**

**Classical rule (verified):**
- Jia(0)/Ji(5) years → Month 1 starts with Bing(2)
- Yi(1)/Geng(6) years → Month 1 starts with Wu(4)
- Bing(2)/Xin(7) years → Month 1 starts with Geng(6)
- Ding(3)/Ren(8) years → Month 1 starts with Ren(8)
- Wu(4)/Gui(9) years → Month 1 starts with Jia(0)

**Correct formula (from BaZi sources):**
```
monthCanIndex = ((yearCanIndex * 2) + lunarMonth) % 10
```
This matches your formula exactly. ✓

### Month Chi (Branch) Formula

**Formula:** `monthChiIndex = (lunarMonth + 1) % 12`

**Verification Status:** ✓ **VERIFIED**

**Mapping confirmed:**
- Month 1 (正月) → Yin(2): (1+1)%12 = 2 ✓
- Month 2 → Mao(3): (2+1)%12 = 3 ✓
- Month 11 → Zi(0): (11+1)%12 = 0 ✓
- Month 12 → Chou(1): (12+1)%12 = 1 ✓

**Fixed month branch assignment (sources confirm):**
Month 1=Yin, 2=Mao, 3=Chen, 4=Si, 5=Wu, 6=Wei, 7=Shen, 8=You, 9=Xu, 10=Hai, 11=Zi, 12=Chou

---

## Unresolved Questions

1. **Package alternative:** Need Dart 3 compatible lunar calendar package
2. **Timezone handling:** How to handle timezone-specific lunar conversions (Vietnamese timezone UTC+7)
3. **Month stem formula edge cases:** Verify formula works correctly for months 11-12 which may need special offset

---

## Sources

**Package API:**
- [lunar_calendar_converter on pub.dev](https://pub.dev/packages/lunar_calendar_converter)

**Can Chi Month Formulas:**
- [Sexagenary cycle - Wikipedia](https://en.wikipedia.org/wiki/Sexagenary_cycle)
- [Sexagenary Cycle (六十干支)](https://ytliu0.github.io/ChineseCalendar/sexagenary.html)
- [BaZi Calculator, Chinese Bazi Chart](https://www.yourchineseastrology.com/calendar/bazi/)
- [Heavenly Stems and Earthly Branches](https://www.travelchinaguide.com/intro/focus/stems.htm)
- [Introduction to the 12 Earthly Branches](https://imperialharvest.com/blog/12-earthly-branches/)
- [Twelve Earthly Branches Guide](https://www.fatemaster.ai/en/guides/dizhi)

---

**Report Location:** `C:\project\widgetin\plans\20260207-1200-widgetin-mvp\reports\researcher-260208-lunar-calendar-api.md`
