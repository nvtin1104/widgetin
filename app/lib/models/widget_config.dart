import 'dart:ui';

import 'widget_type.dart';

class WidgetConfig {
  // Layer 1
  final WidgetType widgetType;

  // Layer 2: Colors
  final Color backgroundColor;
  final Color textColor;
  final Color gradientEndColor;
  final double borderRadius;

  // Layer 2: Style
  final BackgroundType backgroundType;
  final TypographyStyle typographyStyle;

  // Layer 2: Visibility toggles
  final bool showSolarTerms;
  final bool showZodiacHours;
  final bool showYearInfo;

  const WidgetConfig({
    this.widgetType = WidgetType.digitalClock,
    this.backgroundColor = const Color(0xFFFAF8F3),
    this.textColor = const Color(0xFF2D2D2D),
    this.gradientEndColor = const Color(0xFFE8998D),
    this.borderRadius = 16.0,
    this.backgroundType = BackgroundType.solid,
    this.typographyStyle = TypographyStyle.modern,
    this.showSolarTerms = true,
    this.showZodiacHours = true,
    this.showYearInfo = true,
  });

  WidgetConfig copyWith({
    WidgetType? widgetType,
    Color? backgroundColor,
    Color? textColor,
    Color? gradientEndColor,
    double? borderRadius,
    BackgroundType? backgroundType,
    TypographyStyle? typographyStyle,
    bool? showSolarTerms,
    bool? showZodiacHours,
    bool? showYearInfo,
  }) {
    return WidgetConfig(
      widgetType: widgetType ?? this.widgetType,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      gradientEndColor: gradientEndColor ?? this.gradientEndColor,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundType: backgroundType ?? this.backgroundType,
      typographyStyle: typographyStyle ?? this.typographyStyle,
      showSolarTerms: showSolarTerms ?? this.showSolarTerms,
      showZodiacHours: showZodiacHours ?? this.showZodiacHours,
      showYearInfo: showYearInfo ?? this.showYearInfo,
    );
  }

  @override
  String toString() {
    return 'WidgetConfig(type: $widgetType, bg: $backgroundType, font: $typographyStyle)';
  }
}
