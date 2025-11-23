import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  // Datos de ejemplo para las situaciones detectadas
  final List<Map<String, dynamic>> _situationsData = const [
    {
      'icon': Icons.trending_down,
      'icon_color': Colors.red,
      'title': 'Caída en ventas detectada.',
      'subtitle':
          'Las ventas han bajado un 15% respecto a ayer (1.847€ vs 2.165€). Esto coincide con que tienes solo 8 personas para el turno actual vs las 10 habituales. (Últimas 6 horas - Restaurante Principal)',
      'buttons': ['¿Llamamos a alguien?', 'Datos ventas'],
    },
    {
      'icon': Icons.lightbulb_outline,
      'icon_color': Colors.orange,
      'title': 'Alta ocupación mañana.',
      'subtitle':
          'El 85% de las mesas están reservadas mañana (38 reservas de 45 mesas). Te sugiero revisar el planning de personal y preparar stock adicional. (Reservas confirmadas Restaurante Principal)',
      'buttons': ['Revisar planning', 'Lista reservas'],
    },
    {
      'icon': Icons.attach_money,
      'icon_color': Colors.orange,
      'title': 'Ticket medio bajando.',
      'subtitle':
          'Esta semana el ticket medio ha bajado a 22€ (vs objetivo 28€). ¿Quieres que analicemos qué productos se están vendiendo menos? (Análisis semanal Restaurante Principal)',
      'buttons': ['Analizar productos', 'Gráfico tendencia'],
    },
    {
      'icon': Icons.timer,
      'icon_color': Colors.deepPurple,
      'title': 'Patrón tiempo de espera.',
      'subtitle':
          'Los sábados por la noche el tiempo de espera sube consistentemente a más de 15 minutos en Restaurante Principal. ¿Quieres que configure una alerta automática? (Últimos 4 fines de semana)',
      'buttons': ['Configurar alerta', 'Histórico datos'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B0082), // Morado Principal
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Alertas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Lógica de configuración de alertas
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Situaciones Detectadas
            Container(
              color: const Color(0xFF4B0082), // Fondo morado superior
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5), // Fondo gris del cuerpo
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Situaciones detectadas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Lógica para ir al chat
                          },
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('Conversar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4B0082),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Lista de Alertas
                    ..._situationsData
                        .map(
                          (situation) =>
                              _buildSituationCard(context, situation),
                        )
                        .toList(),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSituationCard(
    BuildContext context,
    Map<String, dynamic> situation,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono con color de alerta
              Icon(
                situation['icon'] as IconData,
                color: situation['icon_color'] as Color,
                size: 24,
              ),
              const SizedBox(width: 10),
              // Título y Subtítulo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      situation['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      situation['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Botones de acción
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: (situation['buttons'] as List<String>).map((buttonText) {
              return ElevatedButton(
                onPressed: () {
                  // Lógica para cada acción (e.g., navegar a la página de Datos)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B0082),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Text(buttonText, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
