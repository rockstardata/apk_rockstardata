import 'package:flutter/material.dart';

class ChatAssistantPage extends StatelessWidget {
  const ChatAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 12,
                child: Icon(Icons.flash_on, color: Colors.white, size: 14),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Asistente IA',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'En línea',
                  style: TextStyle(color: Colors.green.shade600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF4B0082), size: 18),
                const SizedBox(width: 4),
                Text(
                  'Restaurante Principal',
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              reverse: true, // Para simular el chat desde abajo
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Mensajes de Ejemplo ---
                  
                  // Mensaje de Asistente (Informativo)
                  _buildAssistantMessage(
                    context,
                    '¡Hola! Soy tu asistente de La Cocina Dorada Madrid. Tengo acceso completo a tus datos: 85 plazas, 12 empleados, y objetivo de 13.500€/mes. ¿En qué te puedo ayudar?',
                  ),
                  const SizedBox(height: 10),

                  // Opciones de respuesta rápida
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildQuickReply('¿Cómo van las ventas?'),
                      _buildQuickReply('Ver reservas de mañana'),
                      _buildQuickReply('Analizar ocupación actual'),
                      _buildQuickReply('Detectar objetivos no cumplidos y sugerir acción'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Respuesta del usuario (Simulación)
                  _buildUserMessage(context, 'Detectar objetivos no cumplidos y sugerir acción'),
                  const SizedBox(height: 15),

                  // Mensaje del Asistente (Respuesta)
                  _buildAssistantMessage(
                    context,
                    'El objetivo de ventas del mes está al 85% a día 18. Para alcanzar la meta de 13.500€, necesitamos un 15% adicional (2.025€).',
                  ),
                  const SizedBox(height: 10),
                  
                  // Botones de acción del asistente
                  Row(
                    children: [
                      _buildAssistantButton('Sí', const Color(0xFF4B0082)),
                      const SizedBox(width: 10),
                      _buildAssistantButton('Más tarde', Colors.grey.shade400),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          
          // Barra de entrada de texto
          _buildInputBar(context),
        ],
      ),
    );
  }

  // Widget para botones de respuesta rápida
  Widget _buildQuickReply(String text) {
    return ActionChip(
      label: Text(text, style: TextStyle(color: Colors.black87, fontSize: 14)),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        // Lógica de envío de mensaje
      },
    );
  }

  // Widget para botones de acción del asistente
  Widget _buildAssistantButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Lógica de acción
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(text),
    );
  }
  
  // Widget para el mensaje del Asistente
  Widget _buildAssistantMessage(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Icon(Icons.bolt, color: Colors.deepPurple, size: 24),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 80, bottom: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E6FF), // Morado muy claro
              borderRadius: BorderRadius.circular(15).copyWith(topLeft: Radius.zero),
            ),
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  // Widget para el mensaje del Usuario
  Widget _buildUserMessage(BuildContext context, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(left: 80, bottom: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF4B0082), // Morado principal
              borderRadius: BorderRadius.circular(15).copyWith(topRight: Radius.zero),
            ),
            child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  // Widget para la barra de entrada de texto
  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Escribe tu pregunta...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4B0082),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                // Lógica para enviar mensaje
              },
            ),
          ),
        ],
      ),
    );
  }
}