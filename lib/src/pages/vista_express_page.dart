import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/vista_express_widgets.dart';
import '../widgets/loading_widget.dart';

class VistaExpressPage extends StatelessWidget {
  const VistaExpressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      body: ValueListenableBuilder<bool>(
        valueListenable: AppState.instance.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const LoadingWidget(message: 'Cargando datos...');
          }

          return ValueListenableBuilder<Map<String, double>>(
            valueListenable: AppState.instance.metrics,
            builder: (context, metrics, _) {
              final ingresos = metrics['ingresos_totales'] ?? 0.0;
              final gastos = metrics['gastos_totales'] ?? 0.0;
              final balance = ingresos - gastos;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black, // Dark icon
                            size: 20,
                          ),
                          onPressed: () {}, // No action for now
                        ),
                        const Text(
                          'Resumen Semanal',
                          style: TextStyle(
                            color: Colors.black, // Dark text
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '18 - 24 Nov',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Balance Card
                    BalanceCard(
                      balance: balance,
                      percentageChange: 12.0, // Mocked for now
                    ),
                    const SizedBox(height: 16),

                    // Ingresos
                    MiniChartCard(
                      title: 'Ingresos',
                      value: ingresos,
                      percentageChange: 5.0,
                      lineColor: const Color(0xFF2EB872),
                      isPositiveChange: true,
                    ),
                    const SizedBox(height: 16),

                    // Gastos
                    MiniChartCard(
                      title: 'Gastos',
                      value: gastos,
                      percentageChange: 8.0,
                      lineColor: Colors.redAccent,
                      isPositiveChange:
                          false, // Increased expenses is usually "negative" but UI shows red +8%
                    ),
                    const SizedBox(height: 24),

                    // Transacciones Recientes
                    const Text(
                      'Transacciones Recientes',
                      style: TextStyle(
                        color: Colors.black, // Dark text
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TransactionItem(
                      title: 'Venta TPV',
                      subtitle: 'Ingreso',
                      amount: 250.00,
                      isIncome: true,
                    ),
                    const TransactionItem(
                      title: 'Pedido a proveedor',
                      subtitle: 'Gasto',
                      amount: 1120.45,
                      isIncome: false,
                    ),
                    const TransactionItem(
                      title: 'Venta en efectivo',
                      subtitle: 'Ingreso',
                      amount: 86.50,
                      isIncome: true,
                    ),

                    const SizedBox(height: 24),

                    // Bottom Buttons
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
