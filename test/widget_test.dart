import 'package:flutter_test/flutter_test.dart';

import 'package:pam/main.dart';

void main() {
  testWidgets('currency converter shows expected controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CurrencyConverterApp());

    expect(find.text('Convertor Valutar'), findsOneWidget);
    expect(find.text('Suma'), findsOneWidget);
    expect(find.text('Moneda sursă'), findsOneWidget);
    expect(find.text('Moneda destinație'), findsOneWidget);
    expect(find.text('Conversie'), findsOneWidget);
  });
}