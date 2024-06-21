import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/widgets/table_placeholder_1.dart';
import 'package:voce/widgets/table_placeholder_2.dart';
import 'package:voce/widgets/table_placeholder_2_horizontal.dart';
import 'package:voce/widgets/table_placeholder_3.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TableCardComponent extends StatelessWidget {
  const TableCardComponent({
    Key? key,
    required this.caaTable,
    this.topRightActions = const <Widget>[],
    this.bottomRightActions = const <Widget>[],
  }) : super(key: key);

  final CaaTable caaTable;
  final List<Widget> topRightActions;
  final List<Widget> bottomRightActions;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    initializeDateFormatting('it_IT', null);
    print(topRightActions.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                Builder(builder: (context) {
                  switch (caaTable.tableFormat) {
                    case TableFormat.SINGLE_SECTOR:
                      return TablePlaceholder1Icon();

                    case TableFormat.TWO_SECTORS_VERTICAL:
                      return TablePlaceholder2Icon(
                        highlightSectionList:
                            List.generate(2, (index) => false),
                      );

                    case TableFormat.TWO_SECTORS_HORIZONTAL:
                      return TablePlaceholder2HorizontalIcon(
                        highlightSectionList:
                            List.generate(2, (index) => false),
                      );

                    case TableFormat.THREE_SECTORS_RIGHT:
                      return TablePlaceholder3Icon(
                        highlightSectionList:
                            List.generate(3, (index) => false),
                      );

                    case TableFormat.THREE_SECTORS_LEFT:
                      return TablePlaceholder3Icon(
                        highlightSectionList:
                            List.generate(3, (index) => false),
                      );

                    case TableFormat.FOUR_SECTORS:
                      return TablePlaceholder3Icon(
                        highlightSectionList:
                            List.generate(4, (index) => false),
                      );
                  }
                }),
                SizedBox(width: 10),
                Text(
                  caaTable.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: media.width * .015,
                  ),
                ),
                Spacer(
                  flex: 10,
                ),
              ] +
              topRightActions,
        ),
        Text(
          'Creazione: ${DateFormat('dd/MM/yyyy').format(caaTable.creationDate)}',
          style: GoogleFonts.poppins(fontSize: media.width * .014),
        ),
        Text(
          'Ultima modifica: ${DateFormat('dd/MM/yyyy').format(caaTable.lastModifyDate ?? caaTable.creationDate)}',
          style: GoogleFonts.poppins(fontSize: media.width * .014),
        ),
        SizedBox(height: media.height * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
                Text(
                  'Numero simboli: ${caaTable.getTotalNumberOfSymbols()}',
                  style: GoogleFonts.poppins(fontSize: media.width * .014),
                ),
                Spacer(),
              ] +
              bottomRightActions,
        ),
      ],
    );
  }
}
