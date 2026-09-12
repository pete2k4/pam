import 'package:flutter_test/flutter_test.dart';
import 'package:laborator_1/main.dart';

void main() {
  testWidgets('currency converter renders controls', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Currency Converter'), findsOneWidget);
    expect(find.text('Suma'), findsOneWidget);
    expect(find.text('Moneda sursă'), findsOneWidget);
    expect(find.text('Moneda destinație'), findsOneWidget);
    expect(find.text('Conversie'), findsOneWidget);
  });
}