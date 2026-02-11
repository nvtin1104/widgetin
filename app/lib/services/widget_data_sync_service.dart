import 'package:home_widget/home_widget.dart';
import '../models/lunar_date.dart';
import '../models/widget_config.dart';

/// Syncs lunar data and widget config to HomeWidget SharedPreferences
/// so the native Android widget can read them.
class WidgetDataSyncService {
  WidgetDataSyncService._();

  static const _androidWidgetName = 'LunarCalendarWidget';

  /// Sync lunar date data to SharedPreferences for the native widget.
  static Future<void> syncLunarData(LunarDate lunar) async {
    final solarDate = '${lunar.solarDate.day.toString().padLeft(2, '0')}/'
        '${lunar.solarDate.month.toString().padLeft(2, '0')}/'
        '${lunar.solarDate.year}';
    final monthStr = lunar.lunarMonth.toString().padLeft(2, '0');
    final lunarDate = lunar.isLeapMonth
        ? '${lunar.lunarDay.toString().padLeft(2, '0')}/$monthStr (nhuận)'
        : '${lunar.lunarDay.toString().padLeft(2, '0')}/$monthStr';

    await Future.wait([
      HomeWidget.saveWidgetData('lunar_solar_date', solarDate),
      HomeWidget.saveWidgetData('lunar_date', lunarDate),
      HomeWidget.saveWidgetData('lunar_year', lunar.canChiYear),
      HomeWidget.saveWidgetData('lunar_can_chi_day', lunar.canChiDay),
      HomeWidget.saveWidgetData(
        'lunar_hoang_dao',
        lunar.hoangDaoHours.join(', '),
      ),
    ]);
  }

  /// Sync widget config (colors, type, style) to SharedPreferences.
  static Future<void> syncConfig(WidgetConfig config) async {
    await Future.wait([
      HomeWidget.saveWidgetData(
        'widget_bg_color',
        config.backgroundColor.toARGB32(),
      ),
      HomeWidget.saveWidgetData(
        'widget_text_color',
        config.textColor.toARGB32(),
      ),
      HomeWidget.saveWidgetData(
        'widget_gradient_end_color',
        config.gradientEndColor.toARGB32(),
      ),
      HomeWidget.saveWidgetData('widget_border_radius', config.borderRadius),
      HomeWidget.saveWidgetData('widget_type', config.widgetType.index),
      HomeWidget.saveWidgetData('widget_bg_type', config.backgroundType.index),
      HomeWidget.saveWidgetData('widget_typo_style', config.typographyStyle.index),
      HomeWidget.saveWidgetData('widget_show_year', config.showYearInfo),
      HomeWidget.saveWidgetData('widget_show_zodiac', config.showZodiacHours),
      HomeWidget.saveWidgetData('widget_show_solar', config.showSolarTerms),
    ]);
  }

  /// Sync both lunar data and config, then trigger widget update.
  static Future<void> syncAll(LunarDate lunar, WidgetConfig config) async {
    await Future.wait([
      syncLunarData(lunar),
      syncConfig(config),
    ]);
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
    );
  }

  /// Trigger the native widget to refresh its display.
  static Future<void> updateWidget() async {
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
    );
  }
}
