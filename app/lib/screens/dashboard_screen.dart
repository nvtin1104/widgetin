import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lunar_calendar_provider.dart';
import '../theme/color_tokens.dart';
import '../widgets/lunar_calendar_preview.dart';
import '../widgets/widget_preview_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your Widgets',
              style: textTheme.headlineSmall?.copyWith(
                color: ColorTokens.darkText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Consumer<LunarCalendarProvider>(
            builder: (context, provider, child) {
              final lunar = provider.todayLunar;
              if (lunar == null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return WidgetPreviewCard(
                icon: Icons.calendar_month_rounded,
                title: 'Âm Lịch',
                subtitle: 'Vietnamese Lunar Calendar',
                preview: LunarCalendarPreview(lunarDate: lunar),
                onCustomize: () {
                  Navigator.pushNamed(context, '/editor');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
