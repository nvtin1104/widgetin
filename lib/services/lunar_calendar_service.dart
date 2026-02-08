import 'package:lunar_calendar_converter/lunar_solar_converter.dart';
import '../models/lunar_date.dart';
import '../utils/can_chi_helper.dart';
import '../utils/hoang_dao_helper.dart';

class LunarCalendarService {
  /// Convert a solar (Gregorian) date to a full LunarDate with Can Chi
  /// and Hoàng Đạo hours.
  LunarDate getLunarDate(DateTime solarDate) {
    // 1. Solar → Lunar conversion
    final solar = Solar(
      solarYear: solarDate.year,
      solarMonth: solarDate.month,
      solarDay: solarDate.day,
    );
    final lunar = LunarSolarConverter.solarToLunar(solar);

    // 2. Can Chi computation
    final canChiYear = CanChiHelper.getCanChiYear(lunar.lunarYear!);
    final canChiMonth = CanChiHelper.getCanChiMonth(
      lunar.lunarMonth!,
      lunar.lunarYear!,
    );
    final jdn = CanChiHelper.julianDayNumber(solarDate);
    final canChiDay = CanChiHelper.getCanChiDay(jdn);

    // 3. Hoàng Đạo hours
    final dayChiIndex = CanChiHelper.getDayChiIndex(jdn);
    final hoangDaoHours = HoangDaoHelper.getHoangDaoHours(dayChiIndex);

    return LunarDate(
      solarDate: solarDate,
      lunarDay: lunar.lunarDay!,
      lunarMonth: lunar.lunarMonth!,
      lunarYear: lunar.lunarYear!,
      isLeapMonth: lunar.isLeap ?? false,
      canChiYear: canChiYear,
      canChiMonth: canChiMonth,
      canChiDay: canChiDay,
      hoangDaoHours: hoangDaoHours,
    );
  }

  /// Get today's lunar date info.
  LunarDate getToday() {
    return getLunarDate(DateTime.now());
  }
}
