import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laborator_2/main.dart';

void main() {
  testWidgets('GemStore home and product navigation render', (tester) async {
    await tester.pumpWidget(const GemStoreApp());

    expect(find.text('GemStore'), findsOneWidget);
    expect(find.text('Women'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
    await tester.pumpAndSettle();

    expect(find.text('Feature Products'), findsOneWidget);
    await tester.tap(find.text('Turtleneck Sweater'));
    await tester.pumpAndSettle();

    expect(find.text('Sportwear Set'), findsOneWidget);
    expect(find.text('Add To Cart'), findsOneWidget);
  });
}
