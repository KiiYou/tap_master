import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('tap master app shows splash first', (WidgetTester tester) async {
    await tester.pumpWidget(const TapMasterApp());

    expect(find.text('Tap Master'), findsOneWidget);
    expect(find.text('Tap fast. Beat your best.'), findsOneWidget);
  });
}
