import 'package:flutter/material.dart';

class SimpleLineChart extends StatefulWidget {
  final List<double> points;
  final Color color;
  final Duration duration;

  const SimpleLineChart({
    super.key,
    required this.points,
    this.color = const Color(0xFF8E24AA),
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<SimpleLineChart> createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  late List<double> _oldPoints;
  late List<double> _newPoints;

  @override
  void initState() {
    super.initState();
    final initial = widget.points.isNotEmpty
        ? widget.points
        : _generateMockPoints(7);
    _oldPoints = List<double>.from(initial);
    _newPoints = List<double>.from(initial);
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant SimpleLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasNew = widget.points.isNotEmpty;
    final oldPts = oldWidget.points.isNotEmpty ? oldWidget.points : _oldPoints;
    final newPts = hasNew ? widget.points : _generateMockPoints(7);
    if (!_listEquals(oldPts, newPts)) {
      _oldPoints = List<double>.from(oldPts);
      _newPoints = List<double>.from(newPts);
      _ctrl.forward(from: 0.0);
    }
  }

  List<double> _generateMockPoints(int n) {
    // deterministic mock series that looks like a week trend
    final base = 1000.0;
    final deltas = [0, 300, -150, 500, 700, 200, -100];
    return List<double>.generate(
      n,
      (i) => (base + (i < deltas.length ? deltas[i] : 0)),
    );
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Optimizado para móviles Android - altura fija adecuada
        final height = 200.0; // Altura fija para móviles

        return SizedBox(
          height: height,
          width: width > 0 ? width : double.infinity,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              return FadeTransition(
                opacity: _anim,
                child: CustomPaint(
                  size: Size(width, height),
                  painter: _LineChartPainter(
                    oldPoints: _oldPoints,
                    newPoints: _newPoints,
                    progress: _anim.value,
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

class _LineChartPainter extends CustomPainter {
  final List<double> oldPoints;
  final List<double> newPoints;
  final double progress;
  final Color color;

  _LineChartPainter({
    required this.oldPoints,
    required this.newPoints,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Validar tamaño
    if (size.width <= 0 || size.height <= 0) return;

    final paintLine = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..color = Color.fromRGBO(color.red, color.green, color.blue, 0.12);

    final maxLen = oldPoints.length > newPoints.length
        ? oldPoints.length
        : newPoints.length;
    if (maxLen == 0) return;

    // build interpolated points
    final interp = List<double>.filled(maxLen, 0.0);
    for (int i = 0; i < maxLen; i++) {
      final o = i < oldPoints.length ? oldPoints[i] : 0.0;
      final n = i < newPoints.length ? newPoints[i] : 0.0;
      interp[i] = o + (n - o) * progress;
    }

    final maxVal = interp.isNotEmpty
        ? interp.reduce((a, b) => a > b ? a : b)
        : 0.0;
    final minVal = interp.isNotEmpty
        ? interp.reduce((a, b) => a < b ? a : b)
        : 0.0;
    // Asegurar un rango mínimo para que el gráfico se vea
    final range = (maxVal - minVal) == 0
        ? (maxVal > 0 ? maxVal : 1000.0)
        : (maxVal - minVal);

    final stepX = interp.length > 1
        ? size.width / (interp.length - 1)
        : 0.0; // Si hay 1 punto, stepX es 0 y se centrará después

    final path = Path();
    final fillPath = Path();

    // Margen superior e inferior para valores y etiquetas
    const topMargin = 30.0;
    const bottomMargin = 20.0;
    final chartHeight = size.height - topMargin - bottomMargin;

    for (int i = 0; i < interp.length; i++) {
      final x = stepX == 0.0 ? size.width / 2 : i * stepX;
      final normalized = (interp[i] - minVal) / range;
      final y = topMargin + chartHeight - (normalized * chartHeight);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, topMargin + chartHeight);
    fillPath.lineTo(0, topMargin + chartHeight);
    fillPath.close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);

    // Dibujar puntos y valores
    final paintDot = Paint()..color = color;
    final paintDotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < interp.length; i++) {
      final x = stepX == 0.0 ? size.width / 2 : i * stepX;
      final normalized = (interp[i] - minVal) / range;
      final y = topMargin + chartHeight - (normalized * chartHeight);

      // Validar que el punto esté dentro del área visible
      if (x >= 0 &&
          x <= size.width &&
          y >= topMargin &&
          y <= topMargin + chartHeight) {
        // Dibujar punto con borde
        canvas.drawCircle(Offset(x, y), 5.0, paintDot);
        canvas.drawCircle(Offset(x, y), 5.0, paintDotBorder);

        // Mostrar valor encima del punto
        final valueText = interp[i] < 1000
            ? '${interp[i].toInt()}'
            : '${(interp[i] / 1000).toStringAsFixed(1)}k';
        final valuePainter = TextPainter(
          text: TextSpan(
            text: valueText,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        valuePainter.layout();
        final valueY = y - 18;
        if (valueY > 0 && valueY < topMargin) {
          valuePainter.paint(
            canvas,
            Offset(x - valuePainter.width / 2, valueY),
          );
        }
      }
    }

    // Dibujar líneas de grid
    final paintGrid = Paint()
      ..color = const Color.fromRGBO(158, 158, 158, 0.2)
      ..strokeWidth = 0.5;
    final gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = topMargin + (chartHeight / gridLines) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final bool allZeros = maxVal == 0;
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
          topMargin + chartHeight / 2 - noDataPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.oldPoints.length != oldPoints.length ||
        oldDelegate.newPoints.length != newPoints.length;
  }
}
