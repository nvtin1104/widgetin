import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/widget_config.dart';

class WidgetConfigProvider extends ChangeNotifier {
  static const _keyBgColor = 'widget_bg_color';
  static const _keyTextColor = 'widget_text_color';
  static const _keyBorderRadius = 'widget_border_radius';

  WidgetConfig _config = const WidgetConfig();

  WidgetConfig get config => _config;

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final bgValue = prefs.getInt(_keyBgColor);
    final textValue = prefs.getInt(_keyTextColor);
    final radius = prefs.getDouble(_keyBorderRadius);

    _config = WidgetConfig(
      backgroundColor: bgValue != null ? Color(bgValue) : const Color(0xFFFAF8F3),
      textColor: textValue != null ? Color(textValue) : const Color(0xFF2D2D2D),
      borderRadius: radius ?? 16.0,
    );
    notifyListeners();
  }

  Future<void> saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyBgColor, _config.backgroundColor.toARGB32());
    await prefs.setInt(_keyTextColor, _config.textColor.toARGB32());
    await prefs.setDouble(_keyBorderRadius, _config.borderRadius);
  }

  void updateBackgroundColor(Color color) {
    _config = _config.copyWith(backgroundColor: color);
    notifyListeners();
  }

  void updateTextColor(Color color) {
    _config = _config.copyWith(textColor: color);
    notifyListeners();
  }

  void updateBorderRadius(double radius) {
    _config = _config.copyWith(borderRadius: radius);
    notifyListeners();
  }
}
