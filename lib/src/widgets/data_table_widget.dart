import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<List<String>> rows;
  final List<Color?>?
  rowColors; // Opcional para colorear celdas específicas (ej. botones)

  const DataTableWidget({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    this.rowColors,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Botón de descarga opcional (mock)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple.shade100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.download, size: 14, color: Colors.purple),
                    const SizedBox(width: 4),
                    Text(
                      'Descargar',
                      style: TextStyle(fontSize: 12, color: Colors.purple),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 40,
                  dataRowMinHeight: 40,
                  columnSpacing: 20,
                  columns: columns
                      .map(
                        (c) => DataColumn(
                          label: Text(
                            c,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  rows: List.generate(rows.length, (index) {
                    final row = rows[index];
                    return DataRow(
                      cells: List.generate(row.length, (cellIndex) {
                        // Lógica específica para colorear la última celda si es necesario (ej. botones de estado)
                        final isLast = cellIndex == row.length - 1;
                        final content = row[cellIndex];

                        if (isLast &&
                            (content.contains('€') || content.contains('%'))) {
                          // Estilo de "botón" o badge para valores numéricos destacados
                          return DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getColorForValue(content),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                content,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }

                        return DataCell(
                          Text(content, style: const TextStyle(fontSize: 12)),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForValue(String val) {
    // Lógica simple para colores basada en el contenido mock
    if (val.contains('1.600') || val.contains('1.500'))
      return const Color(0xFFD81B60); // Rojo/Rosa
    if (val.contains('1.300') || val.contains('1.050'))
      return const Color(0xFFFFA726); // Naranja
    if (val.contains('1.950')) return const Color(0xFFFFA726);
    if (val.contains('28.194')) return const Color(0xFF2EB872); // Verde
    if (val.contains('7.316')) return const Color(0xFF2EB872);
    if (val.contains('4.646')) return const Color(0xFF2EB872);
    return Colors.grey;
  }
}
