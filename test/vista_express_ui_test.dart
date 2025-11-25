import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplicativo_01/src/pages/vista_express_page.dart';
import 'package:aplicativo_01/src/widgets/vista_express_widgets.dart';
import 'package:aplicativo_01/src/services/app_state.dart';

void main() {
  setUpAll(() async {
    // Mock AppState values directly since we can't easily initialize the full service in test
    AppState.instance.isLoading.value = false;
    AppState.instance.metrics.value = {
      'ingresos_totales': 5800.20,
      'gastos_totales': 2649.50,
    };
  });

  testWidgets('VistaExpressPage renders new design elements', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(const MaterialApp(home: VistaExpressPage()));
    await tester.pumpAndSettle();

    // Verify Header
    expect(find.text('Resumen Semanal'), findsOneWidget);
    expect(find.text('18 - 24 Nov'), findsOneWidget);

    // Verify BalanceCard
    expect(find.byType(BalanceCard), findsOneWidget);
    expect(find.text('Balance de la Semana'), findsOneWidget);

    // Verify MiniChartCards
    expect(find.byType(MiniChartCard), findsNWidgets(2));
    expect(find.text('Ingresos'), findsOneWidget);
    expect(find.text('Gastos'), findsOneWidget);

    // Verify TransactionList
    expect(find.text('Transacciones Recientes'), findsOneWidget);
    expect(find.byType(TransactionItem), findsNWidgets(3));
    expect(find.text('Venta TPV'), findsOneWidget);
    expect(find.text('Pedido a proveedor'), findsOneWidget);

    // Verify Buttons
    expect(find.text('Añadir'), findsNWidgets(2));
  });
}
