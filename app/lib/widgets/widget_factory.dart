import 'package:flutter/material.dart';
import '../models/lunar_date.dart';
import '../models/widget_config.dart';
import '../models/widget_type.dart';
import 'views/digital_clock_view.dart';
import 'views/text_based_view.dart';
import 'views/moon_phase_view.dart';
import 'views/hybrid_calendar_view.dart';

/// Master Dispatcher: returns Layer 1 view based on WidgetType
class WidgetFactory {
  WidgetFactory._();

  static Widget create(LunarDate lunar, WidgetConfig config) {
    switch (config.widgetType) {
      case WidgetType.digitalClock:
        return DigitalClockView(lunar: lunar, config: config);
      case WidgetType.textBased:
        return TextBasedView(lunar: lunar, config: config);
      case WidgetType.moonPhase:
        return MoonPhaseView(lunar: lunar, config: config);
      case WidgetType.hybridCalendar:
        return HybridCalendarView(lunar: lunar, config: config);
    }
  }
}
