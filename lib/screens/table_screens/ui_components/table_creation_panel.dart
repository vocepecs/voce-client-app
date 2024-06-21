import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/table_placeholder_1.dart';
import 'package:voce/widgets/table_placeholder_2.dart';
import 'package:voce/widgets/table_placeholder_2_horizontal.dart';
import 'package:voce/widgets/table_placeholder_3.dart';
import 'package:voce/widgets/table_placeholder_3_reverse.dart';
import 'package:voce/widgets/table_placeholder_4.dart';

class TableCreationPanel extends StatelessWidget {
  const TableCreationPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      height: media.height * .18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Gestione tabelle',
            style: GoogleFonts.poppins(
              fontSize: media.width * .015,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Seleziona un formato per creare una nuova tabella',
            style: GoogleFonts.poppins(
              fontSize: media.width * .014,
            ),
          ),
          Spacer(),
          Container(
            // width: media.width * .3,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TablePlaceholder1(),
                TablePlaceholder2(),
                TablePlaceholder3(),
                TablePlaceholder4(),
                TablePlaceholder2Horizontal(),
                TablePlaceholder3Reverse(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
