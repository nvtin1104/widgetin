import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:widgetin/providers/lunar_calendar_provider.dart';
import 'package:widgetin/providers/widget_config_provider.dart';
import 'package:widgetin/screens/dashboard_screen.dart';

Widget createTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => LunarCalendarProvider()..loadToday(),
      ),
      ChangeNotifierProvider(
        create: (_) => WidgetConfigProvider(),
      ),
    ],
    child: const MaterialApp(
      home: Scaffold(body: DashboardScreen()),
    ),
  );
}

void main() {
  group('DashboardScreen', () {
    testWidgets('shows "Your Widgets" header', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      expect(find.text('Your Widgets'), findsOneWidget);
    });

    testWidgets('shows Lunar Calendar card', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      expect(find.text('Âm Lịch'), findsOneWidget);
      expect(find.text('Vietnamese Lunar Calendar'), findsOneWidget);
    });

    testWidgets('shows Customize button', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      expect(find.text('Customize'), findsOneWidget);
    });

    testWidgets('Customize button navigates to editor', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Customize'));
      await tester.pumpAndSettle();
      expect(find.text('Customize Widget'), findsOneWidget);
    });

    testWidgets('shows Can Chi year info', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      // Current year 2026 = Bính Ngọ
      expect(find.textContaining('Năm'), findsOneWidget);
    });

    testWidgets('shows Hoang Dao hours section', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      expect(find.text('Giờ Hoàng Đạo'), findsOneWidget);
    });

    testWidgets('shows loading indicator when provider has no data', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => LunarCalendarProvider(), // no loadToday
            ),
            ChangeNotifierProvider(
              create: (_) => WidgetConfigProvider(),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: DashboardScreen())),
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
