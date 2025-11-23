import 'package:flutter/material.dart';
import '../widgets/simple_line_chart.dart';
import '../widgets/simple_bar_chart.dart';
import '../services/app_state.dart';
import '../widgets/loading_widget.dart';

class ResultadoSemanalView extends StatelessWidget {
  const ResultadoSemanalView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.instance.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const LoadingWidget(message: 'Cargando datos...');
        }

        return ValueListenableBuilder<Map<String, double>>(
          valueListenable: AppState.instance.metrics,
          builder: (context, metrics, _) {
            final ingresos = metrics['ingresos_totales'] ?? 0.0;
            final comensales = metrics['comensales']?.toInt() ?? 0;
            final ticket = metrics['ticket_medio'] ?? 0.0;

            // Eliminamos la lógica estática de puntos aquí para moverla dentro del builder

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header - optimizado para móviles
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Resultado Semanal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '17-23 nov',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6200EE),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 14,
                                color: Color(0xFF6200EE),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // KPIs row - optimizado para móviles
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 3,
                          child: _kpiSmall(
                            'Ingresos Totales',
                            '${ingresos.toStringAsFixed(0)} €',
                            '-66%',
                            subtitle: 'vs 21.413 €',
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 3,
                          child: _kpiSmall(
                            'Comensales',
                            '$comensales',
                            '+0%',
                            subtitle: 'vs 530',
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 3,
                          child: _kpiSmall(
                            'Ticket Medio',
                            '${ticket.toStringAsFixed(2)} €',
                            '+812%',
                            subtitle: 'vs 31,79 €',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Gráfico de línea - optimizado para móviles
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Beneficio Estimado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ValueListenableBuilder<List<double>>(
                              valueListenable:
                                  AppState.instance.ingresosDiarios,
                              builder: (context, ingresosDiarios, _) {
                                final base = ingresos <= 0 ? 1000.0 : ingresos;
                                final points =
                                    ingresosDiarios.isNotEmpty &&
                                        ingresosDiarios.any((v) => v > 0)
                                    ? ingresosDiarios
                                    : [
                                        base * 0.5,
                                        base * 0.75,
                                        base * 0.6,
                                        base * 0.9,
                                        base,
                                        base * 0.85,
                                        base * 0.7,
                                      ];
                                return SimpleLineChart(
                                  points: points,
                                  color: const Color(0xFF8E24AA),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Métricas adicionales - en columna para móviles
                    Row(
                      children: [
                        Expanded(
                          child: _smallMetric(
                            'Ratio Personal',
                            '83%',
                            '41 pp',
                            Colors.red,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _smallMetric(
                            'Ratio COGS',
                            '0%',
                            '-27 pp',
                            Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Gráfico de barras - optimizado para móviles
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingresos por día',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ValueListenableBuilder<List<double>>(
                              valueListenable:
                                  AppState.instance.ingresosDiarios,
                              builder: (context, ingresosDiarios, _) {
                                return SimpleBarChart(
                                  values: ingresosDiarios.isNotEmpty
                                      ? ingresosDiarios
                                      : [154, 194, 0, 215, 499, 454, 709],
                                  labels: const [
                                    'L',
                                    'M',
                                    'X',
                                    'J',
                                    'V',
                                    'S',
                                    'D',
                                  ],
                                  color: const Color(0xFF2EB872),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _kpiSmall(
    String title,
    String value,
    String percent, {
    String subtitle = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                percent,
                style: TextStyle(
                  color: percent.startsWith('+') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallMetric(
    String title,
    String value,
    String change,
    Color changeColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            change,
            style: TextStyle(color: changeColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
