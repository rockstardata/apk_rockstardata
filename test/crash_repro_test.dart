import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplicativo_01/src/pages/finanzas_page.dart';
import 'package:aplicativo_01/src/pages/director_compras_page.dart';

void main() {
  testWidgets('FinanzasPage renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FinanzasPage())),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FinanzasPage), findsOneWidget);
  });

  testWidgets('DirectorComprasPage renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DirectorComprasPage())),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DirectorComprasPage), findsOneWidget);
  });
}
