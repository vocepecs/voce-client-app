import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/link_table_to_patient_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/patient_screens/ui_components/table_link_list_item.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/panels/download_centre_tables_panel.dart';
import 'package:voce/widgets/panels/table_filter_panel.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbLinkTable extends StatefulWidget {
  const MbLinkTable({Key? key}) : super(key: key);

  @override
  State<MbLinkTable> createState() => _MbLinkTableState();
}

class _MbLinkTableState extends State<MbLinkTable> {
  @override
  void initState() {
    super.initState();
    var cubit = BlocProvider.of<LinkTableToPatientCubit>(context);
    cubit.getUserTables();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<LinkTableToPatientCubit>(context);
    return BlocListener<LinkTableToPatientCubit, LinkTableToPatientState>(
      listener: (context, state) {
        if (state is LinkTableToPatientAddedTables) {
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: CloseLineTopModal()),
                  SizedBox(height: media.height * .05),
                  Container(
                    child: AutoSizeText(
                      'Associa una tabella',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            Container(
              color: ConstantGraphics.colorBlue,
              height: media.height * .22,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Expanded(
                    flex: 25,
                    child: TableFilterPanel(user: cubit.user),
                  ),
                  Spacer(),
                  cubit.user.autismCentre != null
                      ? Expanded(
                          flex: 21,
                          child: DownloadCentreTablesPanel(),
                        )
                      : Container(),
                  Spacer()
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 15,
              child:
                  BlocBuilder<LinkTableToPatientCubit, LinkTableToPatientState>(
                builder: (context, state) {
                  if (state is LinkTableToPatientLoaded) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 15,
                            runSpacing: 10,
                            children: List.generate(
                              state.caaTableList.length,
                              (index) {
                                CaaTable caaTable = state.caaTableList[index];
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
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
                  onTap: () {
                    var cubit =
                        BlocProvider.of<LinkTableToPatientCubit>(context);
                    cubit.linkTableToPatient();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
