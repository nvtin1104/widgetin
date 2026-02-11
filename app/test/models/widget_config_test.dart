import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/models/widget_config.dart';
import 'package:widgetin/models/widget_type.dart';

void main() {
  group('WidgetConfig', () {
    test('has correct defaults', () {
      const config = WidgetConfig();
      expect(config.widgetType, WidgetType.digitalClock);
      expect(config.backgroundType, BackgroundType.solid);
      expect(config.typographyStyle, TypographyStyle.modern);
      expect(config.showSolarTerms, true);
      expect(config.showZodiacHours, true);
      expect(config.showYearInfo, true);
      expect(config.borderRadius, 16.0);
    });

    test('copyWith updates single field', () {
      const config = WidgetConfig();
      final updated = config.copyWith(widgetType: WidgetType.moonPhase);
      expect(updated.widgetType, WidgetType.moonPhase);
      expect(updated.backgroundType, BackgroundType.solid); // unchanged
    });

    test('copyWith updates multiple fields', () {
      const config = WidgetConfig();
      final updated = config.copyWith(
        backgroundType: BackgroundType.gradient,
        typographyStyle: TypographyStyle.calligraphy,
        showYearInfo: false,
      );
      expect(updated.backgroundType, BackgroundType.gradient);
      expect(updated.typographyStyle, TypographyStyle.calligraphy);
      expect(updated.showYearInfo, false);
      expect(updated.widgetType, WidgetType.digitalClock); // unchanged
    });

    test('copyWith preserves all fields when no args', () {
      const config = WidgetConfig(
        widgetType: WidgetType.textBased,
        backgroundColor: Color(0xFF000000),
        showSolarTerms: false,
      );
      final copy = config.copyWith();
      expect(copy.widgetType, WidgetType.textBased);
      expect(copy.backgroundColor, const Color(0xFF000000));
      expect(copy.showSolarTerms, false);
    });
  });

  group('WidgetType', () {
    test('has 4 values', () {
      expect(WidgetType.values.length, 4);
    });

    test('displayName is non-empty', () {
      for (final type in WidgetType.values) {
        expect(type.displayName.isNotEmpty, true);
      }
    });

    test('description is non-empty', () {
      for (final type in WidgetType.values) {
        expect(type.description.isNotEmpty, true);
      }
    });
  });

  group('BackgroundType', () {
    test('has 3 values', () {
      expect(BackgroundType.values.length, 3);
    });
  });

  group('TypographyStyle', () {
    test('has 3 values', () {
      expect(TypographyStyle.values.length, 3);
    });

    test('modern has Be Vietnam Pro font', () {
      expect(TypographyStyle.modern.googleFontFamily, 'Be Vietnam Pro');
    });

    test('classic has Noto Serif font', () {
      expect(TypographyStyle.classic.googleFontFamily, 'Noto Serif');
    });
  });
}
