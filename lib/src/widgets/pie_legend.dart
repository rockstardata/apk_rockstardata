import 'package:flutter/material.dart';

class PieLegend extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final List<Color> colors;

  const PieLegend({
    super.key,
    required this.labels,
    required this.values,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final total = values.fold(0.0, (a, b) => a + b);
    final safeTotal = total == 0 ? 1.0 : total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(labels.length, (i) {
        final pct = (values[i] / safeTotal) * 100;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: colors[i % colors.length],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  labels[i],
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    values[i] < 1000
                        ? '${values[i].toInt()} €'
                        : '${(values[i] / 1000).toStringAsFixed(1)}k €',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
