import 'package:flutter/material.dart';

class ComplexTable extends StatelessWidget {
  const ComplexTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Restaurante')),
            DataColumn(label: Text('V1')),
            DataColumn(label: Text('V2')),
            DataColumn(label: Text('V3')),
            DataColumn(label: Text('Total')),
          ],
          rows: const [
            DataRow(
              cells: [
                DataCell(Text('Pallapizza')),
                DataCell(Text('1.200 €')),
                DataCell(Text('800 €')),
                DataCell(Text('400 €')),
                DataCell(Text('2.400 €')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('Casa & Co')),
                DataCell(Text('950 €')),
                DataCell(Text('600 €')),
                DataCell(Text('350 €')),
                DataCell(Text('1.900 €')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
