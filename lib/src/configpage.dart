import 'package:aplicativo_01/src/dashboard.dart';
import 'package:flutter/material.dart';


// Datos de ejemplo para los tipos de negocio
const List<Map<String, dynamic>> _businessTypes = [
  {
    'id': 'casual',
    'icon': Icons.table_chart,
    'color': Colors.blueAccent,
    'title': 'Restaurante Casual',
    'subtitle': 'Comida casera, ambiente familiar',
    'details': 'Ideal para un alto volumen de clientes diarios con rotación media. Los márgenes de beneficio se optimizan con un control estricto de inventario y costos de personal. Enfoque en velocidad y servicio eficiente.',
    'kpis_ejemplo': 'Rotación de Mesas, Ticket Promedio por Hora, Tasa de Ocupación.'
  },
  {
    'id': 'fast_casual',
    'icon': Icons.fastfood,
    'color': Colors.orangeAccent,
    'title': 'Fast Casual',
    'subtitle': 'Comida rápida de calidad',
    'details': 'Se centra en la rapidez y la eficiencia de la línea de servicio. El objetivo principal es maximizar el número de transacciones y el flujo de clientes. La gestión del tiempo de preparación es crítica.',
    'kpis_ejemplo': 'Tiempo de Servicio, Número de Transacciones, Costo de Mercancía Vendida (CMV).'
  },
  {
    'id': 'gastronomico',
    'icon': Icons.local_bar,
    'color': Colors.pinkAccent,
    'title': 'Restaurante Gastronómico',
    'subtitle': 'Alta cocina, experiencia premium',
    'details': 'El foco está en la calidad de la experiencia y el servicio personalizado. La rotación de mesas es baja, pero el ticket promedio es muy alto. Es crucial medir la satisfacción del cliente y el rendimiento del personal.',
    'kpis_ejemplo': 'Ticket Promedio, Satisfacción del Cliente (NPS), Gasto por Cliente.'
  },
  {
    'id': 'cafe_bar',
    'icon': Icons.coffee,
    'color': Colors.brown,
    'title': 'Café & Bar',
    'subtitle': 'Desayunos, tapas y café',
    'details': 'Opera en múltiples franjas horarias (mañana, tarde, noche). La clave es la versatilidad de la oferta y la optimización de los costos de bebida. La fidelidad del cliente es muy importante.',
    'kpis_ejemplo': 'Ventas por Franja Horaria, Costo de Bebidas, Frecuencia de Visita del Cliente.'
  },
  {
    'id': 'pizzeria',
    'icon': Icons.local_pizza,
    'color': Colors.redAccent,
    'title': 'Pizzería',
    'subtitle': 'Pizza y comida italiana',
    'details': 'Alto enfoque en pedidos para llevar y entrega a domicilio. La eficiencia de la cocina y el manejo de pedidos externos son esenciales. El marketing digital y las promociones impulsan las ventas.',
    'kpis_ejemplo': 'Porcentaje de Venta a Domicilio, Tiempos de Entrega, Costo por Pedido.'
  },
];


class ConfiguracionInteligentePage extends StatefulWidget {
  const ConfiguracionInteligentePage({super.key});

  @override
  State<ConfiguracionInteligentePage> createState() => _ConfiguracionInteligentePageState();
}

class _ConfiguracionInteligentePageState extends State<ConfiguracionInteligentePage> {
  // Estado para controlar qué tarjeta está abierta. Si es null, ninguna lo está.
  String? _expandedCardId; 

  // Función para construir el Dashboard principal
  void _goToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DashboardPage(title: 'Dashboard de Análisis'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE8FF), // Fondo claro
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(), 
        ),
        title: const Text(
          'Configuración Inteligente',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Chip(
              label: Text('Restaurante Principal', style: TextStyle(color: Colors.deepPurple)),
              backgroundColor: Color(0xFFEFE8FF),
              avatar: Icon(Icons.location_on, size: 18, color: Colors.deepPurple),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BLOQUE PRINCIPAL DE CONFIGURACIÓN INTELIGENTE ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb_outline, color: Colors.deepPurple, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Configuración Inteligente',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Selecciona tu tipo de negocio para configuración automática',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  // Bloque de Beneficios
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E0FF), // Morado muy claro
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBenefitItem('Ahorra tiempo', 'Configuración en 30s'),
                        _buildBenefitItem('Datos reales', 'Basado en industria'),
                        _buildBenefitItem('Objetivos', 'Metas realistas'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            const Text(
              '¿Qué tipo de restaurante tienes?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 15),

            // --- LISTA DE TIPOS DE NEGOCIO ---
            ..._businessTypes.map((type) => _buildBusinessCard(
                  data: type,
                  isExpanded: _expandedCardId == type['id'],
                  onToggle: (id) {
                    setState(() {
                      _expandedCardId = (_expandedCardId == id) ? null : id;
                    });
                  },
                  onSelect: _goToDashboard,
                )).toList(),
            
            const SizedBox(height: 30),
            // Botón de Configuración Manual (Abajo)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _goToDashboard, // Por simplicidad, lleva al dashboard
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.deepPurple, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Configuración manual',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                '💡 Todos los valores se pueden personalizar después de\nla configuración inicial',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para los beneficios
  Widget _buildBenefitItem(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF4B0082)),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF4B0082)),
        ),
      ],
    );
  }

  // Widget auxiliar para las tarjetas de negocio con funcionalidad de expansión
  Widget _buildBusinessCard({
    required Map<String, dynamic> data,
    required bool isExpanded,
    required Function(String) onToggle,
    required VoidCallback onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded ? data['color'] : Colors.grey.shade200,
            width: isExpanded ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isExpanded ? 0.1 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Sección principal (siempre visible)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(data['icon'], color: data['color'], size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data['subtitle'],
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => onToggle(data['id']),
                    icon: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.deepPurple,
                    ),
                    label: Text(
                      isExpanded ? 'Ocultar detalles' : 'Ver detalles',
                      style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            
            // Sección de detalles (Desplegable)
            if (isExpanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.grey, height: 1, thickness: 0.2),
                    const SizedBox(height: 10),
                    // Descripción
                    Text(
                      'Descripción del modelo:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: data['color']),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data['details'],
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    // KPIs de Ejemplo
                    Text(
                      'KPIs clave:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: data['color']),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data['kpis_ejemplo'],
                      style: const TextStyle(fontSize: 14, color: Colors.black87, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 15),
                    // Botón de selección dentro del detalle
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onSelect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: data['color'],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Seleccionar este tipo de negocio',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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