import 'package:flutter/material.dart';
import '../../models/lunar_date.dart';
import '../../models/widget_config.dart';
import '../../utils/moon_phase_helper.dart';
import '../painters/moon_painter.dart';

/// Layer 1: Moon phase visual with time overlay
class MoonPhaseView extends StatelessWidget {
  final LunarDate lunar;
  final WidgetConfig config;

  const MoonPhaseView({
    super.key,
    required this.lunar,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = config.textColor;
    final mutedColor = textColor.withValues(alpha: 0.5);
    final fontFamily = config.typographyStyle.fontFamily;
    final phase = MoonPhaseHelper.getMoonPhase(lunar.solarDate);
    final phaseName = MoonPhaseHelper.getPhaseName(phase);
    final monthLabel = lunar.isLeapMonth
        ? 'Tháng ${lunar.lunarMonth} nhuận'
        : 'Tháng ${lunar.lunarMonth}';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Moon graphic
        RepaintBoundary(
          child: SizedBox(
            width: 56,
            height: 56,
            child: CustomPaint(
              painter: MoonPainter(
                phase: phase,
                moonColor: textColor.withValues(alpha: 0.9),
                shadowColor: config.backgroundColor.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Text details
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phaseName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: fontFamily,
                ),
              ),
              Text(
                '${lunar.lunarDay} $monthLabel',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontFamily: fontFamily,
                ),
              ),
              if (config.showYearInfo) ...[
                const SizedBox(height: 2),
                Text(
                  lunar.canChiDay,
                  style: TextStyle(fontSize: 11, color: mutedColor, fontFamily: fontFamily),
                ),
              ],
              if (config.showZodiacHours) ...[
                const SizedBox(height: 2),
                Text(
                  lunar.hoangDaoHours.take(2).join(' · '),
                  style: TextStyle(fontSize: 10, color: mutedColor, fontFamily: fontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
