import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:widgetin/app.dart';
import 'package:widgetin/providers/lunar_calendar_provider.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LunarCalendarProvider()..loadToday(),
        child: const WidgetinApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Your Widgets'), findsOneWidget);
  });
}
