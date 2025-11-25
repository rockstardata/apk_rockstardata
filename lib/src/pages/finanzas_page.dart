import 'package:flutter/material.dart';
import '../widgets/stacked_bar_chart.dart';

class FinanzasPage extends StatefulWidget {
  const FinanzasPage({super.key});

  @override
  State<FinanzasPage> createState() => _FinanzasPageState();
}

class _FinanzasPageState extends State<FinanzasPage> {
  String _selectedView = 'Vista General';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Dashboard Finanzas',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _selectedView == 'Vista General'
          ? _buildVistaGeneral()
          : _selectedView == 'Eficiencia'
          ? _buildEficiencia()
          : _buildPerformance(),
    );
  }

  Widget _buildVistaGeneral() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _periodChip('Noviembre 2025', true),
              const SizedBox(width: 8),
              _periodChip('7 Días', false),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _kpiCard('EBITDA', 107497.0, '+€1.025', '+2.52%', true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _kpiCard(
                  'Ingresos Totales',
                  120524.0,
                  '+€2.150',
                  '+3.25%',
                  true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _kpiCard(
                  'Gastos Totales',
                  13025.0,
                  '-€145',
                  '-1.1%',
                  false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _kpiCard(
                  'Margen',
                  0.0,
                  '0€',
                  '0%',
                  true,
                  isPercentage: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Evolución Ingresos, Gastos y EBITDA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _legend(const Color(0xFF6200EE), 'EBITDA'),
                    const SizedBox(width: 12),
                    _legend(const Color(0xFF00BCD4), 'Ingresos'),
                    const SizedBox(width: 12),
                    _legend(const Color(0xFFE91E63), 'Gastos'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: StackedBarChart(
                    incomeValues: const [8000.0, 9000.0],
                    expenseValues: const [3000.0, 4000.0],
                    labels: const ['Ene', 'Feb'],
                    incomeColor: const Color(0xFF00BCD4),
                    expenseColor: const Color(0xFFE91E63),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEficiencia() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eficiencia: Liquidez y Flujos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Three separate cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Líquido Disponible',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '69.781 €',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  '+38% vs 51.427,76 € año pasado',
                  style: TextStyle(fontSize: 11, color: Color(0xFF4CAF50)),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Objetivo: -50.887 €',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Cobros Totales',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '73.699 €',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  '+8% vs 239.371,38 € año pasado',
                  style: TextStyle(fontSize: 11, color: Color(0xFF4CAF50)),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Objetivo: 239.790,93 €',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Pagos Totales',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '5.948 €',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  '+4% vs 303.219,48 € año pasado',
                  style: TextStyle(fontSize: 11, color: Color(0xFF4CAF50)),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Objetivo: 238.762,86 €',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Ratios Clave',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _circularRatio('Liquidez Liquidez', 0.06, const Color(0xFF9C27B0)),
          const SizedBox(height: 12),
          _circularRatio('Liquidez Solvencia', 0.86, const Color(0xFF6200EE)),
          const SizedBox(height: 12),
          _circularRatio(
            'EBITDA Porcentaje ROI',
            0.12,
            const Color(0xFF00BCD4),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(0)} €',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _circularRatio(String title, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text(
                  value.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformance() => const Center(
    child: Text('Performance - Próximamente', style: TextStyle(fontSize: 18)),
  );

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 50),
          _drawerItem(
            icon: Icons.dashboard_outlined,
            label: 'Vista General',
            isSelected: _selectedView == 'Vista General',
            onTap: () {
              setState(() => _selectedView = 'Vista General');
              Navigator.pop(context);
            },
          ),
          _drawerItem(
            icon: Icons.bar_chart,
            label: 'Eficiencia',
            isSelected: _selectedView == 'Eficiencia',
            onTap: () {
              setState(() => _selectedView = 'Eficiencia');
              Navigator.pop(context);
            },
          ),
          _drawerItem(
            icon: Icons.trending_up,
            label: 'Performance',
            isSelected: _selectedView == 'Performance',
            onTap: () {
              setState(() => _selectedView = 'Performance');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6200EE) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _periodChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6200EE) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? const Color(0xFF6200EE) : Colors.grey.shade300,
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
    String percentage,
    bool isPositive, {
    bool isPercentage = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            isPercentage
                ? '${value.toStringAsFixed(0)}%'
                : '${value.toStringAsFixed(0)} €',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                change,
                style: TextStyle(
                  fontSize: 10,
                  color: isPositive ? const Color(0xFF4CAF50) : Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 10,
                  color: isPositive ? const Color(0xFF4CAF50) : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  Widget _legend(Color color, String label) => Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ],
  );
}
