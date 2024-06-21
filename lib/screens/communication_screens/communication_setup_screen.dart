import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voce/cubit/communication_settings_panel_cubit.dart';
import 'package:voce/cubit/operator_communication_cubit.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/communication_screens/communication_screen.dart';
import 'package:voce/screens/table_screens/ui_components/table_card.dart';
import 'package:voce/services/speech_to_text_API.dart';
import 'package:voce/services/text_to_speech_api.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mixins/image_cover_mixin.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class CommunicationSetupScreen extends StatefulWidget with ImageCoverMixin {
  const CommunicationSetupScreen({Key? key}) : super(key: key);

  @override
  State<CommunicationSetupScreen> createState() =>
      _CommunicationSetupScreenState();
}

class _CommunicationSetupScreenState extends State<CommunicationSetupScreen> {
  late CommunicationSetupCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<CommunicationSetupCubit>(context);
  }

  Widget _buildLandScapeLayout() {
    Size media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          SizedBox(
            width: media.width * .3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Seleziona un profilo',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: BlocBuilder<CommunicationSetupCubit,
                          CommunicationSetupState>(
                        builder: (context, state) {
                          if (state is CommunicationSetupLoaded) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ListView.separated(
                                itemBuilder: (context, index) => ListTile(
                                  selected: state.patientList[index].isActive!,
                                  selectedTileColor: ConstantGraphics.colorBlue,
                                  selectedColor: Colors.black87,
                                  title: Text(
                                    state.patientList[index].nickname,
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                  shape: Border(
                                    left: BorderSide(
                                        width: 3,
                                        color: ConstantGraphics.colorBlue),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tabelle associate',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  trailing: TextButton(
                                    onPressed: () {
                                      cubit.setActivePatient(
                                          state.patientList[index]);
                                    },
                                    child: Text(
                                      'Seleziona',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 15,
                                ),
                                itemCount: state.patientList.length,
                              ),
                            );
                          } else if (state
                              is CommuncationSetupNoActivePatient) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ListView.separated(
                                itemBuilder: (context, index) => ListTile(
                                  selected: state.patientList[index].isActive!,
                                  selectedTileColor: ConstantGraphics.colorBlue,
                                  selectedColor: Colors.black87,
                                  title: Text(
                                    state.patientList[index].nickname,
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                  shape: Border(
                                    left: BorderSide(
                                        width: 3,
                                        color: ConstantGraphics.colorBlue),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tabelle associate',
                                        style:
                                            GoogleFonts.poppins(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  trailing: TextButton(
                                    onPressed: () {
                                      cubit.setActivePatient(
                                          state.patientList[index]);
                                    },
                                    child: Text(
                                      'Seleziona',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 15,
                                ),
                                itemCount: state.patientList.length,
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )),
                ),
              ],
            ),
          ),
          BlocBuilder<CommunicationSetupCubit, CommunicationSetupState>(
            builder: (context, state) {
              if (state is CommunicationSetupLoaded) {
                try {
                  List<CaaTable> tableList = state.patientList
                      .firstWhere((element) => element.isActive!)
                      .tableList;

                  if (tableList.isEmpty) {
                    if (state.userCaaTables!.isEmpty) {
                      return Expanded(
                        child: _buildTableSelectionPanel(
                          context: context,
                          caaTableList: state.defaultCaaTables!,
                          title:
                              "Non hai ancora creato tabelle CAA, selezionane una di Default per poter iniziare la sessione",
                          onTableSelected: (table) {
                            cubit.linkTableToPatient(table);
                          },
                        ),
                      );
                    } else {
                      return Expanded(
                        child: _buildTableSelectionPanel(
                          context: context,
                          caaTableList: state.userCaaTables!,
                          title:
                              "Seleziona una tabella da associare al profilo per iniziare la sessione",
                          onTableSelected: (table) {
                            cubit.linkTableToPatient(table);
                          },
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: _buildTableSelectionPanel(
                        context: context,
                        caaTableList: tableList,
                        title: "Seleziona una tabella per iniziare la sessione",
                        onTableSelected: (table) {
                          cubit.setActiveTable(table);
                        },
                      ),
                    );
                  }
                } catch (e) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Seleziona un profilo per scegliere\nla tabella da utilizzare',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleziona un profilo',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          BlocBuilder<CommunicationSetupCubit, CommunicationSetupState>(
            builder: (context, state) {
              if (state is CommunicationSetupLoaded ||
                  state is CommuncationSetupNoActivePatient) {
                List<Patient> patientList = state is CommunicationSetupLoaded
                    ? state.patientList
                    : (state as CommuncationSetupNoActivePatient).patientList;
                return Expanded(
                  flex: 4,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Numero di colonne
                      mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                      crossAxisSpacing: 10.0,
                      childAspectRatio: media.width < 600
                          ? 6 / 3
                          : 7 / 3, // Spazio orizzontale tra le colonne
                    ),
                    itemCount: patientList.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        cubit.setActivePatient(patientList[index]);
                      },
                      child: VocecaaCard(
                        backgroundColor: patientList[index].isActive!
                            ? ConstantGraphics.colorBlue
                            : Colors.white,
                        hasShadow: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: media.width * .2,
                              child: AutoSizeText(
                                patientList[index].nickname,
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          BlocBuilder<CommunicationSetupCubit, CommunicationSetupState>(
            builder: (context, state) {
              if (state is CommunicationSetupLoaded) {
                try {
                  List<CaaTable> tableList = state.patientList
                      .firstWhere((element) => element.isActive!)
                      .tableList;

                  if (tableList.isEmpty) {
                    if (state.userCaaTables!.isEmpty) {
                      return Expanded(
                        flex: 8,
                        child: _buildTableSelectionPanel(
                          context: context,
                          caaTableList: state.defaultCaaTables!,
                          title:
                              "Non hai ancora creato tabelle CAA, selezionane una di Default per poter iniziare la sessione",
                          onTableSelected: (table) {
                            cubit.linkTableToPatient(table);
                          },
                        ),
                      );
                    } else {
                      return Expanded(
                        flex: 8,
                        child: _buildTableSelectionPanel(
                          context: context,
                          caaTableList: state.userCaaTables!,
                          title:
                              "Seleziona una tabella da associare al profilo per iniziare la sessione",
                          onTableSelected: (table) {
                            cubit.linkTableToPatient(table);
                          },
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      flex: 8,
                      child: _buildTableSelectionPanel(
                        context: context,
                        caaTableList: tableList,
                        title: "Seleziona una tabella per iniziare la sessione",
                        onTableSelected: (table) {
                          cubit.setActiveTable(table);
                        },
                      ),
                    );
                  }
                } catch (e) {
                  return Expanded(
                    flex: 8,
                    child: Center(
                      child: Text(
                        'Seleziona un profilo per scegliere\nla tabella da utilizzare',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<CommunicationSetupCubit>(context);
    return BlocListener<CommunicationSetupCubit, CommunicationSetupState>(
      listener: (context, state) {
        if (state is CommunicationSetupEnded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<PatientCommunicationCubit>(
                    create: (context) => PatientCommunicationCubit(
                      voceApiRepository: VoceAPIRepository(),
                      ttsApi: TextToSpeechApi(),
                      user: cubit.user,
                    ),
                  ),
                  BlocProvider<OperatorCommunicationCubit>(
                    create: (context) => OperatorCommunicationCubit(
                      user: cubit.user,
                      voceAPIRepository: VoceAPIRepository(),
                      sttAPIRepository: SpeechToTextAPIRepository(
                        stt: SpeechToText(),
                      ),
                      caaTable: state.activeTable,
                      patient: state.activePatient,
                    ),
                  ),
                  BlocProvider<SpeechToTextCubit>(
                    create: (context) => SpeechToTextCubit(),
                  ),
                ],
                child: CommunicationScreen(user: cubit.user),
              ),
            ),
          ).then((_) {
            cubit.getData();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: AutoSizeText('Sessione Comunicativa'),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.grey[200],
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 25,
          ),
          iconTheme: IconThemeData(
            color: Colors.black87,
            size: 25,
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return _buildLandScapeLayout();
          } else {
            return _buildPortraitLayout();
          }
        }),
      ),
    );
  }

  Widget _buildTableSelectionPanel({
    required BuildContext context,
    required List<CaaTable> caaTableList,
    required String title,
    required Function(CaaTable table) onTableSelected,
  }) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
                mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                crossAxisSpacing: 10.0,
                childAspectRatio: orientation == Orientation.landscape
                    ? 6 / 3
                    : media.width < 600
                        ? 7 / 3
                        : 7 / 3, // Spazio orizzontale tra le colonne
              ),
              itemCount: caaTableList.length,
              itemBuilder: (context, index) => TableCard(
                caaTable: caaTableList[index],
                showTableType: false,
                bottomRightActions: [
                  VocecaaButton(
                    color: ConstantGraphics.colorBlue,
                    text: Text(
                      'Seleziona tabella CAA',
                      style: GoogleFonts.poppins(
                        fontSize: orientation == Orientation.landscape
                            ? media.width * .012
                            : media.height * .014,
                      ),
                    ),
                    onTap: () {
                      onTableSelected(caaTableList[index]);
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
