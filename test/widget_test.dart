import 'package:flutter_test/flutter_test.dart';
import 'package:widgetin/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const WidgetinApp());
    expect(find.text('Widgetin'), findsOneWidget);
  });
}
