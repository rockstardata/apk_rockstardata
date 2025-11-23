import 'package:flutter/material.dart';
import 'simple_pie_chart.dart';
import 'pie_legend.dart';

/// Gráfico de pastel para origen de ingresos
class OrigenIngresosPie extends StatelessWidget {
  final Map<String, double> origenes;
  final double total;

  const OrigenIngresosPie({
    super.key,
    required this.origenes,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay datos de origen, mostrar "Desconocido"
    final hasData = origenes.isNotEmpty && origenes.values.any((v) => v > 0);
    
    if (!hasData) {
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
        child: Column(
          children: [
            const Text(
              'Origen de los ingresos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              height: 180,
              child: SimplePieChart(
                values: [total],
                colors: [Colors.grey.shade400],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Desconocido: ${total.toStringAsFixed(0)} €',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final values = origenes.values.toList();
    final labels = origenes.keys.toList();
    final colors = [
      const Color(0xFF8E24AA), // Morado
      const Color(0xFFD81B60), // Rosa
      const Color(0xFFFFA726), // Naranja
      const Color(0xFF2EB872), // Verde
      Colors.blue,
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
      child: Column(
        children: [
          const Text(
            'Origen de los ingresos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            height: 180,
            child: SimplePieChart(
              values: values,
              colors: colors,
            ),
          ),
          const SizedBox(height: 12),
          PieLegend(
            labels: labels,
            values: values,
            colors: colors,
          ),
        ],
      ),
    );
  }
}

