import 'package:flutter_test/flutter_test.dart';

import 'package:estudy/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const EStudyApp());
    // Pump a single frame — don't use pumpAndSettle as the splash has perpetual animations
    await tester.pump();

    expect(find.byType(EStudyApp), findsOneWidget);
  });
}
