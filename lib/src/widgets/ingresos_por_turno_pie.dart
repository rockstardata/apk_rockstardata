import 'package:flutter/material.dart';
import 'simple_pie_chart.dart';
import 'pie_legend.dart';

/// Gráfico de pastel para ingresos por turno
class IngresosPorTurnoPie extends StatelessWidget {
  final List<double> valores;
  final List<String> labels;

  const IngresosPorTurnoPie({
    super.key,
    required this.valores,
    this.labels = const ['Comida', 'Cena'],
  });

  @override
  Widget build(BuildContext context) {
    // El gráfico manejará el caso de total == 0 mostrando un placeholder

    final colors = [
      const Color(0xFFD81B60), // Rosa para Comida
      const Color(0xFF8E24AA), // Morado para Cena
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresos por turno',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              height: 180,
              child: SimplePieChart(values: valores, colors: colors),
            ),
            const SizedBox(height: 12),
            PieLegend(labels: labels, values: valores, colors: colors),
          ],
        ),
      ),
    );
  }
}
