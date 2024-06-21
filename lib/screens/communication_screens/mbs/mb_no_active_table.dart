import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/set_active_table_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/patient_screens/ui_components/table_link_list_item.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbNoActiveTable extends StatefulWidget {
  const MbNoActiveTable({
    Key? key,
  }) : super(key: key);

  @override
  _MbNoActiveTableState createState() => _MbNoActiveTableState();
}

class _MbNoActiveTableState extends State<MbNoActiveTable> {
  @override
  void initState() {
    super.initState();
    var cubit = BlocProvider.of<SetActiveTableCubit>(context);
    cubit.createSelectableItemList();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<SetActiveTableCubit>(context);
    return BlocListener<SetActiveTableCubit, SetActiveTableState>(
      listener: (context, state) {
        if (state is SetActiveTableDone) {
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(
            24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: CloseLineTopModal()),
                  SizedBox(height: media.height * .05),
                  Container(
                    child: Text(
                      'Seleziona una tabella',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * .01),
                  Container(
                    child: Text(
                      'Al momento non è presente nessuna tabella attiva per la comunicazione.\nSelezionare un tabella tra quelle assegnate al soggetto per poter proseguire.',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .015,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SetActiveTableCubit, SetActiveTableState>(
                builder: (context, state) {
                  if (state is SetActiveTableLoaded) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 15,
                            runSpacing: 10,
                            children: List.generate(
                              state.tableList.length,
                              (index) {
                                CaaTable caaTable = state.tableList[index];
                                return TableListLinkItem(
                                  caaTable: caaTable,
                                  onTap: (value) {
                                    cubit.updateSelectableItemList(
                                        caaTable, value);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 150,
                padding: EdgeInsets.all(16),
                child: VocecaaButton(
                  color: Color(0xFFFFE45E),
                  text: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8.0),
                      Text(
                        'Salva',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  onTap: () => cubit.setActiveTable(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectableItem {
  final CaaTable caaTable;
  bool isSelected;

  SelectableItem({
    required this.caaTable,
    this.isSelected = false,
  });
}
