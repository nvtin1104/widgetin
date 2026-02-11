/// Layer 1: Functional widget types
enum WidgetType {
  digitalClock,
  textBased,
  moonPhase,
  hybridCalendar;

  String get displayName {
    switch (this) {
      case WidgetType.digitalClock:
        return 'Đồng Hồ';
      case WidgetType.textBased:
        return 'Chữ';
      case WidgetType.moonPhase:
        return 'Trăng';
      case WidgetType.hybridCalendar:
        return 'Lịch';
    }
  }

  String get description {
    switch (this) {
      case WidgetType.digitalClock:
        return 'Giờ số kèm ngày âm lịch';
      case WidgetType.textBased:
        return 'Văn bản tối giản';
      case WidgetType.moonPhase:
        return 'Pha trăng với giờ';
      case WidgetType.hybridCalendar:
        return 'Lịch kết hợp số và chữ';
    }
  }
}

/// Layer 2: Background style
enum BackgroundType {
  solid,
  gradient,
  transparent;

  String get displayName {
    switch (this) {
      case BackgroundType.solid:
        return 'Đơn sắc';
      case BackgroundType.gradient:
        return 'Chuyển màu';
      case BackgroundType.transparent:
        return 'Trong suốt';
    }
  }
}

/// Layer 2: Typography style
enum TypographyStyle {
  modern,
  classic,
  calligraphy;

  String get displayName {
    switch (this) {
      case TypographyStyle.modern:
        return 'Hiện đại';
      case TypographyStyle.classic:
        return 'Cổ điển';
      case TypographyStyle.calligraphy:
        return 'Thư pháp';
    }
  }

  /// Google Font family name for each style
  String get googleFontFamily {
    switch (this) {
      case TypographyStyle.modern:
        return 'Be Vietnam Pro';
      case TypographyStyle.classic:
        return 'Noto Serif';
      case TypographyStyle.calligraphy:
        return 'Dancing Script';
    }
  }
}
