import 'package:flutter/material.dart';

class CompetenciaTable extends StatelessWidget {
  const CompetenciaTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 5),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 700),
          child: PaginatedDataTable(
            header: const Text('Ingresos por restaurante'),
            columns: const [
              DataColumn(
                label: Text(
                  'Restaurante',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'L\n17',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'M\n18',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'X\n19',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            source: _RestaurantDataSource(),
            rowsPerPage: 3,
            availableRowsPerPage: const [3, 5, 10],
            columnSpacing: 20,
            horizontalMargin: 20,
            showCheckboxColumn: false,
          ),
        ),
      ),
    );
  }
}

class _RestaurantDataSource extends DataTableSource {
  final List<Map<String, String>> _rows = [
    {
      'name': 'Bilbao',
      'd1': '154 €',
      'd2': '194 €',
      'd3': '0 €',
      'total': '348 €',
    },
    {
      'name': 'Burgos',
      'd1': '106 €',
      'd2': '189 €',
      'd3': '0 €',
      'total': '296 €',
    },
    {
      'name': 'Pamplona',
      'd1': '968 €',
      'd2': '735 €',
      'd3': '0 €',
      'total': '1.703 €',
    },
    {
      'name': 'San Sebastián',
      'd1': '215 €',
      'd2': '499 €',
      'd3': '0 €',
      'total': '715 €',
    },
    {
      'name': 'Zaragoza',
      'd1': '454 €',
      'd2': '709 €',
      'd3': '0 €',
      'total': '1.163 €',
    },
    {
      'name': 'Total',
      'd1': '1.970 €',
      'd2': '2.664 €',
      'd3': '0 €',
      'total': '4.634 €',
    },
  ];

  Color _getColorForValue(String val) {
    if (val.contains('0 €')) return Colors.transparent;
    if (val.length > 5) return const Color(0xFF2EB872);
    if (val.startsWith('1')) return const Color(0xFFD81B60);
    return Colors.orange;
  }

  Widget _buildColorCell(
    String value,
    Color bgColor, {
    Color textColor = Colors.white,
  }) {
    if (bgColor == Colors.transparent) textColor = Colors.black87;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  DataRow getRow(int index) {
    final row = _rows[index];
    final isTotalRow = row['name'] == 'Total';

    return DataRow.byIndex(
      index: index,
      color: MaterialStateProperty.all(
        isTotalRow ? Colors.grey.shade100 : null,
      ),
      cells: [
        DataCell(Text(row['name']!, style: const TextStyle(fontSize: 13))),
        DataCell(_buildColorCell(row['d1']!, _getColorForValue(row['d1']!))),
        DataCell(_buildColorCell(row['d2']!, _getColorForValue(row['d2']!))),
        DataCell(_buildColorCell(row['d3']!, _getColorForValue(row['d3']!))),
        DataCell(
          _buildColorCell(
            row['total']!,
            isTotalRow ? Colors.orange : _getColorForValue(row['total']!),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}
