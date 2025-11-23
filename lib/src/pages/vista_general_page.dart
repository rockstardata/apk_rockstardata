import 'package:flutter/material.dart';
import '../widgets/simple_line_chart.dart';
import '../widgets/simple_bar_chart.dart';
import '../services/app_state.dart';
import '../widgets/loading_widget.dart';

class VistaGeneralPage extends StatelessWidget {
  const VistaGeneralPage({super.key});

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
            try {
              debugPrint('VistaGeneralPage: builder invoked, metrics=$metrics');
              final ingresos = metrics['ingresos_totales'] ?? 0.0;
              final gastos = metrics['gastos_totales'] ?? 0.0;
              final beneficio = ingresos - gastos;

              // Eliminamos la lectura estática de valores aquí para usarlos dentro de los builders

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KPIs row - optimizado para móviles
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: _bigKpi(
                              'Ingresos Totales',
                              ingresos,
                              Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: _bigKpi(
                              'Gastos Totales',
                              gastos,
                              Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: _bigKpi(
                              'Ratio Personal',
                              metrics['ratio_personal'] ?? 46.0,
                              Colors.orange,
                              isPercent: true,
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: _bigKpi(
                              'Ratio COGS',
                              metrics['ratio_cogs'] ?? 6.0,
                              Colors.teal,
                              isPercent: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Beneficio Total - optimizado para móviles
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
                              'Beneficio Total',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${beneficio.toStringAsFixed(0)} €',
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cumplimiento: ${(beneficio / (ingresos == 0 ? 1 : ingresos) * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ValueListenableBuilder<List<double>>(
                              valueListenable: AppState.instance.ingresosSerie,
                              builder: (context, ingresosSerie, _) {
                                if (ingresosSerie.isEmpty)
                                  return const SizedBox();
                                return SizedBox(
                                  height: 180,
                                  width: double.infinity,
                                  child: SimpleLineChart(
                                    points: ingresosSerie,
                                    color: Colors.green,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Ingresos por categoría - optimizado para móviles
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
                              'Ingresos por categoría',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: ValueListenableBuilder<List<double>>(
                                valueListenable:
                                    AppState.instance.ingresosPorTurno,
                                builder: (context, ingresosPorCategoria, _) {
                                  return SimpleBarChart(
                                    values: ingresosPorCategoria,
                                    labels: const ['Comida', 'Cena'],
                                    color: const Color(0xFF2EB872),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Costes por departamento - optimizado para móviles
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
                              'Costes por departamento',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _horizontalBar('Gastos Operativos', 1053, 7316),
                            const SizedBox(height: 12),
                            _horizontalBar('Compras', 7316, 7316),
                            const SizedBox(height: 12),
                            _horizontalBar('Servicios', 4646, 7316),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            } catch (e, st) {
              debugPrint('Error rendering VistaGeneralPage: $e');
              debugPrint('$st');
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Error al renderizar Vista General:\n$e',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _bigKpi(
    String title,
    double value,
    Color color, {
    bool isPercent = false,
  }) {
    final text = isPercent
        ? '${value.toStringAsFixed(0)}%'
        : '${value.toStringAsFixed(0)} €';
    return Container(
      padding: const EdgeInsets.all(12),
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
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _horizontalBar(String label, double value, double max) {
    final ratio = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 18,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 2,
          child: Text(
            '${value.toStringAsFixed(0)} €',
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
