class LunarDate {
  final DateTime solarDate;
  final int lunarDay;
  final int lunarMonth;
  final int lunarYear;
  final bool isLeapMonth;
  final String canChiYear;
  final String canChiMonth;
  final String canChiDay;
  final List<String> hoangDaoHours;

  const LunarDate({
    required this.solarDate,
    required this.lunarDay,
    required this.lunarMonth,
    required this.lunarYear,
    required this.isLeapMonth,
    required this.canChiYear,
    required this.canChiMonth,
    required this.canChiDay,
    required this.hoangDaoHours,
  });

  LunarDate copyWith({
    DateTime? solarDate,
    int? lunarDay,
    int? lunarMonth,
    int? lunarYear,
    bool? isLeapMonth,
    String? canChiYear,
    String? canChiMonth,
    String? canChiDay,
    List<String>? hoangDaoHours,
  }) {
    return LunarDate(
      solarDate: solarDate ?? this.solarDate,
      lunarDay: lunarDay ?? this.lunarDay,
      lunarMonth: lunarMonth ?? this.lunarMonth,
      lunarYear: lunarYear ?? this.lunarYear,
      isLeapMonth: isLeapMonth ?? this.isLeapMonth,
      canChiYear: canChiYear ?? this.canChiYear,
      canChiMonth: canChiMonth ?? this.canChiMonth,
      canChiDay: canChiDay ?? this.canChiDay,
      hoangDaoHours: hoangDaoHours ?? this.hoangDaoHours,
    );
  }

  String get lunarDateString {
    final monthLabel = isLeapMonth ? '$lunarMonth (nhuận)' : '$lunarMonth';
    return '$lunarDay/$monthLabel';
  }

  @override
  String toString() {
    return 'LunarDate($lunarDay/$lunarMonth/$lunarYear, $canChiDay, $canChiYear)';
  }
}
