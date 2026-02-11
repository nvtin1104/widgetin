import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lunar_date.dart';
import '../../models/widget_config.dart';

/// Layer 1: Minimalist text layout
class TextBasedView extends StatelessWidget {
  final LunarDate lunar;
  final WidgetConfig config;

  const TextBasedView({
    super.key,
    required this.lunar,
    required this.config,
  });

  static const _weekdays = [
    'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm',
    'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật',
  ];

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
    final weekday = _weekdays[lunar.solarDate.weekday - 1];
    final monthLabel = lunar.isLeapMonth
        ? 'tháng ${lunar.lunarMonth} nhuận'
        : 'tháng ${lunar.lunarMonth}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weekday,
          style: gFont(
            fontSize: 13,
            color: mutedColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Ngày ${lunar.lunarDay} $monthLabel',
          style: gFont(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          lunar.canChiDay,
          style: gFont(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        if (config.showYearInfo) ...[
          const SizedBox(height: 2),
          Text(
            'Năm ${lunar.canChiYear}',
            style: gFont(fontSize: 12, color: mutedColor),
          ),
        ],
        if (config.showZodiacHours) ...[
          const SizedBox(height: 4),
          Text(
            'Giờ tốt: ${lunar.hoangDaoHours.take(3).join(', ')}',
            style: gFont(fontSize: 10, color: mutedColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
