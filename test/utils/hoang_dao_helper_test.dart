import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/utils/hoang_dao_helper.dart';

void main() {
  group('HoangDaoHelper', () {
    group('getHoangDaoHours returns 6 hours for each pattern', () {
      for (int i = 0; i < 12; i++) {
        test('day Chi index $i returns 6 hours', () {
          final hours = HoangDaoHelper.getHoangDaoHours(i);
          expect(hours.length, 6);
        });
      }
    });

    group('pattern correctness', () {
      // Pattern 0: Tý/Ngọ days → Tý,Sửu,Mão,Ngọ,Mùi,Dậu
      test('Tý day (index 0) = Tý,Sửu,Mão,Ngọ,Mùi,Dậu', () {
        final hours = HoangDaoHelper.getHoangDaoHours(0);
        expect(hours[0], contains('Tý'));
        expect(hours[1], contains('Sửu'));
        expect(hours[2], contains('Mão'));
        expect(hours[3], contains('Ngọ'));
        expect(hours[4], contains('Mùi'));
        expect(hours[5], contains('Dậu'));
      });

      // Ngọ (index 6) should have same pattern as Tý (index 0)
      test('Ngọ day (index 6) matches Tý pattern', () {
        final tyHours = HoangDaoHelper.getHoangDaoHours(0);
        final ngoHours = HoangDaoHelper.getHoangDaoHours(6);
        expect(ngoHours, tyHours);
      });

      // Pattern 1: Sửu/Mùi → Dần,Mão,Tỵ,Thân,Dậu,Hợi
      test('Sửu day (index 1) = Dần,Mão,Tỵ,Thân,Dậu,Hợi', () {
        final hours = HoangDaoHelper.getHoangDaoHours(1);
        expect(hours[0], contains('Dần'));
        expect(hours[1], contains('Mão'));
        expect(hours[2], contains('Tỵ'));
        expect(hours[3], contains('Thân'));
        expect(hours[4], contains('Dậu'));
        expect(hours[5], contains('Hợi'));
      });

      // Pattern 4: Thìn/Tuất → Dần,Thìn,Tỵ,Thân,Tuất,Hợi
      test('Thìn day (index 4) = Dần,Thìn,Tỵ,Thân,Tuất,Hợi', () {
        final hours = HoangDaoHelper.getHoangDaoHours(4);
        expect(hours[0], contains('Dần'));
        expect(hours[1], contains('Thìn'));
        expect(hours[2], contains('Tỵ'));
        expect(hours[3], contains('Thân'));
        expect(hours[4], contains('Tuất'));
        expect(hours[5], contains('Hợi'));
      });

      // Tuất (index 10) should have same pattern as Thìn (index 4)
      test('Tuất day (index 10) matches Thìn pattern', () {
        final thinHours = HoangDaoHelper.getHoangDaoHours(4);
        final tuatHours = HoangDaoHelper.getHoangDaoHours(10);
        expect(tuatHours, thinHours);
      });
    });

    group('hour format', () {
      test('each hour contains time range in parentheses', () {
        final hours = HoangDaoHelper.getHoangDaoHours(0);
        for (final hour in hours) {
          expect(hour, matches(RegExp(r'.+ \(\d{2}-\d{2}\)')));
        }
      });
    });

    group('all 6 paired patterns are distinct', () {
      test('6 unique patterns exist', () {
        final allPatterns = <String>{};
        for (int i = 0; i < 6; i++) {
          allPatterns.add(HoangDaoHelper.getHoangDaoHours(i).join(','));
        }
        expect(allPatterns.length, 6);
      });
    });
  });
}
