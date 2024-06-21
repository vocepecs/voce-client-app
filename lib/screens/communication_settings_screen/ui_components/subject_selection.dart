import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/communication_settings_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/communication_settings_screen/ui_components/table_card_component.dart';
import 'package:voce/widgets/patient_card_component.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class SubjectSelectionScreen extends StatefulWidget {
  _SubjectSelectionScreen createState() => _SubjectSelectionScreen();
}

class _SubjectSelectionScreen extends State<SubjectSelectionScreen> {
  @override
  void initState() {
    super.initState();
    final communicationSettingsPanelCubit =
        BlocProvider.of<CommunicationSetupCubit>(context);
    communicationSettingsPanelCubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<CommunicationSetupCubit>(context);
    return BlocBuilder<CommunicationSetupCubit, CommunicationSetupState>(
      builder: (context, state) {
        if (state is CommunicationSetupLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: media.width * .4,
                      child: VocecaaCard(
                        padding: EdgeInsets.all(20),
                        hasShadow: false,
                        child: Container(
                            child: ListTile(
                          title: Text(
                            'Soggetto attivo',
                            style: GoogleFonts.poppins(
                              fontSize: media.width * .014,
                            ),
                          ),
                          subtitle: Text(
                            'Nickname',
                            style: GoogleFonts.poppins(
                              fontSize: media.width * .018,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.person_pin,
                            size: media.width * .05,
                            color: Colors.black54,
                          ),
                        )),
                      ),
                    ),
                    // state.caaTableList.isEmpty
                    //     ? Container(
                    //         width: media.width * .4,
                    //         child: VocecaaCard(
                    //           padding: EdgeInsets.all(20),
                    //           hasShadow: false,
                    //           child: Container(
                    //               child: ListTile(
                    //             title: Text(
                    //               'Nessuna tabella attiva',
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: media.width * .014,
                    //               ),
                    //             ),
                    //             subtitle: Text(
                    //               'Selezionarla dall\'elenco',
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: media.width * .018,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black,
                    //               ),
                    //             ),
                    //             trailing: Icon(
                    //               Icons.table_chart_rounded,
                    //               size: media.width * .05,
                    //               color: Colors.black54,
                    //             ),
                    //           )),
                    //         ))
                    //     : Container(
                    //         width: media.width * .4,
                    //         child: VocecaaCard(
                    //           padding: EdgeInsets.all(20),
                    //           hasShadow: false,
                    //           child: Container(
                    //               child: ListTile(
                    //             title: Text(
                    //               'Tabella attiva',
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: media.width * .014,
                    //               ),
                    //             ),
                    //             subtitle: Text(
                    //               cubit.getActiveTable().name,
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: media.width * .018,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black,
                    //               ),
                    //             ),
                    //             trailing: Icon(
                    //               Icons.table_chart_rounded,
                    //               size: media.width * .05,
                    //               color: Colors.black54,
                    //             ),
                    //           )),
                    //         ),
                    //       ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: media.width * .4,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Seleziona un soggetto dalla lista per sostituirlo a quello corrente',
                          style: GoogleFonts.poppins(
                            fontSize: media.width * .016,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * .4,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Seleziona una tabella dalla lista per sostituirla a quella corrente',
                          style: GoogleFonts.poppins(
                            fontSize: media.width * .016,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      state.patientList.isNotEmpty
                          ? Container(
                              width: media.width * .4,
                              child: ListView.separated(
                                itemBuilder: (context, index) => Container(
                                  child: VocecaaCard(
                                    padding: EdgeInsets.all(15),
                                    hasShadow: true,
                                    child: PatientCardComponent(
                                      patient: state.patientList[index],
                                      bottomRightActions: [
                                        VocecaaButton(
                                          color: Color(0xFFFFE45E),
                                          text: Text(
                                            'Seleziona',
                                            style: GoogleFonts.poppins(
                                              fontSize: media.width * .015,
                                            ),
                                          ),
                                          onTap: () {
                                            var cubit = BlocProvider.of<
                                                    CommunicationSetupCubit>(
                                                context);
                                            cubit.setActivePatient(
                                                state.patientList[index]);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, _) =>
                                    SizedBox(height: 8.0),
                                itemCount: state.patientList.length,
                              ),
                            )
                          : SizedBox(
                              width: media.width * .4,
                              height: media.height * .4,
                              child: VocecaaCard(
                                hasShadow: true,
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      'Non sono associati altri soggetti al tuo account',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: media.width * .018,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      cubit.existInactiveTables()
                          ? Container(
                              width: media.width * .4,
                              child: ListView.separated(
                                itemBuilder: (context, index) => VocecaaCard(
                                  padding: EdgeInsets.all(15),
                                  hasShadow: true,
                                  child: TableCardComponent(
                                    caaTable: cubit.getInactiveTables()[index],
                                    bottomRightActions: [
                                      VocecaaButton(
                                          color: Color(0xFFFFE45E),
                                          text: Text(
                                            'Seleziona',
                                            style: GoogleFonts.poppins(
                                              fontSize: media.width * .015,
                                            ),
                                          ),
                                          onTap: () {
                                            cubit.setActiveTable(cubit
                                                .getInactiveTables()[index]);
                                          })
                                    ],
                                  ),
                                ),
                                separatorBuilder: (context, _) =>
                                    SizedBox(height: 8.0),
                                itemCount: cubit.getInactiveTables().length,
                              ),
                            )
                          : SizedBox(
                              width: media.width * .4,
                              height: media.height * .4,
                              child: VocecaaCard(
                                hasShadow: true,
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      'Non sono presenti altre tabelle oltre a quella attiva',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: media.width * .018,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: ConstantGraphics.colorYellow,
            ),
          );
        }
      },
    );
  }
}
