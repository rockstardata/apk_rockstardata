import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SimplePieChart extends StatefulWidget {
  final List<double> values;
  final List<Color>? colors;
  final Duration duration;

  const SimplePieChart({
    super.key,
    required this.values,
    this.colors,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  State<SimplePieChart> createState() => _SimplePieChartState();
}

class _SimplePieChartState extends State<SimplePieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  late List<double> _oldValues;
  late List<double> _newValues;

  @override
  void initState() {
    super.initState();
    final initial = widget.values.isNotEmpty ? widget.values : _mock();
    _oldValues = List<double>.from(initial);
    _newValues = List<double>.from(initial);
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant SimplePieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasNew = widget.values.isNotEmpty;
    final oldV = oldWidget.values.isNotEmpty ? oldWidget.values : _oldValues;
    final newV = hasNew ? widget.values : _mock();
    if (!_listEquals(oldV, newV)) {
      _oldValues = List<double>.from(oldV);
      _newValues = List<double>.from(newV);
      _ctrl.forward(from: 0.0);
    }
  }

  List<double> _mock() => [40.0, 30.0, 30.0];

  bool _listEquals(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) if (a[i] != b[i]) return false;
    return true;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        widget.colors ??
        [Colors.blue, Colors.orange, Colors.green, Colors.purple];
    return LayoutBuilder(
      builder: (context, constraints) {
        // Optimizado para móviles Android - tamaño fijo adecuado
        final availableWidth = constraints.maxWidth > 0
            ? constraints.maxWidth
            : 200.0;
        final chartSize = math.min(
          availableWidth - 32,
          180.0,
        ); // Máximo 180px para móviles

        return SizedBox(
          width: chartSize,
          height: chartSize,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              return FadeTransition(
                opacity: _anim,
                child: CustomPaint(
                  size: Size(chartSize, chartSize),
                  painter: _PiePainter(
                    progress: _anim.value,
                    oldValues: _oldValues,
                    newValues: _newValues,
                    colors: colors,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _PiePainter extends CustomPainter {
  final double progress;
  final List<double> oldValues;
  final List<double> newValues;
  final List<Color> colors;

  _PiePainter({
    required this.progress,
    required this.oldValues,
    required this.newValues,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.4;

    final maxLen = max(oldValues.length, newValues.length);
    if (maxLen == 0) return;

    final interp = List<double>.filled(maxLen, 0.0);
    for (int i = 0; i < maxLen; i++) {
      final o = i < oldValues.length ? oldValues[i] : 0.0;
      final n = i < newValues.length ? newValues[i] : 0.0;
      interp[i] = o + (n - o) * progress;
    }

    final total = interp.fold(0.0, (a, b) => a + b);

    // Si el total es 0, dibujar un placeholder
    if (total <= 0) {
      final paint = Paint()
        ..color = Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.5; // Donut grueso
      canvas.drawCircle(center, radius, paint);

      // Texto "0 €"
      final zeroPainter = TextPainter(
        text: const TextSpan(
          text: '0 €',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      zeroPainter.layout();
      zeroPainter.paint(
        canvas,
        Offset(
          center.dx - zeroPainter.width / 2,
          center.dy - zeroPainter.height / 2,
        ),
      );
      return;
    }

    final safeTotal = total;

    double startAngle = -pi / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (int i = 0; i < interp.length; i++) {
      final sweep = (interp[i] / safeTotal) * 2 * pi * progress;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweep, true, paint);
      startAngle += sweep;
    }

    // draw inner circle for donut effect
    final holePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, holePaint);

    // Mostrar total en el centro
    if (total > 0) {
      final totalText = total < 1000
          ? '${total.toInt()}'
          : '${(total / 1000).toStringAsFixed(1)}k';
      final totalPainter = TextPainter(
        text: TextSpan(
          text: totalText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      totalPainter.layout();
      totalPainter.paint(
        canvas,
        Offset(center.dx - totalPainter.width / 2, center.dy - 12),
      );

      final euroPainter = TextPainter(
        text: const TextSpan(
          text: '€',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      euroPainter.layout();
      euroPainter.paint(
        canvas,
        Offset(center.dx - euroPainter.width / 2, center.dy + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.oldValues.length != oldValues.length ||
        oldDelegate.newValues.length != newValues.length;
  }
}
