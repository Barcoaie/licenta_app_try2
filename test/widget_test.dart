// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:licenta_app_try2/main.dart';

/*void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
*/

void main() {
  testWidgets('Should find the empty container', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    //verify image container is empty
    expect(find.text('No image selected yet!'), findsOneWidget);
    expect(find.text('random label'), findsNothing);
  });

  testWidgets('Should find the elevated buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}
