import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final fontName = config.typographyStyle.googleFontFamily;
    TextStyle gFont({double? fontSize, FontWeight? fontWeight, Color? color, double? height}) {
      return GoogleFonts.getFont(
        fontName,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
      );
    }
    final monthLabel = lunar.isLeapMonth
        ? 'Tháng ${lunar.lunarMonth} (nhuận)'
        : 'Tháng ${lunar.lunarMonth}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Time display
        Text(
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          style: gFont(
            fontSize: 42,
            fontWeight: FontWeight.w300,
            color: textColor,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        // Lunar date
        Text(
          '${lunar.lunarDay} $monthLabel',
          style: gFont(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        if (config.showYearInfo) ...[
          const SizedBox(height: 2),
          Text(
            'Năm ${lunar.canChiYear}',
            style: gFont(fontSize: 11, color: mutedColor),
          ),
        ],
        if (config.showZodiacHours) ...[
          const SizedBox(height: 4),
          Text(
            lunar.hoangDaoHours.take(3).join(' · '),
            style: gFont(fontSize: 10, color: mutedColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
