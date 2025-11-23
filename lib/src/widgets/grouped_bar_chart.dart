import 'dart:math' as math;
import 'package:flutter/material.dart';

class GroupedBarChart extends StatelessWidget {
  final List<double> values1;
  final List<double> values2;
  final List<String> labels;
  final Color color1;
  final Color color2;
  final String legend1;
  final String legend2;

  const GroupedBarChart({
    super.key,
    required this.values1,
    required this.values2,
    required this.labels,
    this.color1 = Colors.purple,
    this.color2 = Colors.pink,
    required this.legend1,
    required this.legend2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Leyenda
        Row(
          children: [
            Container(width: 12, height: 12, color: color1),
            const SizedBox(width: 4),
            Text(legend1, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 16),
            Container(width: 12, height: 12, color: color2),
            const SizedBox(width: 4),
            Text(legend2, style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (values1.isEmpty) return const SizedBox();

              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              // Calcular máximo global
              final max1 = values1.reduce(math.max);
              final max2 = values2.reduce(math.max);
              final maxVal = math.max(max1, max2);
              final safeMax = maxVal == 0 ? 100.0 : maxVal * 1.1;

              final barGroupWidth = width / values1.length;
              final barWidth = barGroupWidth * 0.3;
              final spacing = barGroupWidth * 0.1;

              return CustomPaint(
                size: Size(width, height),
                painter: _GroupedBarPainter(
                  values1: values1,
                  values2: values2,
                  labels: labels,
                  color1: color1,
                  color2: color2,
                  maxVal: safeMax,
                  barWidth: barWidth,
                  spacing: spacing,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GroupedBarPainter extends CustomPainter {
  final List<double> values1;
  final List<double> values2;
  final List<String> labels;
  final Color color1;
  final Color color2;
  final double maxVal;
  final double barWidth;
  final double spacing;

  _GroupedBarPainter({
    required this.values1,
    required this.values2,
    required this.labels,
    required this.color1,
    required this.color2,
    required this.maxVal,
    required this.barWidth,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = color1;
    final paint2 = Paint()..color = color2;
    final paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    final bottomMargin = 30.0;
    final leftMargin = 30.0;
    final chartHeight = size.height - bottomMargin;
    final chartWidth = size.width - leftMargin;

    // Grid
    final gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      final y = chartHeight - (chartHeight / gridLines) * i;
      canvas.drawLine(Offset(leftMargin, y), Offset(size.width, y), paintGrid);

      final val = (maxVal / gridLines) * i;
      final text = val >= 1000
          ? '${(val / 1000).toStringAsFixed(0)}k'
          : val.toStringAsFixed(0);
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(leftMargin - tp.width - 4, y - tp.height / 2));
    }

    final groupWidth = chartWidth / values1.length;

    for (int i = 0; i < values1.length; i++) {
      final xCenter = leftMargin + (groupWidth * i) + (groupWidth / 2);

      // Barra 1
      final h1 = (values1[i] / maxVal) * chartHeight;
      final r1 = Rect.fromLTWH(
        xCenter - barWidth - spacing / 2,
        chartHeight - h1,
        barWidth,
        h1,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(r1, const Radius.circular(4)),
        paint1,
      );

      // Barra 2
      final h2 = (values2[i] / maxVal) * chartHeight;
      final r2 = Rect.fromLTWH(
        xCenter + spacing / 2,
        chartHeight - h2,
        barWidth,
        h2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(r2, const Radius.circular(4)),
        paint2,
      );

      // Label
      if (i < labels.length) {
        final tp = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(xCenter - tp.width / 2, chartHeight + 8));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
