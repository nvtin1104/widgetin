import 'package:flutter/material.dart';
import '../models/lunar_date.dart';
import '../theme/color_tokens.dart';

class LunarCalendarPreview extends StatelessWidget {
  final LunarDate lunarDate;

  const LunarCalendarPreview({super.key, required this.lunarDate});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Solar date
        Text(
          '${lunarDate.solarDate.day}/${lunarDate.solarDate.month}/${lunarDate.solarDate.year}',
          style: textTheme.bodySmall?.copyWith(color: ColorTokens.mutedText),
        ),
        const SizedBox(height: 4),
        // Lunar date large
        Text(
          lunarDate.lunarDateString,
          style: textTheme.headlineMedium?.copyWith(
            color: ColorTokens.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        // Can Chi year
        Text(
          'Năm ${lunarDate.canChiYear}',
          style: textTheme.bodyMedium?.copyWith(color: ColorTokens.softRed),
        ),
        const SizedBox(height: 8),
        // Top 3 Hoang Dao hours
        Text(
          'Giờ Hoàng Đạo',
          style: textTheme.labelSmall?.copyWith(color: ColorTokens.mutedText),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: lunarDate.hoangDaoHours.take(3).map((hour) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ColorTokens.sageGreen.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                hour,
                style: textTheme.labelSmall?.copyWith(
                  color: ColorTokens.darkText,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
