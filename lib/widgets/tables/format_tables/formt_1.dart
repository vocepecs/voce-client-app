import 'package:flutter/material.dart';
import 'package:voce/models/caa_table.dart';

class FormT1 extends StatelessWidget {
  const FormT1({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: media.width < 600 ? 4 : 4, // Numero di colonne
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
          color: Color(caaTable.sectorList.first.sectorColor),
        ),
      ),
    );
  }
}
