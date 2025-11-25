import 'package:flutter/material.dart';

class StackedBarChart extends StatefulWidget {
  final List<double> incomeValues;
  final List<double> expenseValues;
  final List<String> labels;
  final Color incomeColor;
  final Color expenseColor;

  const StackedBarChart({
    super.key,
    required this.incomeValues,
    required this.expenseValues,
    required this.labels,
    this.incomeColor = const Color(0xFF2EB872),
    this.expenseColor = const Color(0xFFE91E63),
  });

  @override
  State<StackedBarChart> createState() => _StackedBarChartState();
}

class _StackedBarChartState extends State<StackedBarChart>
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
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Find max value for scaling
    double maxValue = 0;
    for (int i = 0; i < widget.incomeValues.length; i++) {
      final total = widget.incomeValues[i] + widget.expenseValues[i];
      if (total > maxValue) maxValue = total;
    }

    if (maxValue == 0) maxValue = 1; // Prevent division by zero

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(widget.labels.length, (index) {
              final incomeValue = widget.incomeValues[index];
              final expenseValue = widget.expenseValues[index];

              final incomeHeight =
                  (incomeValue / maxValue) * 150 * _animation.value;
              final expenseHeight =
                  (expenseValue / maxValue) * 150 * _animation.value;

              return SizedBox(
                width: 70, // Fixed width per bar
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Stacked bars
                      Container(
                        height: 150,
                        alignment: Alignment.bottomCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Expense bar (on top)
                              if (expenseHeight > 0)
                                Container(
                                  width: double.infinity,
                                  height: expenseHeight,
                                  decoration: BoxDecoration(
                                    color: widget.expenseColor,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ),
                              // Income bar (on bottom)
                              if (incomeHeight > 0)
                                Container(
                                  width: double.infinity,
                                  height: incomeHeight,
                                  decoration: BoxDecoration(
                                    color: widget.incomeColor,
                                    borderRadius: expenseHeight == 0
                                        ? const BorderRadius.vertical(
                                            top: Radius.circular(4),
                                          )
                                        : null,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Label
                      Text(
                        widget.labels[index],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
