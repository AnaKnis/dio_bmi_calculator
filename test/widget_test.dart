import 'package:dio_bmi_calculator/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UI rendering test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });

  testWidgets('BMI Calculation test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}
