import 'package:flutter/material.dart';
import '../../models/lunar_date.dart';
import '../../models/widget_config.dart';

/// Layer 1: Digital clock with lunar date sub-text
class DigitalClockView extends StatelessWidget {
  final LunarDate lunar;
  final WidgetConfig config;

  const DigitalClockView({
    super.key,
    required this.lunar,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = config.textColor;
    final mutedColor = textColor.withValues(alpha: 0.5);
    final fontFamily = config.typographyStyle.fontFamily;
    final monthLabel = lunar.isLeapMonth
        ? 'Tháng ${lunar.lunarMonth} (nhuận)'
        : 'Tháng ${lunar.lunarMonth}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Time display
        Text(
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w300,
            color: textColor,
            fontFamily: fontFamily,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        // Lunar date
        Text(
          '${lunar.lunarDay} $monthLabel',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
            fontFamily: fontFamily,
          ),
        ),
        if (config.showYearInfo) ...[
          const SizedBox(height: 2),
          Text(
            'Năm ${lunar.canChiYear}',
            style: TextStyle(fontSize: 11, color: mutedColor, fontFamily: fontFamily),
          ),
        ],
        if (config.showZodiacHours) ...[
          const SizedBox(height: 4),
          Text(
            lunar.hoangDaoHours.take(3).join(' · '),
            style: TextStyle(fontSize: 10, color: mutedColor, fontFamily: fontFamily),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
