import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voce/cubit/dedicated_cubits/download_centre_tables_cubit.dart';
import 'package:voce/cubit/dedicated_cubits/download_public_tables_cubit.dart';
import 'package:voce/cubit/dedicated_cubits/table_filter_panel_cubit.dart';
import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/link_table_to_patient_cubit.dart';
import 'package:voce/cubit/patient_screen_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/patient_screens/modal_sheets/mb_link_table.dart';
import 'package:voce/screens/table_screens/table_details_screen.dart';
import 'package:voce/services/speech_to_text_API.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientTablesManagementCard extends StatelessWidget {
  const PatientTablesManagementCard({
    Key? key,
    required this.patient,
  }) : super(key: key);

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<PatientScreenCubit>(context);
    return VocecaaCard(
      child: SizedBox(
        height: media.height * .17,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Gestisci le Tabelle',
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontSize: media.width * .014,
                fontWeight: FontWeight.bold,
              ),
            ),
            AutoSizeText(
              'Crea una nuova tabella oppure associane una già creata in precenza',
              maxLines: 2,
              style: GoogleFonts.poppins(
                fontSize: media.width * .014,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: media.width * .12,
                  child: VocecaaButton(
                      color: Color(0xFFFFE45E),
                      text: Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: media.width * .018,
                          ),
                          SizedBox(
                            width: media.width * .01,
                          ),
                          Text(
                            'Crea tabella',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<SpeechToTextCubit>(
                                    create: (context) => SpeechToTextCubit(),
                                  ),
                                  BlocProvider<TablePanelCubit>(
                                    create: (context) => TablePanelCubit(
                                      user: cubit.user,
                                      voceApiRepository: VoceAPIRepository(),
                                      tableOperation: CAAContentOperation
                                          .CREATE_PATIENT_ASSOCIATION,
                                      patient: patient,
                                    ),
                                  ),
                                  BlocProvider<TableContextCubit>(
                                    create: (context) => TableContextCubit(
                                      voceAPIRepository: VoceAPIRepository(),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => ImageListPanelCubit(
                                      voceAPIRepository: VoceAPIRepository(),
                                      user: cubit.user,
                                      patient: cubit.patient,
                                    ),
                                  )
                                ],
                                child: TableDetailsScreen(),
                              ),
                            )).then((_) {
                          var cubit =
                              BlocProvider.of<PatientScreenCubit>(context);
                          cubit.getPatientData();
                        });
                      }),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: media.width * .14,
                  child: VocecaaButton(
                    color: Color(0xFFFF6392),
                    text: Row(
                      children: [
                        Icon(
                          Icons.link,
                          size: media.width * .018,
                        ),
                        SizedBox(
                          width: media.width * .01,
                        ),
                        Text(
                          'Associa tabella',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => LinkTableToPatientCubit(
                                user: cubit.user,
                                voceAPIRepository: VoceAPIRepository(),
                                patient: patient,
                              ),
                            ),
                            BlocProvider(
                              create: (context) => DownloadPublicTablesCubit(
                                voceAPIRepository: VoceAPIRepository(),
                              ),
                            ),
                            BlocProvider(
                              create: (context) => DownloadCentreTablesCubit(
                                voceAPIRepository: VoceAPIRepository(),
                                user: cubit.user,
                              ),
                            ),
                            BlocProvider(
                              create: (context) => TableFilterPanelCubit(),
                            )
                          ],
                          child: MbLinkTable(),
                        ),
                        backgroundColor: Colors.black.withOpacity(0),
                        isScrollControlled: true,
                      ).then((_) {
                        var patientScreenCubit =
                            BlocProvider.of<PatientScreenCubit>(context);
                        patientScreenCubit.getPatientData();
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
