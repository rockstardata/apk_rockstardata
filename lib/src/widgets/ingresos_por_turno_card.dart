import 'package:flutter/material.dart';
import './simple_bar_chart.dart';

class IngresosPorTurnoCard extends StatelessWidget {
  final List<double> values;

  const IngresosPorTurnoCard({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ingresos por turno',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (values.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${values.fold<double>(0, (a, b) => a + b).toStringAsFixed(0)} €',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Mejor turno: ${values.indexOf(values.reduce((a, b) => a > b ? a : b)) == 0
                          ? "Desayuno"
                          : values.indexOf(values.reduce((a, b) => a > b ? a : b)) == 1
                          ? "Almuerzo"
                          : "Cena"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              // Asegurar que el gráfico tenga altura suficiente
              SizedBox(
                height: 180,
                width: double.infinity,
                child: SimpleBarChart(
                  values: values.isNotEmpty ? values : [0, 0, 0],
                  labels: const ['Desayuno', 'Almuerzo', 'Cena'],
                  color: const Color(0xFFFFA726),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Origen de los ingresos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              // Mostrar resumen de ingresos por turno como alternativa
              if (values.isNotEmpty)
                Column(
                  children: List.generate(values.length, (index) {
                    final labels = const ['Desayuno', 'Almuerzo', 'Cena'];
                    final colors = [
                      const Color(0xFFFFA726),
                      const Color(0xFFFF6B35),
                      const Color(0xFF4ECDC4),
                    ];
                    final total = values.fold<double>(0, (a, b) => a + b);
                    final percentage = total > 0
                        ? (values[index] / total * 100)
                        : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: colors[index % colors.length],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              labels[index],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '${values[index].toStringAsFixed(0)} €',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${percentage.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                )
              else
                const Icon(Icons.pie_chart, size: 64, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
