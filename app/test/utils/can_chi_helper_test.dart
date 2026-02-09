import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/utils/can_chi_helper.dart';

void main() {
  group('CanChiHelper', () {
    group('julianDayNumber', () {
      test('Jan 1, 2000 = JDN 2451545', () {
        expect(
          CanChiHelper.julianDayNumber(DateTime(2000, 1, 1)),
          2451545,
        );
      });

      test('Jan 1, 1900 = JDN 2415021', () {
        expect(
          CanChiHelper.julianDayNumber(DateTime(1900, 1, 1)),
          2415021,
        );
      });
    });

    group('getCanChiYear', () {
      test('2024 = Giáp Thìn', () {
        expect(CanChiHelper.getCanChiYear(2024), 'Giáp Thìn');
      });

      test('2025 = Ất Tỵ', () {
        expect(CanChiHelper.getCanChiYear(2025), 'Ất Tỵ');
      });

      test('2026 = Bính Ngọ', () {
        expect(CanChiHelper.getCanChiYear(2026), 'Bính Ngọ');
      });

      test('2023 = Quý Mão', () {
        expect(CanChiHelper.getCanChiYear(2023), 'Quý Mão');
      });

      test('2020 = Canh Tý', () {
        expect(CanChiHelper.getCanChiYear(2020), 'Canh Tý');
      });
    });

    group('getCanChiMonth', () {
      // In Giáp year (canIndex=0), month 1 should start with Bính (index 2)
      test('Giáp year, month 1 = Bính Dần', () {
        expect(CanChiHelper.getCanChiMonth(1, 2024), 'Bính Dần');
      });

      // Month Chi is fixed: month 1=Dần, month 6=Mùi, month 12=Sửu
      test('month 6 Chi = Mùi', () {
        final result = CanChiHelper.getCanChiMonth(6, 2024);
        expect(result.split(' ').last, 'Mùi');
      });

      test('month 12 Chi = Sửu', () {
        final result = CanChiHelper.getCanChiMonth(12, 2024);
        expect(result.split(' ').last, 'Sửu');
      });

      test('month 11 Chi = Tý', () {
        final result = CanChiHelper.getCanChiMonth(11, 2024);
        expect(result.split(' ').last, 'Tý');
      });
    });

    group('getCanChiDay', () {
      // Feb 10, 2024 (Tết Giáp Thìn) = JDN 2460351
      // Day Can = (2460351+9)%10 = 0 → Giáp
      // Day Chi = (2460351+1)%12 = 4 → Thìn
      test('Feb 10, 2024 = Giáp Thìn', () {
        final jdn = CanChiHelper.julianDayNumber(DateTime(2024, 2, 10));
        expect(CanChiHelper.getCanChiDay(jdn), 'Giáp Thìn');
      });

      // Verify day Chi index for Hoàng Đạo lookup
      test('getDayChiIndex returns correct index', () {
        final jdn = CanChiHelper.julianDayNumber(DateTime(2024, 2, 10));
        expect(CanChiHelper.getDayChiIndex(jdn), 4); // Thìn = index 4
      });
    });

    group('thienCan and diaChi arrays', () {
      test('thienCan has 10 elements', () {
        expect(CanChiHelper.thienCan.length, 10);
      });

      test('diaChi has 12 elements', () {
        expect(CanChiHelper.diaChi.length, 12);
      });

      test('first thienCan is Giáp', () {
        expect(CanChiHelper.thienCan[0], 'Giáp');
      });

      test('first diaChi is Tý', () {
        expect(CanChiHelper.diaChi[0], 'Tý');
      });
    });
  });
}
