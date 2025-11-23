import 'package:flutter/material.dart';
import 'package:aplicativo_01/src/pages/competencia_page_v2.dart';
import 'package:aplicativo_01/src/pages/alerts_page.dart';
import 'package:aplicativo_01/src/pages/chat_page.dart';
import 'package:aplicativo_01/src/pages/profile_page.dart';
import 'package:aplicativo_01/src/services/auth_service.dart';

// --- WIDGET PRINCIPAL QUE CONTIENE LA LÓGICA DE ESTADO (NAVIGATION) ---

class DashboardPage extends StatefulWidget {
  final String title;
  const DashboardPage({super.key, required this.title});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 2;

  static const Color _primaryPurple = Color(0xFF4B0082);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const AlertsPage(),
      const CompetenciaPage(),
      _MainDashboardContent(title: widget.title),
      const ChatPage(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('DEBUG: DashboardPage.build() selectedIndex=$_selectedIndex');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.notifications_none, 1, 'Alertas', 0),
          _buildNavBarItem(Icons.bar_chart, 1, 'Datos', 1),
          GestureDetector(
            onTap: () => _onItemTapped(2),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedIndex == 2 ? _primaryPurple : Colors.grey[300],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(
                      _primaryPurple.red,
                      _primaryPurple.green,
                      _primaryPurple.blue,
                      0.5,
                    ),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.flash_on,
                color: _selectedIndex == 2 ? Colors.white : _primaryPurple,
                size: 28,
              ),
            ),
          ),
          _buildNavBarItem(Icons.chat_bubble_outline, 1, 'Chat', 3),
          _buildNavBarItem(Icons.person_outline, 0, 'Perfil', 4),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
    IconData icon,
    int notificationCount,
    String label,
    int index,
  ) {
    final bool isSelected = index == _selectedIndex;
    final Color iconColor = isSelected ? _primaryPurple : Colors.grey[600]!;
    final TextStyle labelStyle = TextStyle(
      color: iconColor,
      fontSize: 10,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: iconColor, size: 26),
                if (notificationCount > 0 && !isSelected)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }
}

// --- CONTENIDO DEL DASHBOARD PRINCIPAL (REFRACTORIZADO) ---

class _MainDashboardContent extends StatelessWidget {
  final String title;
  const _MainDashboardContent({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocationPicker(),
                const SizedBox(height: 15),
                _buildTimeFilters(),
                const SizedBox(height: 20),
                _buildMetricsGrid(),
                const SizedBox(height: 25),
                _buildActiveAlerts(),
                const SizedBox(height: 25),
                _buildIntelligentContext(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ValueListenableBuilder<Map<String, dynamic>?>(
      valueListenable: AuthService.instance.currentUser,
      builder: (context, userData, _) {
        final email = userData?['email']?.toString() ?? 'Usuario';
        final restaurantName =
            userData?['restaurantName']?.toString() ?? 'Mi Restaurante';
        final initials = email.isNotEmpty
            ? email.substring(0, 2).toUpperCase()
            : 'U';

        return Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            bottom: 15,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF2C003E),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF8A2BE2),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola $email!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Gestiona $restaurantName',
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.7),
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: 'principal',
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4B0082)),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          items: const [
            DropdownMenuItem(
              value: 'principal',
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey, size: 20),
                  SizedBox(width: 8),
                  Text('Restaurante Principal - Madrid'),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'secundario',
              child: Text('Sucursal 2 - Barcelona'),
            ),
          ],
          onChanged: (String? newValue) {},
        ),
      ),
    );
  }

  Widget _buildTimeFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFilterButton('Hoy vs ayer', isActive: true),
        _buildFilterButton('Semana vs sem. ant.'),
        _buildFilterButton('Mes vs mes ant.'),
      ],
    );
  }

  Widget _buildFilterButton(String text, {bool isActive = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? const Color(0xFF4B0082) : Colors.white,
            foregroundColor: isActive ? Colors.white : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isActive ? Colors.transparent : Colors.grey.shade300,
              ),
            ),
            elevation: isActive ? 2 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final List<Map<String, dynamic>> metrics = [
      {
        'title': 'Ocupación',
        'value': '17%',
        'change': -78.0,
        'color': Colors.redAccent,
      },
      {
        'title': 'Ventas',
        'value': '1,099€',
        'change': -73.0,
        'color': Colors.redAccent,
      },
      {
        'title': 'Clientes',
        'value': '27',
        'change': 7.2,
        'color': Colors.green,
      },
      {
        'title': 'Ticket medio',
        'value': '41.41€',
        'change': -7.1,
        'color': Colors.redAccent,
      },
      {
        'title': 'Reservas Hoy',
        'value': '103',
        'change': 12.1,
        'color': Colors.green,
      },
      {
        'title': 'Rotación Mesas',
        'value': '2.8x',
        'change': 0.3,
        'color': Colors.green,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) => _buildMetricCard(metrics[index]),
    );
  }

  Widget _buildMetricCard(Map<String, dynamic> metric) {
    final bool isPositive = metric['change'] >= 0;
    final String changeText = isPositive
        ? '+${metric['change']}${metric['title'] == 'Rotación Mesas' ? '' : '%'}'
        : '${metric['change']}${metric['title'] == 'Rotación Mesas' ? '' : '%'}';
    final IconData trendIcon = isPositive
        ? Icons.trending_up
        : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Color.fromRGBO(
            (metric['color'] as Color).red,
            (metric['color'] as Color).green,
            (metric['color'] as Color).blue,
            0.5,
          ),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metric['title'],
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              if (metric['title'] == 'Ocupación')
                const Icon(
                  Icons.fiber_manual_record,
                  color: Colors.deepPurple,
                  size: 8,
                ),
            ],
          ),
          Text(
            metric['value'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              Icon(trendIcon, color: metric['color'], size: 16),
              const SizedBox(width: 4),
              Text(
                '~$changeText',
                style: TextStyle(
                  color: metric['color'],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAlerts() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Alertas Activas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Gestiona tus alertas activas',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF4B0082)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildIntelligentContext() {
    return const Text(
      'Contexto Inteligente',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
