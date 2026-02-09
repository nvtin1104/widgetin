import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:widgetin/app.dart';
import 'package:widgetin/providers/lunar_calendar_provider.dart';
import 'package:widgetin/providers/widget_config_provider.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LunarCalendarProvider()..loadToday(),
          ),
          ChangeNotifierProvider(
            create: (_) => WidgetConfigProvider(),
          ),
        ],
        child: const WidgetinApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Your Widgets'), findsOneWidget);
  });
}
