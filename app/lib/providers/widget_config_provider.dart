import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lunar_date.dart';
import '../models/widget_config.dart';
import '../models/widget_type.dart';
import '../services/widget_data_sync_service.dart';

class WidgetConfigProvider extends ChangeNotifier {
  static const _keyBgColor = 'widget_bg_color';
  static const _keyTextColor = 'widget_text_color';
  static const _keyGradientEndColor = 'widget_gradient_end_color';
  static const _keyBorderRadius = 'widget_border_radius';
  static const _keyWidgetType = 'widget_type';
  static const _keyBackgroundType = 'widget_background_type';
  static const _keyTypographyStyle = 'widget_typography_style';
  static const _keyShowSolarTerms = 'widget_show_solar_terms';
  static const _keyShowZodiacHours = 'widget_show_zodiac_hours';
  static const _keyShowYearInfo = 'widget_show_year_info';

  WidgetConfig _config = const WidgetConfig();

  WidgetConfig get config => _config;

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final bgValue = prefs.getInt(_keyBgColor);
    final textValue = prefs.getInt(_keyTextColor);
    final gradientValue = prefs.getInt(_keyGradientEndColor);
    final radius = prefs.getDouble(_keyBorderRadius);
    final typeIndex = prefs.getInt(_keyWidgetType);
    final bgTypeIndex = prefs.getInt(_keyBackgroundType);
    final typoIndex = prefs.getInt(_keyTypographyStyle);
    final showSolar = prefs.getBool(_keyShowSolarTerms);
    final showZodiac = prefs.getBool(_keyShowZodiacHours);
    final showYear = prefs.getBool(_keyShowYearInfo);

    _config = WidgetConfig(
      backgroundColor: bgValue != null ? Color(bgValue) : const Color(0xFFFAF8F3),
      textColor: textValue != null ? Color(textValue) : const Color(0xFF2D2D2D),
      gradientEndColor: gradientValue != null ? Color(gradientValue) : const Color(0xFFE8998D),
      borderRadius: radius ?? 16.0,
      widgetType: typeIndex != null ? WidgetType.values[typeIndex] : WidgetType.digitalClock,
      backgroundType: bgTypeIndex != null ? BackgroundType.values[bgTypeIndex] : BackgroundType.solid,
      typographyStyle: typoIndex != null ? TypographyStyle.values[typoIndex] : TypographyStyle.modern,
      showSolarTerms: showSolar ?? true,
      showZodiacHours: showZodiac ?? true,
      showYearInfo: showYear ?? true,
    );
    notifyListeners();
  }

  Future<void> saveConfig({LunarDate? lunarDate}) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(_keyBgColor, _config.backgroundColor.toARGB32()),
      prefs.setInt(_keyTextColor, _config.textColor.toARGB32()),
      prefs.setInt(_keyGradientEndColor, _config.gradientEndColor.toARGB32()),
      prefs.setDouble(_keyBorderRadius, _config.borderRadius),
      prefs.setInt(_keyWidgetType, _config.widgetType.index),
      prefs.setInt(_keyBackgroundType, _config.backgroundType.index),
      prefs.setInt(_keyTypographyStyle, _config.typographyStyle.index),
      prefs.setBool(_keyShowSolarTerms, _config.showSolarTerms),
      prefs.setBool(_keyShowZodiacHours, _config.showZodiacHours),
      prefs.setBool(_keyShowYearInfo, _config.showYearInfo),
    ]);

    if (lunarDate != null) {
      await WidgetDataSyncService.syncAll(lunarDate, _config);
    } else {
      await WidgetDataSyncService.syncConfig(_config);
      await WidgetDataSyncService.updateWidget();
    }
  }

  void updateWidgetType(WidgetType type) {
    _config = _config.copyWith(widgetType: type);
    notifyListeners();
  }

  void updateBackgroundColor(Color color) {
    _config = _config.copyWith(backgroundColor: color);
    notifyListeners();
  }

  void updateTextColor(Color color) {
    _config = _config.copyWith(textColor: color);
    notifyListeners();
  }

  void updateGradientEndColor(Color color) {
    _config = _config.copyWith(gradientEndColor: color);
    notifyListeners();
  }

  void updateBorderRadius(double radius) {
    _config = _config.copyWith(borderRadius: radius);
    notifyListeners();
  }

  void updateBackgroundType(BackgroundType type) {
    _config = _config.copyWith(backgroundType: type);
    notifyListeners();
  }

  void updateTypographyStyle(TypographyStyle style) {
    _config = _config.copyWith(typographyStyle: style);
    notifyListeners();
  }

  void updateShowSolarTerms(bool value) {
    _config = _config.copyWith(showSolarTerms: value);
    notifyListeners();
  }

  void updateShowZodiacHours(bool value) {
    _config = _config.copyWith(showZodiacHours: value);
    notifyListeners();
  }

  void updateShowYearInfo(bool value) {
    _config = _config.copyWith(showYearInfo: value);
    notifyListeners();
  }
}
