import 'package:flutter/material.dart';
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
    final fontFamily = config.typographyStyle.fontFamily;
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
          style: TextStyle(
            fontSize: 13,
            color: mutedColor,
            fontFamily: fontFamily,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Ngày ${lunar.lunarDay} $monthLabel',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: fontFamily,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          lunar.canChiDay,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
            fontFamily: fontFamily,
          ),
        ),
        if (config.showYearInfo) ...[
          const SizedBox(height: 2),
          Text(
            'Năm ${lunar.canChiYear}',
            style: TextStyle(fontSize: 12, color: mutedColor, fontFamily: fontFamily),
          ),
        ],
        if (config.showZodiacHours) ...[
          const SizedBox(height: 4),
          Text(
            'Giờ tốt: ${lunar.hoangDaoHours.take(3).join(', ')}',
            style: TextStyle(fontSize: 10, color: mutedColor, fontFamily: fontFamily),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
