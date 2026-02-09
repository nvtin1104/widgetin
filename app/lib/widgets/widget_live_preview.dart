import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lunar_date.dart';
import '../providers/lunar_calendar_provider.dart';
import '../providers/widget_config_provider.dart';

class WidgetLivePreview extends StatelessWidget {
  const WidgetLivePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WidgetConfigProvider, LunarCalendarProvider>(
      builder: (context, configProvider, lunarProvider, child) {
        final config = configProvider.config;
        final lunar = lunarProvider.todayLunar;

        return AspectRatio(
          aspectRatio: 2 / 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: config.backgroundColor,
              borderRadius: BorderRadius.circular(config.borderRadius),
              border: Border.all(
                color: config.textColor.withValues(alpha: 0.12),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: lunar == null
                ? Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(color: config.textColor),
                    ),
                  )
                : _buildContent(context, lunar, config.textColor),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, LunarDate lunar, Color textColor) {
    final mutedColor = textColor.withValues(alpha: 0.5);
    final monthLabel = lunar.isLeapMonth
        ? 'Tháng ${lunar.lunarMonth} (nhuận)'
        : 'Tháng ${lunar.lunarMonth}';

    return Row(
      children: [
        // Left: large lunar day
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${lunar.lunarDay}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                monthLabel,
                style: TextStyle(fontSize: 12, color: mutedColor),
              ),
            ],
          ),
        ),
        // Divider
        Container(
          width: 1,
          height: 60,
          color: textColor.withValues(alpha: 0.12),
        ),
        const SizedBox(width: 12),
        // Right: details
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${lunar.solarDate.day}/${lunar.solarDate.month}/${lunar.solarDate.year}',
                style: TextStyle(fontSize: 11, color: mutedColor),
              ),
              const SizedBox(height: 2),
              Text(
                lunar.canChiDay,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              Text(
                'Năm ${lunar.canChiYear}',
                style: TextStyle(fontSize: 12, color: textColor),
              ),
              const SizedBox(height: 4),
              Text(
                lunar.hoangDaoHours.take(3).join(' · '),
                style: TextStyle(fontSize: 10, color: mutedColor),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
