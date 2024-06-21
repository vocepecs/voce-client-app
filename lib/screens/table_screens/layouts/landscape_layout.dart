import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_content.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_data.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_format.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class TableDetailScreenLandscape extends StatefulWidget {
  const TableDetailScreenLandscape({Key? key}) : super(key: key);

  @override
  State<TableDetailScreenLandscape> createState() =>
      _TableDetailScreenLandscapeState();
}

class _TableDetailScreenLandscapeState
    extends State<TableDetailScreenLandscape> {
  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Tabella CAA",
        contents: [
          Text(
            "In questa pagina è possibile visualizzare le informazioni della tabella navigando con i pulsanti in alto (Dati, Formato, Contenuto).\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text:
                      "Una volta apportate le dovute modifiche, clicca sul pulsante ",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "Salva le modifiche ",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "per creare o aggiornare la tabella CAA",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "Oppure clicca sul pulsante ",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "Elimina ",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text:
                      " per eliminare la tabella (se stai modificando una tabella già creata)\n\n",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    TablePanelCubit cubit = BlocProvider.of(context);
    Size media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<TablePanelCubit, TablePanelState>(
        builder: (context, state) {
          if (state is TablePanelLoaded) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: DefaultTabController(
                length: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: ConstantGraphics.colorBlue,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          media.width * .01,
                          media.height * .05,
                          media.width * .05,
                          media.height * .01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: media.width * .02,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            SizedBox(
                              width: media.width * .2,
                              child: AutoSizeText(
                                state.caaTable.name.isEmpty
                                    ? 'Crea Tabella'
                                    : state.caaTable.name,
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  fontSize: media.width * .02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: media.width * .5,
                              child: TabBar(
                                indicator: BoxDecoration(
                                  color: Color(0xFFFFE45E),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: media.width * .013,
                                  fontWeight: FontWeight.bold,
                                ),
                                tabs: [
                                  Tab(
                                    text: 'Dati',
                                  ),
                                  Tab(
                                    text: 'Formato',
                                  ),
                                  Tab(
                                    text: 'Contenuto',
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () => _showInfoModal(),
                              icon: Image.asset("assets/icons/icon_info.png"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          PageTableData(),
                          PageTableFormat(),
                          PageTableContent(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildOptionButtons(context, cubit),
                    SizedBox(height: 10)
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildOptionButtons(BuildContext context, TablePanelCubit cubit) {
    Size media = MediaQuery.of(context).size;
    if (cubit.isUserTableOwner() &&
        cubit.tableOperation == CAAContentOperation.UPDATE) {
      return _buildOwnerButtons(cubit, media);
    } else {
      if (cubit.tableOperation == CAAContentOperation.UPDATE) {
        return _buildDuplicateButton(cubit, media);
      } else {
        return _buildSaveButton(cubit, media);
      }
    }
  }

  Widget _buildDuplicateButton(TablePanelCubit cubit, Size media) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(16),
        child: VocecaaButton(
            color: Color(0xFFFFE45E),
            text: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.add_circle_outline_outlined),
                SizedBox(width: 3),
                Text(
                  'Duplica',
                  style: GoogleFonts.poppins(fontSize: media.width * .013),
                )
              ],
            ),
            onTap: () {
              cubit.duplicateTable();
            }),
      ),
    );
  }

  Widget _buildSaveButton(TablePanelCubit cubit, Size media) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: media.width * .16,
          child: VocecaaButton(
            color: Color(0xFFFFE45E),
            text: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.save_as_outlined),
                SizedBox(width: 3),
                AutoSizeText(
                  'Crea tabella',
                  maxLines: 1,
                  style: GoogleFonts.poppins(fontSize: media.width * .013),
                )
              ],
            ),
            onTap: () {
              cubit.saveTable();
              //Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerButtons(TablePanelCubit cubit, Size media) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VocecaaButton(
              color: Color(0xFFFFE45E),
              text: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.add_circle_outline_outlined),
                  SizedBox(width: 3),
                  Text(
                    'Duplica',
                    style: GoogleFonts.poppins(fontSize: media.width * .013),
                  )
                ],
              ),
              onTap: () {
                cubit.duplicateTable();
              }),
          SizedBox(width: 8.0),
          VocecaaButton(
              color: Colors.red[200]!,
              text: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.delete_outline_rounded),
                  SizedBox(width: 3),
                  Text(
                    'Elimina',
                    style: GoogleFonts.poppins(fontSize: media.width * .013),
                  )
                ],
              ),
              onTap: () {
                cubit.deleteTable();
              }),
          SizedBox(width: 8.0),
          VocecaaButton(
            color: Color(0xFFFFE45E),
            text: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.save_as_outlined),
                SizedBox(width: 3),
                Text(
                  'Salva le modifiche',
                  style: GoogleFonts.poppins(fontSize: media.width * .013),
                )
              ],
            ),
            onTap: () {
              cubit.saveTable();
              //Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
