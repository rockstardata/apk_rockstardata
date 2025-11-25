import 'package:aplicativo_01/src/widgets/competencia_app_bar.dart';
import 'package:aplicativo_01/src/widgets/internal_tab.dart';
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
  int _internalIndex = 0;
  String _selectedRole = 'CEO';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CompetenciaAppBar(
        selectedRole: _selectedRole,
        onRoleChanged: (v) => setState(() {
          print('CompetenciaPage: Role changed to $v');
          _selectedRole = v;
          // Reset index when changing role
          _internalIndex = 0;
        }),
      ),
      body: Column(
        children: [
          if (_selectedRole == 'CEO') _buildTabs(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InternalTab(
              label: 'Vista Express',
              icon: Icons.pie_chart,
              selected: _internalIndex == 0,
              onTap: () => setState(() => _internalIndex = 0),
            ),
            const SizedBox(width: 10),
            InternalTab(
              label: 'Resultado Semanal',
              icon: Icons.calendar_today,
              selected: _internalIndex == 1,
              onTap: () => setState(() => _internalIndex = 1),
            ),
            const SizedBox(width: 10),
            InternalTab(
              label: 'Vista General',
              icon: Icons.analytics,
              selected: _internalIndex == 2,
              onTap: () => setState(() => _internalIndex = 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SafeWidget(
      builder: (context) {
        // Vistas para Finanzas
        if (_selectedRole == 'Finanzas') {
          return const FinanzasPage();
        }

        // Vistas para Director de Compras
        if (_selectedRole == 'Director de Compras') {
          return const DirectorComprasPage();
        }

        // Vistas para CEO (Default)
        if (_internalIndex == 1) return const ResultadoSemanalView();
        if (_internalIndex == 2) return VistaGeneralPage();

        return const VistaExpressPage();
      },
    );
  }
}
