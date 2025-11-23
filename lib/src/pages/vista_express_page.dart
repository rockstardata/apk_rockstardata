import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/vista_express_kpis.dart';
import '../widgets/ingresos_por_dia_card.dart';
import '../widgets/ingresos_por_restaurante_chart.dart';
import '../widgets/ingresos_por_turno_pie.dart';
import '../widgets/origen_ingresos_pie.dart';
import '../widgets/loading_widget.dart';

class VistaExpressPage extends StatelessWidget {
  const VistaExpressPage({super.key});

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
            final comensales = metrics['comensales'] ?? 0.0;
            final ticketMedio = metrics['ticket_medio'] ?? 0.0;

            // Eliminamos la lectura estática de valores aquí

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPIs superiores - optimizado para móviles
                  VistaExpressKPIs(
                    ingresos: ingresos,
                    comensales: comensales,
                    ticketMedio: ticketMedio,
                    isWide: false, // Siempre móvil
                  ),
                  const SizedBox(height: 20),

                  // Gráfico de ingresos por día
                  ValueListenableBuilder<List<double>>(
                    valueListenable: AppState.instance.ingresosDiarios,
                    builder: (context, ingresosDiarios, _) {
                      return IngresosPorDiaCard(values: ingresosDiarios);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gráfico de ingresos por turno
                  ValueListenableBuilder<List<double>>(
                    valueListenable: AppState.instance.ingresosPorTurno,
                    builder: (context, ingresosPorTurno, _) {
                      return IngresosPorTurnoPie(valores: ingresosPorTurno);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gráfico de línea de ingresos
                  ValueListenableBuilder<List<double>>(
                    valueListenable: AppState.instance.ingresosDiarios,
                    builder: (context, ingresosDiarios, _) {
                      return IngresosPorRestauranteChart(
                        points: ingresosDiarios,
                        height: 220,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gráfico de origen de ingresos
                  ValueListenableBuilder<Map<String, double>>(
                    valueListenable: AppState.instance.origenIngresos,
                    builder: (context, origenIngresos, _) {
                      final totalIngresos = AppState
                          .instance
                          .ingresosDiarios
                          .value
                          .fold<double>(0, (a, b) => a + b);
                      return OrigenIngresosPie(
                        origenes: origenIngresos,
                        total: totalIngresos,
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
