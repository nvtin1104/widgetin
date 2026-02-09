import 'dart:ui';

class WidgetConfig {
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const WidgetConfig({
    this.backgroundColor = const Color(0xFFFAF8F3),
    this.textColor = const Color(0xFF2D2D2D),
    this.borderRadius = 16.0,
  });

  WidgetConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
  }) {
    return WidgetConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  String toString() {
    return 'WidgetConfig(bg: $backgroundColor, text: $textColor, radius: $borderRadius)';
  }
}
