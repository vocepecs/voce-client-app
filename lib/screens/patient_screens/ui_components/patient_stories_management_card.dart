import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/link_story_to_patient_cubit.dart';
import 'package:voce/cubit/patient_screen_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/screens/patient_screens/modal_sheets/mb_link_story.dart';
import 'package:voce/screens/social_stories_screens/social_story_creation_screen.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientStoriesManagementCard extends StatelessWidget {
  const PatientStoriesManagementCard({
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
              'Gestisci le Storie Sociali',
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontSize: media.width * .014,
                fontWeight: FontWeight.bold,
              ),
            ),
            AutoSizeText(
              'Crea una nuova storia sociale oppure associane una già creata in precenza',
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
                            'Crea storia',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) =>
                                          SocialStoryEditorCubit(
                                        voceAPIRepository: VoceAPIRepository(),
                                        user: cubit.user,
                                        patient: patient,
                                        caaContentOperation: CAAContentOperation
                                            .CREATE_PATIENT_ASSOCIATION,
                                        socialStory:
                                            SocialStory.createEmptySocialStory(
                                          cubit.user.id!,
                                          patientId: patient.id,
                                        ),
                                      ),
                                    ),
                                    BlocProvider(
                                      create: (context) => SpeechToTextCubit(),
                                    ),
                                  ],
                                  child: SocialStorycreationScreen(),
                                ),
                              )).then((_) {
                            cubit.getPatientData();
                          })),
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
                          'Associa storia',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => BlocProvider(
                            create: (context) => LinkStoryToPatientCubit(
                                  user: cubit.user,
                                  voceAPIRepository: VoceAPIRepository(),
                                  patient: patient,
                                ),
                            child: MbLinkStory()),
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
