import 'can_chi_helper.dart';

class HoangDaoHelper {
  HoangDaoHelper._();

  /// Time ranges for each Chi hour (12 two-hour blocks).
  static const List<String> _hourRanges = [
    'Tý (23-01)',
    'Sửu (01-03)',
    'Dần (03-05)',
    'Mão (05-07)',
    'Thìn (07-09)',
    'Tỵ (09-11)',
    'Ngọ (11-13)',
    'Mùi (13-15)',
    'Thân (15-17)',
    'Dậu (17-19)',
    'Tuất (19-21)',
    'Hợi (21-23)',
  ];

  /// 6 Hoàng Đạo patterns indexed by day-type group.
  /// Day Chi pairs: {Tý/Ngọ}→0, {Sửu/Mùi}→1, {Dần/Thân}→2,
  ///                {Mão/Dậu}→3, {Thìn/Tuất}→4, {Tỵ/Hợi}→5
  static const List<List<int>> _patterns = [
    [0, 1, 3, 6, 7, 9],    // Tý/Ngọ   → Tý,Sửu,Mão,Ngọ,Mùi,Dậu
    [2, 3, 5, 8, 9, 11],   // Sửu/Mùi  → Dần,Mão,Tỵ,Thân,Dậu,Hợi
    [0, 1, 4, 5, 7, 10],   // Dần/Thân → Tý,Sửu,Thìn,Tỵ,Mùi,Tuất
    [0, 2, 3, 6, 7, 9],    // Mão/Dậu  → Tý,Dần,Mão,Ngọ,Mùi,Dậu
    [2, 4, 5, 8, 10, 11],  // Thìn/Tuất → Dần,Thìn,Tỵ,Thân,Tuất,Hợi
    [0, 1, 4, 6, 7, 10],   // Tỵ/Hợi   → Tý,Sửu,Thìn,Ngọ,Mùi,Tuất
  ];

  /// Get Hoàng Đạo (auspicious) hours for a given day Chi index (0-11).
  static List<String> getHoangDaoHours(int dayChiIndex) {
    final patternGroup = dayChiIndex % 6;
    return _patterns[patternGroup]
        .map((i) => _hourRanges[i])
        .toList(growable: false);
  }

  /// Convenience: get Hoàng Đạo hours from a Gregorian date.
  static List<String> getHoangDaoHoursForDate(DateTime date) {
    final jdn = CanChiHelper.julianDayNumber(date);
    final dayChiIndex = CanChiHelper.getDayChiIndex(jdn);
    return getHoangDaoHours(dayChiIndex);
  }
}
