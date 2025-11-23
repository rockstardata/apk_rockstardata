import 'package:flutter/material.dart';

/// Tabla de asistentes por día para un solo local
class AsistentesPorDiaTable extends StatelessWidget {
  final List<int> asistentesDiarios;
  final List<String> dias;
  final List<int> fechas;

  const AsistentesPorDiaTable({
    super.key,
    required this.asistentesDiarios,
    this.dias = const ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
    this.fechas = const [17, 18, 19, 20, 21, 22, 23],
  });

  Color _getColorForValue(int value) {
    if (value == 0) return Colors.transparent;
    if (value >= 15) return const Color(0xFF2EB872); // Verde
    if (value >= 5) return const Color(0xFFFFA726); // Naranja
    return const Color(0xFFE53935); // Rojo
  }

  Widget _buildCell(String text, Color bgColor, {bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor == Colors.transparent ? Colors.white : bgColor,
        borderRadius: BorderRadius.circular(4),
        border: bgColor == Colors.transparent
            ? Border.all(color: Colors.grey.shade200)
            : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: bgColor == Colors.transparent || bgColor == const Color(0xFF2EB872)
                ? Colors.white
                : Colors.black87,
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSemanal = asistentesDiarios.fold<int>(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Número de Asistentes por día',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade200),
              columnWidths: {
                0: const FixedColumnWidth(120),
                for (int i = 1; i <= dias.length; i++)
                  i: const FixedColumnWidth(80),
                dias.length + 1: const FixedColumnWidth(100),
              },
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    _buildCell('Día', Colors.grey.shade100, isBold: true),
                    ...dias.asMap().entries.map((e) => _buildCell(
                          '${e.value}\n${fechas[e.key]}',
                          Colors.grey.shade100,
                          isBold: true,
                        )),
                    _buildCell('Total\nSemanal', Colors.grey.shade100, isBold: true),
                  ],
                ),
                // Data row
                TableRow(
                  children: [
                    _buildCell('Asistentes', Colors.white, isBold: true),
                    ...asistentesDiarios.map((value) => _buildCell(
                          value.toString(),
                          _getColorForValue(value),
                        )),
                    _buildCell(
                      totalSemanal.toString(),
                      const Color(0xFF2EB872),
                      isBold: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

