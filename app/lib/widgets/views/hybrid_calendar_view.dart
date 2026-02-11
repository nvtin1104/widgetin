import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lunar_date.dart';
import '../../models/widget_config.dart';

/// Layer 1: Classic calendar layout with numbers, text, and info
class HybridCalendarView extends StatelessWidget {
  final LunarDate lunar;
  final WidgetConfig config;

  const HybridCalendarView({
    super.key,
    required this.lunar,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = config.textColor;
    final mutedColor = textColor.withValues(alpha: 0.5);
    final accentColor = textColor.withValues(alpha: 0.7);
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left: large lunar day number
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${lunar.lunarDay}',
                style: gFont(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                monthLabel,
                style: gFont(fontSize: 11, color: mutedColor),
              ),
            ],
          ),
        ),
        // Divider
        Container(
          width: 1,
          height: 56,
          color: textColor.withValues(alpha: 0.12),
        ),
        const SizedBox(width: 12),
        // Right: details column
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${lunar.solarDate.day}/${lunar.solarDate.month}/${lunar.solarDate.year}',
                style: gFont(fontSize: 11, color: mutedColor),
              ),
              const SizedBox(height: 2),
              Text(
                lunar.canChiDay,
                style: gFont(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              if (config.showYearInfo) ...[
                Text(
                  'Năm ${lunar.canChiYear}',
                  style: gFont(fontSize: 12, color: accentColor),
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
          ),
        ),
      ],
    );
  }
}
