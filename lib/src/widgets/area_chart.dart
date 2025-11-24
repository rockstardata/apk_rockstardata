import 'package:flutter/material.dart';

class AreaChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final bool showLabels;

  const AreaChart({
    super.key,
    required this.values,
    required this.labels,
    this.color = Colors.blue,
    this.showLabels = true,
  });

  @override
  State<AreaChart> createState() => _AreaChartState();
}

class _AreaChartState extends State<AreaChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return CustomPaint(
          painter: _AreaChartPainter(
            values: widget.values,
            labels: widget.labels,
            color: widget.color,
            progress: _anim.value,
            showLabels: widget.showLabels,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final double progress;
  final bool showLabels;

  _AreaChartPainter({
    required this.values,
    required this.labels,
    required this.color,
    required this.progress,
    required this.showLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || values.isEmpty) return;

    final minVal = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;
    final safeRange = range <= 0 ? (maxVal <= 0 ? 1.0 : maxVal) : range;

    // Margen inferior para etiquetas
    final bottomMargin = showLabels ? 20.0 : 0.0;
    final chartHeight = size.height - bottomMargin;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (values.length - 1);

    fillPath.moveTo(0, chartHeight); // Start bottom-left

    for (int i = 0; i < values.length; i++) {
      final val = values[i] * progress;
      final normalized = (val - minVal) / safeRange;
      // Escalar un poco para que no toque arriba/abajo
      final y =
          chartHeight -
          (normalized * (chartHeight * 0.8) + (chartHeight * 0.1));
      final x = stepX * i;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        // Curva suave
        final prevX = stepX * (i - 1);
        final prevVal = values[i - 1] * progress;
        final prevNorm = (prevVal - minVal) / safeRange;
        final prevY =
            chartHeight -
            (prevNorm * (chartHeight * 0.8) + (chartHeight * 0.1));

        final controlX1 = prevX + (x - prevX) / 2;
        final controlX2 = prevX + (x - prevX) / 2;

        path.cubicTo(controlX1, prevY, controlX2, y, x, y);
        fillPath.cubicTo(controlX1, prevY, controlX2, y, x, y);
      }

      // Etiquetas
      if (showLabels && i % 2 == 0) {
        // Mostrar alternadas si son muchas
        final label = labels[i];
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(x - tp.width / 2, chartHeight + 4));
      }
    }

    fillPath.lineTo(size.width, chartHeight);
    fillPath.close();

    // Gradiente
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withOpacity(0.4), color.withOpacity(0.0)],
    );

    final paintFill = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, chartHeight),
      )
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
