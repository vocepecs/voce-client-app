import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_content.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_data.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_format.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class TableDetailScreenPortrait extends StatefulWidget {
  const TableDetailScreenPortrait({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<TableDetailScreenPortrait> createState() =>
      _TableDetailScreenPortraitState();
}

class _TableDetailScreenPortraitState extends State<TableDetailScreenPortrait> {
  PageController controller = PageController(initialPage: 0);
  int currentIndex = 0;

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
            "In questa pagina è possibile visualizzare le informazioni della tabella navigando con i pulsanti a basso (Dati, Formato, Contenuto).\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          RichText(
            textAlign: TextAlign.start,
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
    Size media = MediaQuery.of(context).size;
    double textBaseSize = media.height;
    return Scaffold(
      backgroundColor: ConstantGraphics.colorBlue,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: false,
        backgroundColor: ConstantGraphics.colorBlue,
        elevation: 0,
        title: Text(
          widget.caaTable.name.isEmpty ? "Crea tabella" : widget.caaTable.name,
          style: GoogleFonts.poppins(
              fontSize: textBaseSize * .02,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () => _showInfoModal(),
            icon: Image.asset("assets/icons/icon_info.png"),
          ),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          PageTableData(),
          PageTableFormat(),
          PageTableContent(),
        ],
      ),
      persistentFooterButtons: [
        _buildOwnerButtons(),
      ],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 5,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: ConstantGraphics.colorBlue,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(),
        onTap: ((value) {
          setState(() {
            currentIndex = value;
            controller.animateToPage(
              value,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInSine,
            );
          });
        }),
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/icon_form_inactive.png",
                height: 30,
              ),
              activeIcon: Image.asset(
                "assets/icons/icon_form.png",
                height: 30,
              ),
              label: "Dati"),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/icon_table_inactive.png",
              height: 30,
            ),
            activeIcon: Image.asset(
              "assets/icons/icon_table.png",
              height: 30,
            ),
            label: 'Formato',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/icon_image_content_inactive.png",
              height: 30,
            ),
            activeIcon: Image.asset(
              "assets/icons/icon_image_content.png",
              height: 30,
            ),
            label: 'Contenuto',
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerButtons() {
    Size media = MediaQuery.of(context).size;
    TablePanelCubit cubit = BlocProvider.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (cubit.tableOperation == CAAContentOperation.UPDATE)
            VocecaaButton(
                color: Color(0xFFFFE45E),
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.add_circle_outline_outlined),
                    SizedBox(width: 3),
                    Text(
                      'Duplica',
                      style: GoogleFonts.poppins(fontSize: media.height * .013),
                    )
                  ],
                ),
                onTap: () {
                  cubit.duplicateTable();
                }),
          if (cubit.tableOperation == CAAContentOperation.UPDATE &&
              cubit.isUserTableOwner())
            SizedBox(width: 8.0),
          if (cubit.tableOperation == CAAContentOperation.UPDATE &&
              cubit.isUserTableOwner())
            VocecaaButton(
                color: Colors.red[200]!,
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.delete_outline_rounded),
                    SizedBox(width: 3),
                    Text(
                      'Elimina',
                      style: GoogleFonts.poppins(fontSize: media.height * .013),
                    )
                  ],
                ),
                onTap: () {
                  cubit.deleteTable();
                }),
          if (cubit.tableOperation == CAAContentOperation.UPDATE &&
              cubit.isUserTableOwner())
            SizedBox(width: 8.0),
          if (cubit.isUserTableOwner())
            VocecaaButton(
              color: Color(0xFFFFE45E),
              text: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.save_as_outlined),
                  SizedBox(width: 3),
                  Text(
                    'Salva le modifiche',
                    style: GoogleFonts.poppins(fontSize: media.height * .013),
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
