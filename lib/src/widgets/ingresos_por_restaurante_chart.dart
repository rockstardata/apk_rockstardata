import 'package:flutter/material.dart';
import './simple_line_chart.dart';

class IngresosPorRestauranteChart extends StatelessWidget {
  final List<double> points;
  final double? height;

  const IngresosPorRestauranteChart({
    super.key,
    required this.points,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            SizedBox(
              height: height ?? 200, // Reducido ligeramente a 200 por defecto
              width: double.infinity,
              child: SimpleLineChart(
                points: points.isNotEmpty ? points : [0, 0, 0, 0, 0, 0, 0],
                color: const Color(0xFF8E24AA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
