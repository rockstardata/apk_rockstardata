import 'package:flutter/material.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final List<Color> colors;
  final double maxValue;

  const HorizontalBarChart({
    super.key,
    required this.values,
    required this.labels,
    required this.colors,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(values.length, (index) {
        final val = values[index];
        final label = labels[index];
        final color = colors[index % colors.length];
        final percentage = (val / maxValue).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
