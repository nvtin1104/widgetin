class CanChiHelper {
  CanChiHelper._();

  static const List<String> thienCan = [
    'Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu',
    'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý',
  ];

  static const List<String> diaChi = [
    'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ',
    'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi',
  ];

  /// Can Chi for lunar year.
  /// Year Can = (year + 6) % 10, Year Chi = (year + 8) % 12
  static String getCanChiYear(int lunarYear) {
    final can = thienCan[(lunarYear + 6) % 10];
    final chi = diaChi[(lunarYear + 8) % 12];
    return '$can $chi';
  }

  /// Can Chi for lunar month.
  /// Month Can depends on year's Can stem index.
  /// Month Chi is fixed: month 1 = Dần, month 2 = Mão, ...
  static String getCanChiMonth(int lunarMonth, int lunarYear) {
    final yearCanIndex = (lunarYear + 6) % 10;
    final monthCanIndex = (yearCanIndex * 2 + lunarMonth + 1) % 10;
    final monthChiIndex = (lunarMonth + 1) % 12;
    return '${thienCan[monthCanIndex]} ${diaChi[monthChiIndex]}';
  }

  /// Can Chi for a day based on Julian Day Number.
  /// Day Can = (jdn + 9) % 10, Day Chi = (jdn + 1) % 12
  static String getCanChiDay(int jdn) {
    final can = thienCan[(jdn + 9) % 10];
    final chi = diaChi[(jdn + 1) % 12];
    return '$can $chi';
  }

  /// Day Chi index from JDN (used for Hoàng Đạo lookup).
  static int getDayChiIndex(int jdn) {
    return (jdn + 1) % 12;
  }

  /// Convert Gregorian date to Julian Day Number.
  /// Standard algorithm valid for dates after Oct 15, 1582.
  static int julianDayNumber(DateTime date) {
    final int y = date.year;
    final int m = date.month;
    final int d = date.day;
    final int a = (14 - m) ~/ 12;
    final int yAdj = y + 4800 - a;
    final int mAdj = m + 12 * a - 3;
    return d +
        (153 * mAdj + 2) ~/ 5 +
        365 * yAdj +
        yAdj ~/ 4 -
        yAdj ~/ 100 +
        yAdj ~/ 400 -
        32045;
  }
}
