import 'dart:math' as math;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatefulWidget {
  final List<double> values;
  final List<String>? labels;
  final Color color;
  final Duration duration;

  const SimpleBarChart({
    super.key,
    required this.values,
    this.labels,
    this.color = const Color(0xFFD81B60),
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  late List<double> _oldValues;
  late List<double> _newValues;

  @override
  void initState() {
    super.initState();
    final initial = widget.values.isNotEmpty
        ? widget.values
        : _generateMockValues(3);
    _oldValues = List<double>.from(initial);
    _newValues = List<double>.from(initial);
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant SimpleBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasNew = widget.values.isNotEmpty;
    final oldV = oldWidget.values.isNotEmpty ? oldWidget.values : _oldValues;
    final newV = hasNew ? widget.values : _generateMockValues(3);
    if (!_listEquals(oldV, newV)) {
      _oldValues = List<double>.from(oldV);
      _newValues = List<double>.from(newV);
      _ctrl.forward(from: 0.0);
    }
  }

  bool _listEquals(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<double> _generateMockValues(int n) {
    // Simple deterministic mock values (e.g., comida/cena or categories)
    final base = [1200.0, 2500.0, 800.0];
    if (n <= base.length) return base.sublist(0, n);
    return List<double>.generate(n, (i) => base[i % base.length]);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Optimizado para móviles Android - altura fija adecuada
        // Altura mínima garantizada para mostrar valores y etiquetas
        final minHeight = 200.0; // Altura fija para móviles

        return SizedBox(
          height: minHeight,
          width: width > 0 ? width : double.infinity,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              return FadeTransition(
                opacity: _anim,
                child: CustomPaint(
                  size: Size(width, minHeight),
                  painter: _BarChartPainter(
                    oldValues: _oldValues,
                    newValues: _newValues,
                    progress: _anim.value,
                    labels: widget.labels,
                    color: widget.color,
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

class _BarChartPainter extends CustomPainter {
  final List<double> oldValues;
  final List<double> newValues;
  final List<String>? labels;
  final double progress;
  final Color color;

  _BarChartPainter({
    required this.oldValues,
    required this.newValues,
    required this.progress,
    this.labels,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Validar tamaño
    if (size.width <= 0 || size.height <= 0) return;

    final valuesLen = oldValues.length > newValues.length
        ? oldValues.length
        : newValues.length;
    if (valuesLen == 0) return;

    final interp = List<double>.filled(valuesLen, 0.0);
    for (int i = 0; i < valuesLen; i++) {
      final o = i < oldValues.length ? oldValues[i] : 0.0;
      final n = i < newValues.length ? newValues[i] : 0.0;
      interp[i] = o + (n - o) * progress;
    }
    // Calcular máximo con margen para mejor visualización
    final maxVal = interp.isNotEmpty
        ? interp.reduce((a, b) => a > b ? a : b)
        : 0.0;

    final bool allZeros = maxVal == 0;

    // Si todos los valores son 0, usar un máximo por defecto para mostrar el gráfico
    final maxValWithMargin = maxVal > 0
        ? maxVal * 1.1
        : 1000.0; // Valor por defecto para que se vea el gráfico

    final paintBar = Paint()..color = color;
    final paintAxis = Paint()
      ..color = const Color.fromRGBO(158, 158, 158, 0.5)
      ..strokeWidth = 1.5;

    final paintGrid = Paint()
      ..color = const Color.fromRGBO(158, 158, 158, 0.2)
      ..strokeWidth = 0.5;

    // Espacio para etiquetas y valores - ajustado para pantallas pequeñas
    final labelHeight = size.height < 150 ? 25.0 : 30.0;
    final valueHeight = size.height < 150 ? 15.0 : 20.0;
    final bottomPadding = labelHeight;
    final topPadding = valueHeight + 10;
    final chartHeight = (size.height - bottomPadding - topPadding).clamp(
      50.0,
      double.infinity,
    );
    final chartTop = topPadding;

    // Validar que tenemos espacio suficiente
    if (chartHeight <= 0 || size.width <= 0) return;

    // Calcular ancho de cada barra
    final spacing = 6.0;
    final totalSpacing = (valuesLen + 1) * spacing;
    final availableWidth = (size.width - totalSpacing).clamp(
      0.0,
      double.infinity,
    );
    final barWidth = availableWidth > 0
        ? math.max(15.0, availableWidth / valuesLen)
        : 20.0;

    // Dibujar líneas de grid horizontales
    final gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = chartTop + (chartHeight / gridLines) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);

      // Etiquetas del eje Y
      if (maxVal > 0) {
        final value = maxValWithMargin - (maxValWithMargin / gridLines) * i;
        final textPainter = TextPainter(
          text: TextSpan(
            text: value < 1000
                ? '${value.toInt()}'
                : '${(value / 1000).toStringAsFixed(1)}k',
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(2, y - 6));
      }
    }

    // Eje horizontal
    canvas.drawLine(
      Offset(0, chartTop + chartHeight),
      Offset(size.width, chartTop + chartHeight),
      paintAxis,
    );

    // Dibujar barras
    for (int i = 0; i < interp.length; i++) {
      final xStart = spacing + i * (barWidth + spacing);
      final xCenter = xStart + barWidth / 2;

      // Validar posición
      if (xStart < 0 || xStart + barWidth > size.width) continue;

      // Calcular altura de la barra
      final rawH = maxValWithMargin > 0
          ? (interp[i] / maxValWithMargin) * chartHeight
          : 0.0;
      final h = rawH > 0 ? rawH.clamp(3.0, chartHeight) : 0.0;
      final top = chartTop + chartHeight - h;

      // Dibujar barra - siempre dibujar aunque sea pequeña para que sea visible
      if (h >= 0 && top >= chartTop && top + h <= chartTop + chartHeight) {
        final rect = Rect.fromLTWH(xStart, top, barWidth, h);
        final corner = math.min(
          4.0,
          math.min(barWidth / 2, math.max(h / 2, 2.0)),
        );
        final r = RRect.fromRectAndRadius(rect, Radius.circular(corner));
        canvas.drawRRect(r, paintBar);
      } else if (interp[i] == 0) {
        // Si es 0, dibujar una línea base pequeña para indicar presencia
        final rect = Rect.fromLTWH(
          xStart,
          chartTop + chartHeight - 2,
          barWidth,
          2,
        );
        canvas.drawRect(rect, paintBar);
      }

      // Mostrar valor encima de la barra
      if (interp[i] > 0) {
        final valueText = interp[i] < 1000
            ? '${interp[i].toInt()}'
            : '${(interp[i] / 1000).toStringAsFixed(1)}k';
        final valuePainter = TextPainter(
          text: TextSpan(
            text: valueText,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        valuePainter.layout();
        final valueY = top - 15;
        if (valueY > 0) {
          valuePainter.paint(
            canvas,
            Offset(xCenter - valuePainter.width / 2, valueY),
          );
        }
      }

      // Etiqueta del día
      if (labels != null && i < labels!.length) {
        final labelPainter = TextPainter(
          text: TextSpan(
            text: labels![i],
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        labelPainter.layout();
        labelPainter.paint(
          canvas,
          Offset(xCenter - labelPainter.width / 2, chartTop + chartHeight + 5),
        );
      }
    }

    if (allZeros) {
      final noDataPainter = TextPainter(
        text: const TextSpan(
          text: 'Sin datos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      noDataPainter.layout();
      noDataPainter.paint(
        canvas,
        Offset(
          size.width / 2 - noDataPainter.width / 2,
          chartTop + chartHeight / 2 - noDataPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.oldValues.length != oldValues.length ||
        oldDelegate.newValues.length != newValues.length;
  }
}
