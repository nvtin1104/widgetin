import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/providers/lunar_calendar_provider.dart';

void main() {
  group('LunarCalendarProvider', () {
    test('todayLunar is null before loadToday', () {
      final provider = LunarCalendarProvider();
      expect(provider.todayLunar, isNull);
    });

    test('loadToday populates todayLunar', () {
      final provider = LunarCalendarProvider();
      provider.loadToday();
      expect(provider.todayLunar, isNotNull);
    });

    test('loadToday sets correct solar date', () {
      final provider = LunarCalendarProvider();
      provider.loadToday();
      final today = DateTime.now();
      expect(provider.todayLunar!.solarDate.year, today.year);
      expect(provider.todayLunar!.solarDate.month, today.month);
      expect(provider.todayLunar!.solarDate.day, today.day);
    });

    test('loadToday fills Can Chi fields', () {
      final provider = LunarCalendarProvider();
      provider.loadToday();
      expect(provider.todayLunar!.canChiYear, isNotEmpty);
      expect(provider.todayLunar!.canChiMonth, isNotEmpty);
      expect(provider.todayLunar!.canChiDay, isNotEmpty);
    });

    test('loadToday fills hoangDaoHours with 6 entries', () {
      final provider = LunarCalendarProvider();
      provider.loadToday();
      expect(provider.todayLunar!.hoangDaoHours.length, 6);
    });

    test('notifies listeners on loadToday', () {
      final provider = LunarCalendarProvider();
      int callCount = 0;
      provider.addListener(() => callCount++);
      provider.loadToday();
      expect(callCount, 1);
    });
  });
}
