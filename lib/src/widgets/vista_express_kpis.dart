import 'package:flutter/material.dart';
import 'kpi_small.dart';

/// Widget de KPIs para Vista Express
class VistaExpressKPIs extends StatelessWidget {
  final double ingresos;
  final double comensales;
  final double ticketMedio;
  final bool isWide;

  const VistaExpressKPIs({
    super.key,
    required this.ingresos,
    required this.comensales,
    required this.ticketMedio,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    // Optimizado solo para móviles - siempre usar layout móvil
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 3; // 16 padding * 2 + 16 gaps
    final gap = 8.0;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        SizedBox(
          width: cardWidth,
          child: KpiSmall(
            title: 'Ingresos Totales',
            value: '${ingresos.toStringAsFixed(0)} €',
            percent: '-13%',
            subtitle: 'vs ${(ingresos / 0.87).toStringAsFixed(0)} €\nObj: 29.207 €',
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: KpiSmall(
            title: 'Comensales Totales',
            value: comensales.toInt().toString(),
            percent: '-87%',
            subtitle: 'vs ${(comensales / 0.13).toStringAsFixed(0)}\nObj: 1.462',
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: KpiSmall(
            title: 'Ticket medio',
            value: '${ticketMedio.toStringAsFixed(2)} €',
            percent: '+644%',
            subtitle: 'vs ${(ticketMedio / 7.44).toStringAsFixed(2)} €\nObj: 19,98 €',
          ),
        ),
      ],
    );
  }
}

