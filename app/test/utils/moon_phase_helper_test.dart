import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/utils/moon_phase_helper.dart';

void main() {
  group('MoonPhaseHelper', () {
    test('new moon returns phase near 0.0', () {
      // Jan 11, 2024 was a known new moon
      final phase = MoonPhaseHelper.getMoonPhase(DateTime(2024, 1, 11));
      expect(phase, closeTo(0.0, 0.08));
    });

    test('full moon returns phase near 0.5', () {
      // Jan 25, 2024 was a known full moon
      final phase = MoonPhaseHelper.getMoonPhase(DateTime(2024, 1, 25));
      expect(phase, closeTo(0.5, 0.08));
    });

    test('first quarter returns phase near 0.25', () {
      // Jan 18, 2024 was first quarter
      final phase = MoonPhaseHelper.getMoonPhase(DateTime(2024, 1, 18));
      expect(phase, closeTo(0.25, 0.08));
    });

    test('last quarter returns phase near 0.75', () {
      // Feb 2, 2024 was last quarter
      final phase = MoonPhaseHelper.getMoonPhase(DateTime(2024, 2, 2));
      expect(phase, closeTo(0.75, 0.08));
    });

    test('phase is always between 0.0 and 1.0', () {
      for (int i = 0; i < 365; i++) {
        final date = DateTime(2024, 1, 1).add(Duration(days: i));
        final phase = MoonPhaseHelper.getMoonPhase(date);
        expect(phase, greaterThanOrEqualTo(0.0));
        expect(phase, lessThan(1.0));
      }
    });

    test('illumination is 0 at new moon', () {
      final illum = MoonPhaseHelper.getIllumination(0.0);
      expect(illum, closeTo(0.0, 0.01));
    });

    test('illumination is 1 at full moon', () {
      final illum = MoonPhaseHelper.getIllumination(0.5);
      expect(illum, closeTo(1.0, 0.01));
    });

    test('getPhaseName returns Vietnamese names', () {
      expect(MoonPhaseHelper.getPhaseName(0.0), 'Trăng non');
      expect(MoonPhaseHelper.getPhaseName(0.25), 'Bán nguyệt đầu');
      expect(MoonPhaseHelper.getPhaseName(0.5), 'Trăng tròn');
      expect(MoonPhaseHelper.getPhaseName(0.75), 'Bán nguyệt cuối');
    });

    test('getPhaseName covers all 8 phases', () {
      final names = <String>{};
      for (int i = 0; i < 80; i++) {
        names.add(MoonPhaseHelper.getPhaseName(i / 80));
      }
      expect(names.length, 8);
    });
  });
}
