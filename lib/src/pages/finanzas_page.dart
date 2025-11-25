import 'package:flutter/material.dart';
import '../widgets/stacked_bar_chart.dart';
import '../widgets/animated_donut_chart.dart';
import '../services/app_state.dart';

class FinanzasPage extends StatelessWidget {
  const FinanzasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Resumen Financiero',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Filter Tabs
            Row(
              children: [
                _filterTab('Esta Semana', true),
                const SizedBox(width: 8),
                _filterTab('Finanzas', false),
                const SizedBox(width: 8),
                _filterTab('Últimos 30 días', false),
              ],
            ),

            const SizedBox(height: 20),

            // KPIs Row 1
            Row(
              children: [
                Expanded(
                  child: _kpiCard('Ingresos Totales', 12840.0, '+2.5%', true),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard('Gastos Totales', 7320.0, '+1.2%', true),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // KPIs Row 2
            Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    'Margen Beneficio',
                    43.0,
                    '-0.8%',
                    false,
                    isPercentage: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _kpiCard('EBITDA', 5520.0, '+3.1%', true)),
              ],
            ),

            const SizedBox(height: 24),

            // Stacked Bar Chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ingresos vs. Gastos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          _legend(const Color(0xFF2196F3), 'Ingresos'),
                          const SizedBox(width: 12),
                          _legend(const Color(0xFFFF9800), 'Gastos'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: StackedBarChart(
                      incomeValues: const [1800.0, 2200.0, 1900.0, 2400.0],
                      expenseValues: const [1200.0, 1400.0, 1300.0, 1500.0],
                      labels: const ['L-D', 'M-X', 'J-V', 'S-D'],
                      incomeColor: const Color(0xFF2196F3),
                      expenseColor: const Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Desglose Section
            const Text(
              'Desglose',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // Categorías de Gastos Donut
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categorías de Gastos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: AnimatedDonutChart(
                      totalValue: 7320.0,
                      segments: [
                        DonutSegment(
                          label: 'Personal',
                          value: 2930.0,
                          color: const Color(0xFF9C27B0),
                        ),
                        DonutSegment(
                          label: 'Alquiler',
                          value: 1317.0,
                          color: const Color(0xFF2196F3),
                        ),
                        DonutSegment(
                          label: 'Proveedores',
                          value: 2049.0,
                          color: const Color(0xFFFF9800),
                        ),
                        DonutSegment(
                          label: 'Otros',
                          value: 1024.0,
                          color: const Color(0xFF4CAF50),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _expenseItem('Personal', 40, const Color(0xFF9C27B0)),
                  const SizedBox(height: 8),
                  _expenseItem('Alquiler', 18, const Color(0xFF2196F3)),
                  const SizedBox(height: 8),
                  _expenseItem('Proveedores', 28, const Color(0xFFFF9800)),
                  const SizedBox(height: 8),
                  _expenseItem('Otros', 14, const Color(0xFF4CAF50)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Fuentes de Ingresos Donut
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fuentes de Ingresos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: AnimatedDonutChart(
                      totalValue: 12840.0,
                      segments: [
                        DonutSegment(
                          label: 'Comida',
                          value: 6420.0,
                          color: const Color(0xFF4CAF50),
                        ),
                        DonutSegment(
                          label: 'Bebida',
                          value: 3852.0,
                          color: const Color(0xFF2196F3),
                        ),
                        DonutSegment(
                          label: 'Eventos',
                          value: 2568.0,
                          color: const Color(0xFFFF9800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _expenseItem('Comida', 50, const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  _expenseItem('Bebida', 30, const Color(0xFF2196F3)),
                  const SizedBox(height: 8),
                  _expenseItem('Eventos', 20, const Color(0xFFFF9800)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Indicadores Clave Table
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Indicadores Clave',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _indicatorRow(
                    'Métrica',
                    'Valor Actual',
                    'Tendencia',
                    isHeader: true,
                  ),
                  const Divider(),
                  _indicatorRow(
                    'Ticket Promedio',
                    '\$48.50',
                    '+7%',
                    changePositive: true,
                  ),
                  _indicatorRow(
                    'Ratio Líquido',
                    '1.8',
                    '-2%',
                    changePositive: false,
                  ),
                  _indicatorRow(
                    'Periodo Cobro',
                    '\$2,940',
                    '+4%',
                    changePositive: true,
                  ),
                  _indicatorRow(
                    'Ratio Endeud.',
                    '12 días',
                    '-15%',
                    changePositive: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _filterTab(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2196F3) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFF2196F3) : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isActive ? Colors.white : Colors.black,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _kpiCard(
    String title,
    double value,
    String change,
    bool isPositive, {
    bool isPercentage = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            isPercentage
                ? '${value.toStringAsFixed(0)}%'
                : '\$${value.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              fontSize: 12,
              color: isPositive ? const Color(0xFF4CAF50) : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _expenseItem(String label, int percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label ($percentage%)',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _indicatorRow(
    String metric,
    String value,
    String trend, {
    bool isHeader = false,
    bool changePositive = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              metric,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader ? Colors.grey : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader ? Colors.grey : Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              trend,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader
                    ? Colors.grey
                    : (changePositive ? const Color(0xFF4CAF50) : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
