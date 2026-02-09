import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:widgetin/providers/lunar_calendar_provider.dart';
import 'package:widgetin/screens/home_shell.dart';

Widget createTestApp() {
  return ChangeNotifierProvider(
    create: (_) => LunarCalendarProvider()..loadToday(),
    child: const MaterialApp(home: HomeShell()),
  );
}

void main() {
  group('HomeShell', () {
    testWidgets('shows bottom navigation with 2 tabs', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Dashboard tab is selected by default', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      expect(find.text('Your Widgets'), findsOneWidget);
    });

    testWidgets('tapping Settings tab shows settings screen', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('About Widgetin'), findsOneWidget);
      expect(find.text('Licenses'), findsOneWidget);
    });

    testWidgets('tapping back to Dashboard shows widget gallery', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('Your Widgets'), findsOneWidget);
    });
  });
}
