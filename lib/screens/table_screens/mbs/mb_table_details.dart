import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/screens/auth_screens/mbs/mb_error.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_content.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_data.dart';
import 'package:voce/screens/table_screens/mbs/pages/page_table_format.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbTableDetails extends StatefulWidget {
  const MbTableDetails({
    Key? key,
    this.isNewTable = false,
    this.tableId,
  }) : super(key: key);

  final bool isNewTable;
  final int? tableId;

  @override
  State<MbTableDetails> createState() => _MbTableDetailsState();
}

class _MbTableDetailsState extends State<MbTableDetails> {
  @override
  void initState() {
    super.initState();
    final tablePanelCubit = BlocProvider.of<TablePanelCubit>(context);

    if (widget.isNewTable == false) {
      // tablePanelCubit.getTableData(widget.tableId!);
    } else {
      // tablePanelCubit.createEmptyTable();
    }

    final tableContextCubit = BlocProvider.of<TableContextCubit>(context);
    tableContextCubit.getTableContexts();

    //final imageListPanelCubit = BlocProvider.of<ImageListPanelCubit>(context);
    //imageListPanelCubit.getImageList();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<TablePanelCubit>(context);
    return BlocConsumer<TablePanelCubit, TablePanelState>(
      listener: (context, state) {
        if (state is TableCreated) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella creata!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TableCreationError) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              title: 'Errore nella creazione della tabella!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TableUpdated) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella aggiornata!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TableDuplicated) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella duplicata con successo!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is TableDeleted) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella eliminata con successo!',
              subtitle: 'Orai tornerai nella pagina di gestione delle tabelle',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        }
      },
      builder: (context, state) {
        if (state is TablePanelLoaded) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          Center(child: CloseLineTopModal()),
                          SizedBox(height: media.height * .05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.isNewTable
                                  ? Text(
                                      'Crea una tabella',
                                      style: GoogleFonts.poppins(
                                        fontSize: media.width * .02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Container(
                                      child: Text(
                                        state.caaTable.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: media.width * .02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              Container(
                                width: media.width * .5,
                                child: TabBar(
                                  indicator: BoxDecoration(
                                    color: Color(0xFFFFE45E),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  labelStyle: GoogleFonts.poppins(),
                                  tabs: [
                                    Tab(
                                      text: 'Dati',
                                    ),
                                    Tab(
                                      text: 'Forma',
                                    ),
                                    Tab(
                                      text: 'Contenuto',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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
                    cubit.isUserTableOwner()
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: _buildOptionButtons(cubit, media),
                            ),
                          )
                        : _buildDuplicateButton(cubit, media)
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
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

  List<Widget> _buildOptionButtons(TablePanelCubit cubit, Size media) {
    return <Widget>[
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
    ];
  }
}
