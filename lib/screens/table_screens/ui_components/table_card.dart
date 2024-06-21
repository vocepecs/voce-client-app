import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/caa_table.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:voce/widgets/vocecca_card.dart';

class TableCard extends StatelessWidget {
  const TableCard({
    Key? key,
    required this.caaTable,
    this.topRightActions = const <Widget>[],
    this.bottomRightActions = const <Widget>[],
    this.showTableType = true,
  }) : super(key: key);

  final CaaTable caaTable;
  final List<Widget> topRightActions;
  final List<Widget> bottomRightActions;
  final bool showTableType;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    initializeDateFormatting('it_IT', null);
    return VocecaaCard(
      hasShadow: true,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              height: isLandscape ? media.height * .2 : media.height * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  caaTable.imageStringCoding != null
                      ? SizedBox(
                          height: orientation == Orientation.landscape
                              ? media.height * .12
                              : orientation == Orientation.portrait
                                  ? media.height * .07
                                  : media.height * .25,
                          child: _imageFromBase64String(
                            caaTable.imageStringCoding!,
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: textBaseSize * .05,
                            ),
                          ),
                        ),
                  if (showTableType)
                    Container(
                      width: orientation == Orientation.landscape
                          ? media.width * .08
                          : media.width * .18,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[200],
                      ),
                      child: AutoSizeText(
                        (() {
                          if (caaTable.autismCentreId != null) {
                            return 'Centro';
                          } else if (caaTable.isPrivate) {
                            return 'Privata';
                          } else {
                            return 'Pubblica';
                          }
                        }()),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: textBaseSize * .011,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: ListTile(
                            dense: true,
                            minLeadingWidth: 0,
                            contentPadding: EdgeInsets.zero,
                            title: AutoSizeText(
                              caaTable.name,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: textBaseSize * .016,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  "\u{1F4C6} ${DateFormat('dd/MM/yyyy').format(caaTable.lastModifyDate ?? caaTable.creationDate)}",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                    fontSize: textBaseSize * .014,
                                  ),
                                ),
                                AutoSizeText(
                                  "\u{1F5BC}\u{FE0F} ${caaTable.getTotalNumberOfSymbols()}",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                    fontSize: textBaseSize * .014,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] +
                      topRightActions,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[] + bottomRightActions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Image _imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String.substring(2, base64String.length - 1)),
      fit: BoxFit.scaleDown,
    );
  }
}
