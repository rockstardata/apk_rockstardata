import 'package:flutter/material.dart';
import '../widgets/stacked_bar_chart.dart';
import '../services/app_state.dart';
import '../widgets/loading_widget.dart';

class ResultadoSemanalView extends StatelessWidget {
  const ResultadoSemanalView({super.key});

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
            final ingresos = metrics['ingresos_totales'] ?? 4850.75;
            final gastos = metrics['gastos_totales'] ?? 1920.40;
            final beneficio = ingresos - gastos;

            return Container(
              color: Colors.grey[50],
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Resultado Semanal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Semana: 15-19 Mayo',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF6200EE),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: Color(0xFF6200EE),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _kpiCard(
                              'Ingresos Totales',
                              '€${ingresos.toStringAsFixed(2)}',
                              const Color(0xFF2EB872),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _kpiCard(
                              'Gastos Totales',
                              '€${gastos.toStringAsFixed(2)}',
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _kpiCard(
                        'Beneficio',
                        '€${beneficio.toStringAsFixed(2)}',
                        Colors.black,
                      ),
                      const SizedBox(height: 24),
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
                              'Ingresos vs. Gastos Diarios',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: ValueListenableBuilder<List<double>>(
                                valueListenable:
                                    AppState.instance.ingresosDiarios,
                                builder: (context, ingresosDiarios, _) {
                                  final incomeValues =
                                      ingresosDiarios.isNotEmpty
                                      ? ingresosDiarios
                                      : [
                                          500.0,
                                          600.0,
                                          400.0,
                                          700.0,
                                          800.0,
                                          900.0,
                                          1000.0,
                                        ];

                                  final expenseValues = [
                                    200.0,
                                    300.0,
                                    250.0,
                                    350.0,
                                    400.0,
                                    450.0,
                                    500.0,
                                  ];

                                  return StackedBarChart(
                                    incomeValues: incomeValues,
                                    expenseValues: expenseValues,
                                    labels: const [
                                      'L',
                                      'M',
                                      'X',
                                      'J',
                                      'V',
                                      'S',
                                      'D',
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Productos Estrella de la Semana',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _productCard(
                        'Mejora Clásico',
                        '+€1,218.00',
                        true,
                        Icons.local_drink,
                      ),
                      const SizedBox(height: 8),
                      _productCard(
                        'Tabla de Ibéricos',
                        '+€1,064.00',
                        true,
                        Icons.restaurant,
                      ),
                      const SizedBox(height: 8),
                      _productCard(
                        'Cerveza Alhambra',
                        '+€930.00',
                        true,
                        Icons.sports_bar,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Transacciones Relevantes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _transactionItem(
                        'Pago a proveedor',
                        'Distribuciones Sur',
                        '18 Mayo',
                        '-€880.20',
                        false,
                      ),
                      const SizedBox(height: 8),
                      _transactionItem(
                        'Ingreso evento',
                        'Fiesta Privada',
                        '17 Mayo',
                        '+€1,800.00',
                        true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Exportar Reporte',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

  Widget _kpiCard(String title, String value, Color valueColor) {
    return Container(
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
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(
    String name,
    String value,
    bool isPositive,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6200EE).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF6200EE), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPositive ? const Color(0xFF2EB872) : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionItem(
    String title,
    String subtitle,
    String date,
    String amount,
    bool isIncome,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome
                  ? const Color(0xFF2EB872).withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? const Color(0xFF2EB872) : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome ? const Color(0xFF2EB872) : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
