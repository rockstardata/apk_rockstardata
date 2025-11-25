import 'package:flutter/material.dart';
import '../widgets/kpi_card.dart';
import '../widgets/horizontal_bar_chart.dart';
import '../widgets/grouped_bar_chart.dart';
import '../widgets/area_chart.dart';
import '../widgets/data_table_widget.dart';
import '../widgets/safe_widget.dart';

class DirectorComprasPage extends StatelessWidget {
  const DirectorComprasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeWidget(
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila 1: KPIs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: const KPICard(
                      title: 'Ratio Compras Totales',
                      value: '28,5%',
                      subtitle: '8% vs 12% año pasado',
                      subtitleColor: Colors.green,
                      icon: Icons.pie_chart_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: const KPICard(
                      title: 'Ratio Compras Cocina',
                      value: '18%',
                      subtitle: '5% vs 16,5% año pasado',
                      subtitleColor: Colors.green,
                      icon: Icons.restaurant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: const KPICard(
                      title: 'Ratio Compras Bebida',
                      value: '29%',
                      subtitle: '-3% vs 30% año pasado',
                      subtitleColor: Colors.red,
                      icon: Icons.local_bar,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: const KPICard(
                      title: 'Facturación Total',
                      value: '30.000 €',
                      subtitle: '7% vs 25.000 € año pasado',
                      subtitle2: 'Objetivo: 35.000 €',
                      subtitleColor: Colors.green,
                      subtitle2Color: Colors.purple,
                      icon: Icons.euro,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: const KPICard(
                      title: 'Compras Totales',
                      value: '45.000 €',
                      subtitle: '-2% vs 46.000 € año pasado',
                      subtitle2: 'Presupuesto: 47.000 €',
                      subtitleColor: Colors.red,
                      subtitle2Color: Colors.red,
                      icon: Icons.shopping_cart,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fila 2: Ranking y Stock
            SizedBox(
              height: 350,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
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
                            'Ranking de locales según ratio de compras',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: HorizontalBarChart(
                                values: [28, 25, 22, 20, 18, 15],
                                labels: [
                                  'Local 1',
                                  'Local 2',
                                  'Local 3',
                                  'Local 4',
                                  'Local 5',
                                  'Local 6',
                                ],
                                colors: [Color(0xFF8E24AA), Color(0xFFD81B60)],
                                maxValue: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
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
                            'Stock Operativo vs Real',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: GroupedBarChart(
                              values1: [
                                450,
                                400,
                                500,
                                480,
                                520,
                                550,
                                600,
                                620,
                                650,
                                680,
                                700,
                                720,
                              ],
                              values2: [
                                420,
                                390,
                                480,
                                460,
                                500,
                                530,
                                580,
                                600,
                                630,
                                660,
                                680,
                                700,
                              ],
                              labels: [
                                'Ene',
                                'Feb',
                                'Mar',
                                'Abr',
                                'May',
                                'Jun',
                                'Jul',
                                'Ago',
                                'Sep',
                                'Oct',
                                'Nov',
                                'Dic',
                              ],
                              color1: Color(0xFF8E24AA),
                              color2: Color(0xFFD81B60),
                              legend1: 'Real',
                              legend2: 'Operativo',
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

            // Fila 3: Tabla y Rotación
            SizedBox(
              height: 350,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DataTableWidget(
                      title: 'Compras por familia',
                      columns: ['Subfamilia', 'SKUs', 'Presupuesto', 'Compras'],
                      rows: [
                        ['Mariscos', '12', '1.500 €', '1.600 €'],
                        ['Frutas', '25', '1.800 €', '1.600 €'],
                        ['Vacuno', '18', '1.400 €', '1.300 €'],
                        ['Aves', '10', '1.100 €', '1.050 €'],
                        ['Verduras', '20', '1.900 €', '1.500 €'],
                        ['Cereales', '15', '1.300 €', '1.800 €'],
                        ['Pescado', '30', '2.000 €', '1.950 €'],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
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
                            'Evolución de la Rotación de Stock',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: AreaChart(
                              values: [
                                10,
                                12,
                                11,
                                14,
                                13,
                                15,
                                9,
                                16,
                                16,
                                17,
                                14,
                                14,
                              ],
                              labels: [
                                'Mar',
                                'Abr',
                                'May',
                                'Jun',
                                'Jul',
                                'Ago',
                                'Sep',
                                'Oct',
                                'Nov',
                                'Dic',
                                'Ene',
                                'Feb',
                              ],
                              color: Color(0xFF8E24AA),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
