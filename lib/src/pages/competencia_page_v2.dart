import 'package:flutter/material.dart';
import 'resultado_semanal_page.dart';
import 'vista_general_page.dart';
import 'vista_express_page.dart';
import 'finanzas_page.dart';
import 'director_compras_page.dart';
import '../widgets/safe_widget.dart';

class CompetenciaPage extends StatefulWidget {
  const CompetenciaPage({super.key});

  @override
  State<CompetenciaPage> createState() => _CompetenciaPageState();
}

class _CompetenciaPageState extends State<CompetenciaPage> {
  String _selectedView = 'Vista Express';
  String _selectedRole = 'CEO';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: _selectedRole == 'CEO'
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        title: Row(
          children: [
            Text(
              _selectedRole == 'CEO'
                  ? 'Dashboard CEO'
                  : _selectedRole == 'Finanzas'
                  ? 'Dashboard Finanzas'
                  : 'Dashboard Compras',
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const Spacer(),
            _roleSelector(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _selectedRole == 'CEO' ? _buildDrawer() : null,
      body: _buildContent(),
    );
  }

  Widget _roleSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: _selectedRole,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (v) => setState(() {
          _selectedRole = v!;
          _selectedView = 'Vista Express';
        }),
        items: const [
          DropdownMenuItem(value: 'CEO', child: Text('CEO')),
          DropdownMenuItem(value: 'Finanzas', child: Text('Finanzas')),
          DropdownMenuItem(
            value: 'Director de Compras',
            child: Text('Director de Compras'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 50),
          _drawerItem(
            icon: Icons.pie_chart,
            label: 'Vista Express',
            isSelected: _selectedView == 'Vista Express',
            onTap: () {
              setState(() => _selectedView = 'Vista Express');
              Navigator.pop(context);
            },
          ),
          _drawerItem(
            icon: Icons.calendar_today,
            label: 'Resultado Semanal',
            isSelected: _selectedView == 'Resultado Semanal',
            onTap: () {
              setState(() => _selectedView = 'Resultado Semanal');
              Navigator.pop(context);
            },
          ),
          _drawerItem(
            icon: Icons.analytics,
            label: 'Vista General',
            isSelected: _selectedView == 'Vista General',
            onTap: () {
              setState(() => _selectedView = 'Vista General');
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

  Widget _buildContent() {
    return SafeWidget(
      builder: (context) {
        if (_selectedRole == 'Finanzas') {
          return const FinanzasPage();
        }

        if (_selectedRole == 'Director de Compras') {
          return const DirectorComprasPage();
        }

        // Vistas para CEO
        if (_selectedView == 'Resultado Semanal')
          return const ResultadoSemanalView();
        if (_selectedView == 'Vista General') return VistaGeneralPage();

        return const VistaExpressPage();
      },
    );
  }
}
