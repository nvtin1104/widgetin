import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lunar_calendar_provider.dart';
import '../providers/widget_config_provider.dart';
import '../theme/color_tokens.dart';
import '../widgets/widget_live_preview.dart';
import '../widgets/widget_preview_card.dart';
import 'widget_editor_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
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
            Consumer2<LunarCalendarProvider, WidgetConfigProvider>(
              builder: (context, lunarProvider, configProvider, child) {
                final lunar = lunarProvider.todayLunar;
                if (lunar == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Hero(
                  tag: 'lunar-widget-card',
                  child: WidgetPreviewCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'Âm Lịch',
                    subtitle: configProvider.config.widgetType.description,
                    preview: const WidgetLivePreview(),
                    onCustomize: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WidgetEditorScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
