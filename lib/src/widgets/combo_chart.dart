import 'dart:math' as math;
import 'package:flutter/material.dart';

class ComboChart extends StatefulWidget {
  final List<double> barValues;
  final List<double> lineValues;
  final List<String> labels;
  final Color barColor;
  final Color lineColor;
  final String? barLegend;
  final String? lineLegend;

  const ComboChart({
    super.key,
    required this.barValues,
    required this.lineValues,
    required this.labels,
    this.barColor = Colors.purple,
    this.lineColor = Colors.grey,
    this.barLegend,
    this.lineLegend,
  });

  @override
  State<ComboChart> createState() => _ComboChartState();
}

class _ComboChartState extends State<ComboChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.barLegend != null || widget.lineLegend != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                if (widget.barLegend != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 12, height: 12, color: widget.barColor),
                      const SizedBox(width: 4),
                      Text(
                        widget.barLegend!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                if (widget.lineLegend != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 12, height: 2, color: widget.lineColor),
                      const SizedBox(width: 4),
                      Text(
                        widget.lineLegend!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        Expanded(
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              return CustomPaint(
                painter: _ComboChartPainter(
                  barValues: widget.barValues,
                  lineValues: widget.lineValues,
                  labels: widget.labels,
                  barColor: widget.barColor,
                  lineColor: widget.lineColor,
                  progress: _anim.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ComboChartPainter extends CustomPainter {
  final List<double> barValues;
  final List<double> lineValues;
  final List<String> labels;
  final Color barColor;
  final Color lineColor;
  final double progress;

  _ComboChartPainter({
    required this.barValues,
    required this.lineValues,
    required this.labels,
    required this.barColor,
    required this.lineColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final len = math.max(barValues.length, lineValues.length);
    if (len == 0) return;

    // Calcular rangos
    double minVal = 0;
    double maxVal = 0;
    for (final v in barValues) {
      if (v < minVal) minVal = v;
      if (v > maxVal) maxVal = v;
    }
    for (final v in lineValues) {
      if (v < minVal) minVal = v;
      if (v > maxVal) maxVal = v;
    }

    // Margen para que no toque los bordes
    final range = maxVal - minVal;
    final safeRange = range == 0 ? (maxVal == 0 ? 100.0 : maxVal) : range;
    final chartMin = minVal - (safeRange * 0.1);
    final chartMax = maxVal + (safeRange * 0.1);
    final chartRange = chartMax - chartMin;

    final bottomPadding = 30.0;
    final leftPadding = 40.0;
    final chartHeight = size.height - bottomPadding;
    final chartWidth = size.width - leftPadding;

    // Grid y Ejes
    final paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    final gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      final y = chartHeight - (chartHeight / gridLines) * i;
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), paintGrid);

      // Etiquetas Eje Y
      final val = chartMin + (chartRange / gridLines) * i;
      final text = val >= 1000
          ? '${(val / 1000).toStringAsFixed(0)}k'
          : val.toStringAsFixed(0);

      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(leftPadding - tp.width - 4, y - tp.height / 2));
    }

    // Barras
    final barWidth = (chartWidth / len) * 0.4;
    final stepX = chartWidth / len;
    final paintBar = Paint()..color = barColor;

    for (int i = 0; i < barValues.length; i++) {
      final val = barValues[i] * progress;
      // Normalizar valor entre 0 y 1 relativo al rango del chart
      final normalized = (val - chartMin) / chartRange;
      final h = normalized * chartHeight;

      // Base line (0)
      final zeroNormalized = (0 - chartMin) / chartRange;
      final zeroY = chartHeight - (zeroNormalized * chartHeight);

      final x = leftPadding + (stepX * i) + (stepX / 2);

      // Dibujar desde 0 hacia arriba o abajo
      final top = chartHeight - h;

      // Rect desde zeroY hasta top
      final rect = Rect.fromLTRB(
        x - barWidth / 2,
        math.min(zeroY, top),
        x + barWidth / 2,
        math.max(zeroY, top),
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paintBar,
      );

      // Etiquetas Eje X
      if (i < labels.length) {
        final tp = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(x - tp.width / 2, chartHeight + 8));
      }
    }

    // Línea
    if (lineValues.isNotEmpty) {
      final paintLine = Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final paintDot = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;

      final path = Path();

      for (int i = 0; i < lineValues.length; i++) {
        final val = lineValues[i] * progress;
        final normalized = (val - chartMin) / chartRange;
        final y = chartHeight - (normalized * chartHeight);
        final x = leftPadding + (stepX * i) + (stepX / 2);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          // Curva suave
          final prevX = leftPadding + (stepX * (i - 1)) + (stepX / 2);
          final prevVal = lineValues[i - 1] * progress;
          final prevNorm = (prevVal - chartMin) / chartRange;
          final prevY = chartHeight - (prevNorm * chartHeight);

          final controlX1 = prevX + (x - prevX) / 2;
          final controlX2 = prevX + (x - prevX) / 2;

          path.cubicTo(controlX1, prevY, controlX2, y, x, y);
        }
      }

      canvas.drawPath(path, paintLine);

      // Puntos
      for (int i = 0; i < lineValues.length; i++) {
        final val = lineValues[i] * progress;
        final normalized = (val - chartMin) / chartRange;
        final y = chartHeight - (normalized * chartHeight);
        final x = leftPadding + (stepX * i) + (stepX / 2);
        canvas.drawCircle(Offset(x, y), 3, paintDot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ComboChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
