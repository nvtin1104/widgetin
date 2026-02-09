import 'dart:math';
import 'can_chi_helper.dart';

/// Calculates moon phase from a solar date using synodic month cycle.
class MoonPhaseHelper {
  MoonPhaseHelper._();

  /// Synodic month length in days
  static const _synodicMonth = 29.530588853;

  /// Reference new moon: Jan 6, 2000 18:14 UTC (JD 2451550.26)
  static const _referenceNewMoonJd = 2451550.26;

  /// Returns moon phase as 0.0–1.0.
  /// 0.0 = new moon, 0.25 = first quarter, 0.5 = full, 0.75 = last quarter
  static double getMoonPhase(DateTime date) {
    final jd = CanChiHelper.julianDayNumber(date).toDouble();
    final daysSinceRef = jd - _referenceNewMoonJd;
    final cycles = daysSinceRef / _synodicMonth;
    final phase = cycles - cycles.floor();
    return phase;
  }

  /// Returns illumination fraction 0.0–1.0 (0=new, 1=full)
  static double getIllumination(double phase) {
    return (1 - cos(phase * 2 * pi)) / 2;
  }

  /// Vietnamese phase name
  static String getPhaseName(double phase) {
    if (phase < 0.0625 || phase >= 0.9375) return 'Trăng non';
    if (phase < 0.1875) return 'Lưỡi liềm đầu';
    if (phase < 0.3125) return 'Bán nguyệt đầu';
    if (phase < 0.4375) return 'Trăng khuyết đầu';
    if (phase < 0.5625) return 'Trăng tròn';
    if (phase < 0.6875) return 'Trăng khuyết cuối';
    if (phase < 0.8125) return 'Bán nguyệt cuối';
    return 'Lưỡi liềm cuối';
  }
}
