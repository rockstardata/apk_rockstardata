import 'package:flutter/material.dart';
import './simple_bar_chart.dart';

class IngresosPorDiaCard extends StatelessWidget {
  final List<double> values;

  const IngresosPorDiaCard({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresos por día',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            // Mostrar total de la semana
            if (values.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total semanal: ${values.fold<double>(0, (a, b) => a + b).toStringAsFixed(0)} €',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Promedio: ${(values.fold<double>(0, (a, b) => a + b) / values.length).toStringAsFixed(0)} €',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            // Gráfico optimizado para móviles Android
            SizedBox(
              height: 200, // Reducido ligeramente
              width: double.infinity,
              child: SimpleBarChart(
                values: values.isNotEmpty ? values : [0, 0, 0, 0, 0, 0, 0],
                labels: const ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
                color: const Color(0xFF2EB872),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
