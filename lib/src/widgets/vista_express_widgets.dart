import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double percentageChange;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.percentageChange,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = percentageChange >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // Light background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance de la Semana',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '€${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.black, // Dark text
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(0)}% vs. semana anterior',
            style: TextStyle(
              color: isPositive ? const Color(0xFF2EB872) : Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class MiniChartCard extends StatefulWidget {
  final String title;
  final double value;
  final double percentageChange;
  final Color lineColor;
  final bool isPositiveChange;

  const MiniChartCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentageChange,
    required this.lineColor,
    required this.isPositiveChange,
  });

  @override
  State<MiniChartCard> createState() => _MiniChartCardState();
}

class _MiniChartCardState extends State<MiniChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Light background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ), // Dark text
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '€${widget.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black, // Dark text
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.isPositiveChange ? '+' : ''}${widget.percentageChange.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: widget.isPositiveChange
                          ? const Color(0xFF2EB872)
                          : Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Animated Sparkline
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.lineColor.withOpacity(0.2),
                          widget.lineColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: CustomPaint(
                      painter: _SparklinePainter(
                        color: widget.lineColor,
                        progress: _animation.value,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final Color color;
  final double progress;

  _SparklinePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height);
    // Simple quadratic bezier for demo purposes
    // In a real app, this would be based on actual data points
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width, 0);

    // Create a partial path based on progress
    final pathMetrics = path.computeMetrics();
    final partialPath = Path();

    for (var metric in pathMetrics) {
      partialPath.addPath(
        metric.extractPath(0, metric.length * progress),
        Offset.zero,
      );
    }

    canvas.drawPath(partialPath, paint);

    // Add a glow effect point at the end if progress is > 0
    if (progress > 0) {
      final endPoint =
          partialPath
              .computeMetrics()
              .last
              .getTangentForOffset(partialPath.computeMetrics().last.length)
              ?.position ??
          Offset.zero;

      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(endPoint, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;

  const TransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100], // Light background
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.trending_up : Icons.trending_down,
              color: isIncome ? const Color(0xFF2EB872) : Colors.redAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black, // Dark text
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}€${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isIncome ? const Color(0xFF2EB872) : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
