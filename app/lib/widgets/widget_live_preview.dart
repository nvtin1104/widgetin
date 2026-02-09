import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lunar_calendar_provider.dart';
import '../providers/widget_config_provider.dart';
import 'widget_decorator.dart';
import 'widget_factory.dart';

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
          child: lunar == null
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: config.backgroundColor,
                    borderRadius: BorderRadius.circular(config.borderRadius),
                  ),
                  child: Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(color: config.textColor),
                    ),
                  ),
                )
              : WidgetDecorator(
                  config: config,
                  child: WidgetFactory.create(lunar, config),
                ),
        );
      },
    );
  }
}
