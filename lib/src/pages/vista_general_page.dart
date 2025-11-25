import 'package:flutter/material.dart';
import '../widgets/animated_donut_chart.dart';
import '../widgets/simple_line_chart.dart';
import '../services/app_state.dart';
import '../widgets/loading_widget.dart';

class VistaGeneralPage extends StatelessWidget {
  const VistaGeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.instance.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const LoadingWidget(message: 'Cargando datos...');
        }

        return ValueListenableBuilder<Map<String, double>>(
          valueListenable: AppState.instance.metrics,
          builder: (context, metrics, _) {
            final ingresos = metrics['ingresos_totales'] ?? 12500.0;
            final gastos = metrics['gastos_totales'] ?? 7800.0;
            final operativoNeto = ingresos - gastos;
            final beneficioDiario = operativoNeto / 7;

            return Container(
              color: Colors.grey[50],
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vista General',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // KPIs
                      _kpiCard('Ingresos Totales', ingresos),
                      const SizedBox(height: 12),
                      _kpiCard('Gastos Totales', gastos),
                      const SizedBox(height: 12),
                      _kpiCard('Operativo Neto', operativoNeto),
                      const SizedBox(height: 12),
                      _kpiCard('Beneficio Diario', beneficioDiario),

                      const SizedBox(height: 24),

                      // Line Chart
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Evolución',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Sem 1',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Sem 2',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Sem 3',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Sem 4',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 150,
                              child: ValueListenableBuilder<List<double>>(
                                valueListenable:
                                    AppState.instance.ingresosDiarios,
                                builder: (context, ingresosDiarios, _) {
                                  final points = ingresosDiarios.isNotEmpty
                                      ? ingresosDiarios
                                      : [
                                          500.0,
                                          800.0,
                                          600.0,
                                          900.0,
                                          700.0,
                                          1000.0,
                                          850.0,
                                        ];
                                  return SimpleLineChart(
                                    points: points,
                                    color: const Color(0xFF6200EE),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Donut Chart
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Desglose de Gastos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: AnimatedDonutChart(
                                totalValue: gastos,
                                segments: [
                                  DonutSegment(
                                    label: 'Proveedores',
                                    value: 3120.0,
                                    color: const Color(0xFF9C27B0),
                                  ),
                                  DonutSegment(
                                    label: 'Personal',
                                    value: 2940.0,
                                    color: const Color(0xFF2196F3),
                                  ),
                                  DonutSegment(
                                    label: 'Alquiler',
                                    value: 1080.0,
                                    color: const Color(0xFFFF9800),
                                  ),
                                  DonutSegment(
                                    label: 'Otros',
                                    value: 660.0,
                                    color: const Color(0xFF4CAF50),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Expense List
                            _expenseItem(
                              'Proveedores',
                              3120.0,
                              const Color(0xFF9C27B0),
                            ),
                            const SizedBox(height: 8),
                            _expenseItem(
                              'Personal',
                              2940.0,
                              const Color(0xFF2196F3),
                            ),
                            const SizedBox(height: 8),
                            _expenseItem(
                              'Alquiler',
                              1080.0,
                              const Color(0xFFFF9800),
                            ),
                            const SizedBox(height: 8),
                            _expenseItem(
                              'Otros',
                              660.0,
                              const Color(0xFF4CAF50),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _kpiCard(String title, double value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            '${value.toStringAsFixed(0)} €',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _expenseItem(String label, double value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        Text(
          '${value.toStringAsFixed(0)}€',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
