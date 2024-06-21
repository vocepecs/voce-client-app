import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/table_sector.dart';

class FormT3Right extends StatelessWidget {
  const FormT3Right({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width * .9,
      child: Row(
        children: [
          Expanded(
            flex: Platform.isAndroid ? 4 : 3,
            child: Column(
              children: [
                _buildTableSector(context, caaTable.sectorList[0], 0),
                Divider(
                  color: Colors.black87,
                  thickness: 2,
                ),
                Expanded(
                  child: _buildTableSector(context, caaTable.sectorList[2], 2),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.black87,
            thickness: 2,
          ),
          Expanded(
              child: _buildTableSector(context, caaTable.sectorList[1], 1)),
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
      height: sectorIndex == 1
          ? orientation == Orientation.portrait
              ? media.height * .4
              : Platform.isAndroid
                  ? media.height * .8
                  : media.height * .8
          : sectorIndex == 0
              ? orientation == Orientation.portrait
                  ? media.width < 600
                      ? media.height * .095
                      : media.height * .15
                  : Platform.isAndroid
                      ? media.height * .2
                      : media.height * .22
              : orientation == Orientation.portrait
                  ? media.height * .19
                  : media.height * .42,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: sectorIndex == 0 || sectorIndex == 1
                ? 1
                : media.width < 600
                    ? 3
                    : Platform.isAndroid
                        ? 4
                        : 3, // Numero di colonne
            mainAxisSpacing: 5.0, // Spazio verticale tra le righe
            crossAxisSpacing: 5.0,
            childAspectRatio: 1 // Spazio orizzontale tra le colonne
            ),
        padding: EdgeInsets.zero,
        scrollDirection: sectorIndex == 0 ? Axis.horizontal : Axis.vertical,
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
