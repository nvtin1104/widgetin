import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/models/lunar_date.dart';
import 'package:widgetin/models/widget_config.dart';
import 'package:widgetin/models/widget_type.dart';
import 'package:widgetin/widgets/widget_factory.dart';
import 'package:widgetin/widgets/views/digital_clock_view.dart';
import 'package:widgetin/widgets/views/text_based_view.dart';
import 'package:widgetin/widgets/views/moon_phase_view.dart';
import 'package:widgetin/widgets/views/hybrid_calendar_view.dart';

void main() {
  final testLunar = LunarDate(
    solarDate: DateTime(2024, 2, 10),
    lunarDay: 1,
    lunarMonth: 1,
    lunarYear: 2024,
    isLeapMonth: false,
    canChiYear: 'Giáp Thìn',
    canChiMonth: 'Bính Dần',
    canChiDay: 'Giáp Tý',
    hoangDaoHours: ['Tý', 'Sửu', 'Mão', 'Ngọ', 'Thân', 'Dậu'],
  );

  group('WidgetFactory', () {
    test('returns DigitalClockView for digitalClock type', () {
      const config = WidgetConfig(widgetType: WidgetType.digitalClock);
      final widget = WidgetFactory.create(testLunar, config);
      expect(widget, isA<DigitalClockView>());
    });

    test('returns TextBasedView for textBased type', () {
      const config = WidgetConfig(widgetType: WidgetType.textBased);
      final widget = WidgetFactory.create(testLunar, config);
      expect(widget, isA<TextBasedView>());
    });

    test('returns MoonPhaseView for moonPhase type', () {
      const config = WidgetConfig(widgetType: WidgetType.moonPhase);
      final widget = WidgetFactory.create(testLunar, config);
      expect(widget, isA<MoonPhaseView>());
    });

    test('returns HybridCalendarView for hybridCalendar type', () {
      const config = WidgetConfig(widgetType: WidgetType.hybridCalendar);
      final widget = WidgetFactory.create(testLunar, config);
      expect(widget, isA<HybridCalendarView>());
    });

    test('produces different widget for each type', () {
      final widgets = WidgetType.values.map((type) {
        final config = WidgetConfig(widgetType: type);
        return WidgetFactory.create(testLunar, config).runtimeType;
      }).toSet();
      expect(widgets.length, 4);
    });
  });
}
