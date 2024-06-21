import 'package:flutter/material.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/table_sector.dart';

class FormT4 extends StatelessWidget {
  const FormT4({
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
          ),
          horizontalInside: BorderSide(
            color: Colors.black87,
            width: 2,
          ),
        ),
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
          ]),
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTableSector(context, caaTable.sectorList[2], 2),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTableSector(context, caaTable.sectorList[3], 3),
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
      height: orientation == Orientation.portrait ? media.width < 600 ? media.height * .14 : media.height * .18 : media.height * .4,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: media.width < 600 ? 2 : 2, // Numero di colonne
          mainAxisSpacing: 5.0, // Spazio verticale tra le righe
          crossAxisSpacing: 5.0,
          childAspectRatio: 1, // Spazio orizzontale tra le colonne
        ),
        padding: EdgeInsets.zero,
        itemCount: 15,
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
