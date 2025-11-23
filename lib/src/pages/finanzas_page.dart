import 'package:flutter/material.dart';
import '../widgets/kpi_card.dart';
import '../widgets/combo_chart.dart';
import '../widgets/data_table_widget.dart';

class FinanzasPage extends StatelessWidget {
  const FinanzasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila 1: KPIs Principales
          const Row(
            children: [
              Expanded(
                child: KPICard(
                  title: 'EBITDA',
                  value: '101.109 €',
                  subtitle: 'Objetivo: -34.329 €',
                  icon: Icons.info_outline,
                  valueColor: Colors.black,
                  subtitleColor: Colors.purple,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: KPICard(
                  title: 'Ingresos Totales',
                  value: '114.126 €',
                  subtitle: 'Objetivo: 129.518 €',
                  icon: Icons.info_outline,
                  valueColor: Colors.black,
                  subtitleColor: Colors.purple,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: KPICard(
                  title: 'Gastos Totales',
                  value: '13.016 €',
                  subtitle: 'Presupuesto: 163.847 €',
                  icon: Icons.info_outline,
                  valueColor: Colors.black,
                  subtitleColor: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Fila 2: Saldos
          Row(
            children: [
              Expanded(
                child: KPICard(
                  title: 'Saldo Inicial',
                  value: '51.332 €',
                  subtitle: '319% vs -42.961 € año pasado',
                  icon: Icons.info_outline,
                  subtitleColor: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: KPICard(
                  title: 'Saldo del Período',
                  value: '64.358 €',
                  subtitle: '15% vs 434.052 € año pasado',
                  icon: Icons.info_outline,
                  subtitleColor: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: KPICard(
                  title: 'Saldo Final',
                  value: '0', // Placeholder
                  subtitle: '0% vs 0 € año pasado',
                  icon: Icons.info_outline,
                  subtitleColor: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Fila 3: Gráficas de Evolución
          SizedBox(
            height: 350,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Evolución Ingresos, Gastos y EBITDA',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ComboChart(
                            barValues: [
                              150000,
                              220000,
                              180000,
                              250000,
                              200000,
                              280000,
                              210000,
                            ],
                            lineValues: [
                              -50000,
                              -120000,
                              -80000,
                              -150000,
                              -100000,
                              -20000,
                              50000,
                            ],
                            labels: [
                              'May 2025',
                              'Jun 2025',
                              'Jul 2025',
                              'Ago 2025',
                              'Sep 2025',
                              'Oct 2025',
                              'Nov 2025',
                            ],
                            barColor: Color(0xFFD81B60), // Rosa
                            lineColor: Colors.grey,
                            barLegend: 'Ingresos',
                            lineLegend: 'EBITDA',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Evolución Cobros y Pagos',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ComboChart(
                            barValues: [
                              280000,
                              320000,
                              290000,
                              350000,
                              250000,
                              200000,
                              150000,
                            ],
                            lineValues: [
                              50000,
                              80000,
                              60000,
                              70000,
                              40000,
                              20000,
                              30000,
                            ],
                            labels: [
                              'May 2025',
                              'Jun 2025',
                              'Jul 2025',
                              'Ago 2025',
                              'Sep 2025',
                              'Oct 2025',
                              'Nov 2025',
                            ],
                            barColor: Color(0xFFD81B60), // Rosa
                            lineColor: Colors.grey,
                            barLegend: 'Pagos',
                            lineLegend: 'Saldo del periodo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Fila 4: Tablas
          const SizedBox(
            height: 400,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: DataTableWidget(
                    title: 'Ingresos vs Objetivo',
                    columns: ['Local', 'Importe', 'Objetivo'],
                    rows: [
                      ['Bilbao', '16.194 €', '16.844 €'],
                      ['Burgos', '13.073 €', '13.135 €'],
                      ['Pamplona', '28.731 €', '33.395 €'],
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DataTableWidget(
                    title: 'Gastos vs Presupuesto',
                    columns: ['Gastos', 'Importe', 'Presupuesto'],
                    rows: [
                      ['Compras', '7.316 €', '38.297 €'],
                      ['Gastos financieros', '1.053 €', '0 €'],
                      ['Servicios exteriores', '4.646 €', '42.724 €'],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
