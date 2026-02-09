import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/screens/settings_screen.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets('shows Settings header', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SettingsScreen())),
      );
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows Theme list tile', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SettingsScreen())),
      );
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
    });

    testWidgets('shows About Widgetin list tile', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SettingsScreen())),
      );
      expect(find.text('About Widgetin'), findsOneWidget);
    });

    testWidgets('shows Licenses list tile', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SettingsScreen())),
      );
      expect(find.text('Licenses'), findsOneWidget);
    });

    testWidgets('tapping About shows dialog', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SettingsScreen())),
      );
      await tester.tap(find.text('About Widgetin'));
      await tester.pumpAndSettle();
      expect(find.text('1.0.0'), findsOneWidget);
      expect(find.text('Vietnamese Lunar Calendar Widget'), findsOneWidget);
    });
  });
}
