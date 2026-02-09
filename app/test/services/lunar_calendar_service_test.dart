import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/models/lunar_date.dart';
import 'package:widgetin/services/lunar_calendar_service.dart';

void main() {
  late LunarCalendarService service;

  setUp(() {
    service = LunarCalendarService();
  });

  group('LunarCalendarService', () {
    group('getLunarDate', () {
      test('returns LunarDate with all fields populated', () {
        final result = service.getLunarDate(DateTime(2024, 2, 10));
        expect(result, isA<LunarDate>());
        expect(result.solarDate, DateTime(2024, 2, 10));
        expect(result.lunarDay, isPositive);
        expect(result.lunarMonth, isPositive);
        expect(result.lunarYear, isPositive);
        expect(result.canChiYear, isNotEmpty);
        expect(result.canChiMonth, isNotEmpty);
        expect(result.canChiDay, isNotEmpty);
        expect(result.hoangDaoHours, hasLength(6));
      });

      // Tết 2024 (Feb 10, 2024) = Lunar 1/1/2024 Giáp Thìn
      test('Feb 10, 2024 (Tết) = lunar 1/1, Giáp Thìn year', () {
        final result = service.getLunarDate(DateTime(2024, 2, 10));
        expect(result.lunarDay, 1);
        expect(result.lunarMonth, 1);
        expect(result.lunarYear, 2024);
        expect(result.canChiYear, 'Giáp Thìn');
        expect(result.isLeapMonth, false);
      });

      test('Can Chi day for Feb 10, 2024 = Giáp Thìn', () {
        final result = service.getLunarDate(DateTime(2024, 2, 10));
        expect(result.canChiDay, 'Giáp Thìn');
      });

      // Tết 2025 (Jan 29, 2025) = Lunar 1/1/2025 Ất Tỵ
      test('Jan 29, 2025 (Tết) = lunar 1/1, Ất Tỵ year', () {
        final result = service.getLunarDate(DateTime(2025, 1, 29));
        expect(result.lunarDay, 1);
        expect(result.lunarMonth, 1);
        expect(result.lunarYear, 2025);
        expect(result.canChiYear, 'Ất Tỵ');
      });
    });

    group('LunarDate model', () {
      test('lunarDateString formats correctly without leap month', () {
        final date = LunarDate(
          solarDate: DateTime(2024, 2, 10),
          lunarDay: 1,
          lunarMonth: 1,
          lunarYear: 2024,
          isLeapMonth: false,
          canChiYear: 'Giáp Thìn',
          canChiMonth: 'Bính Dần',
          canChiDay: 'Giáp Thìn',
          hoangDaoHours: const [],
        );
        expect(date.lunarDateString, '1/1');
      });

      test('lunarDateString includes nhuận for leap month', () {
        final date = LunarDate(
          solarDate: DateTime(2023, 4, 20),
          lunarDay: 1,
          lunarMonth: 2,
          lunarYear: 2023,
          isLeapMonth: true,
          canChiYear: 'Quý Mão',
          canChiMonth: 'Ất Mão',
          canChiDay: 'Test',
          hoangDaoHours: const [],
        );
        expect(date.lunarDateString, '1/2 (nhuận)');
      });

      test('copyWith creates copy with overridden fields', () {
        final original = LunarDate(
          solarDate: DateTime(2024, 1, 1),
          lunarDay: 20,
          lunarMonth: 11,
          lunarYear: 2023,
          isLeapMonth: false,
          canChiYear: 'Quý Mão',
          canChiMonth: 'Test',
          canChiDay: 'Test',
          hoangDaoHours: const [],
        );
        final copy = original.copyWith(lunarDay: 21);
        expect(copy.lunarDay, 21);
        expect(copy.lunarMonth, original.lunarMonth);
      });

      test('toString contains key info', () {
        final date = LunarDate(
          solarDate: DateTime(2024, 2, 10),
          lunarDay: 1,
          lunarMonth: 1,
          lunarYear: 2024,
          isLeapMonth: false,
          canChiYear: 'Giáp Thìn',
          canChiMonth: 'Bính Dần',
          canChiDay: 'Giáp Thìn',
          hoangDaoHours: const [],
        );
        expect(date.toString(), contains('1/1/2024'));
        expect(date.toString(), contains('Giáp Thìn'));
      });
    });

    group('getToday', () {
      test('returns a valid LunarDate for today', () {
        final result = service.getToday();
        expect(result, isA<LunarDate>());
        expect(result.solarDate.year, DateTime.now().year);
        expect(result.hoangDaoHours, hasLength(6));
      });
    });
  });
}
