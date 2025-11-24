import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplicativo_01/src/pages/competencia_page_v2.dart';

void main() {
  testWidgets('Navigate to FinanzasPage from CompetenciaPage', (
    WidgetTester tester,
  ) async {
    try {
      // Set surface size to a typical mobile size to catch layout overflows
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;

      await tester.pumpWidget(const MaterialApp(home: CompetenciaPage()));
      await tester.pumpAndSettle();

      // Verify we start at CEO role
      expect(find.text('CEO'), findsOneWidget);

      // Open Dropdown
      await tester.tap(find.text('CEO'));
      await tester.pumpAndSettle();

      // Select Finanzas
      await tester.tap(find.text('Finanzas').last);
      await tester.pumpAndSettle();

      // Verify FinanzasPage content is present
      expect(find.text('EBITDA'), findsOneWidget);
      expect(find.text('Ingresos Totales'), findsOneWidget);
    } catch (e, st) {
      print('TEST_EXCEPTION: $e');
      print('STACK_TRACE: $st');
      rethrow;
    }
  });

  testWidgets('Navigate to DirectorComprasPage from CompetenciaPage', (
    WidgetTester tester,
  ) async {
    try {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;

      await tester.pumpWidget(const MaterialApp(home: CompetenciaPage()));
      await tester.pumpAndSettle();

      // Open Dropdown
      await tester.tap(find.text('CEO'));
      await tester.pumpAndSettle();

      // Select Director de Compras
      await tester.tap(find.text('Director de Compras').last);
      await tester.pumpAndSettle();

      // Verify DirectorComprasPage content is present
      expect(find.text('Ratio Compras Totales'), findsOneWidget);
    } catch (e, st) {
      print('TEST_EXCEPTION: $e');
      print('STACK_TRACE: $st');
      rethrow;
    }
  });
}
