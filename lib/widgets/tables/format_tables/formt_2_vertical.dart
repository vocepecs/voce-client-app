import 'package:flutter/material.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/table_sector.dart';

class FormT2Vertical extends StatelessWidget {
  const FormT2Vertical({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width * .9,
      child: Table(
        border: TableBorder(
            verticalInside: BorderSide(
          color: Colors.black87,
          width: 2,
        )),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
        },
        children: <TableRow>[
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTableSector(context, caaTable.sectorList[0], 0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTableSector(context, caaTable.sectorList[1], 1),
            ),
          ])
        ],
      ),
    );
  }

  Widget _buildTableSector(
    BuildContext context,
    TableSector ts,
    int sectorIndex,
  ) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      height: orientation == Orientation.portrait
          ? media.width < 600
              ? media.height * .3
              : media.height * .39
          : media.height * .8,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: media.width < 600 ? 2 : 4, // Numero di colonne
          mainAxisSpacing: 5.0, // Spazio verticale tra le righe
          crossAxisSpacing: 5.0,
          childAspectRatio: 1, // Spazio orizzontale tra le colonne
        ),
        itemCount: 16,
        itemBuilder: (context, index) => Container(
          // height: media.height * .2,
          // width: media.width * .13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            color: Color(caaTable.sectorList[sectorIndex].sectorColor),
          ),
        ),
      ),
    );
  }
}
