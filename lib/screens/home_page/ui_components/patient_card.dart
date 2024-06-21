import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dash_patient_grammatical_type_cubit.dart';
import 'package:voce/cubit/dash_patient_grammatical_type_focus_cubit.dart';
import 'package:voce/cubit/dash_patient_new_pictograms_cubit.dart';
import 'package:voce/cubit/home_page_cubit.dart';
import 'package:voce/cubit/dash_patient_image_count_cubit.dart';
import 'package:voce/cubit/dash_patient_phrase_stats_cubit.dart';
import 'package:voce/cubit/patient_screen_cubit.dart';
import 'package:voce/cubit/table_list_cubit.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/screens/patient_screens/patient_details_screen.dart';
import 'package:voce/services/dashboard_api.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({
    Key? key,
    required this.patient,
    required this.user,
    this.scaleBase = 1,
  }) : super(key: key);

  final Patient patient;
  final User user;
  final double scaleBase;

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return VocecaaCard(
      hasShadow: true,
      child: ListTile(
        dense: true,
        title: Text(
          patient.nickname,
          style: GoogleFonts.poppins(
            fontSize: currentOrientation == Orientation.landscape
                ? scaleBase * .015
                : scaleBase * .022,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: SizedBox(
          width: currentOrientation == Orientation.landscape
              ? scaleBase * .1
              : scaleBase * .15,
          child: VocecaaButton(
            color: Color(0xFFFFE45E),
            text: AutoSizeText(
              'Visualizza',
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontSize: currentOrientation == Orientation.landscape
                    ? scaleBase * .012
                    : scaleBase * .019,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => PatientScreenCubit(
                          voceAPIRepository: VoceAPIRepository(),
                          patient: patient,
                          user: user,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => DashPatientImageCountCubit(
                          dashboardApi: DashboardApi(),
                          patient: patient,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => DashPatientPhraseStatsCubit(
                          dashboardApi: DashboardApi(),
                          patient: patient,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => DashPatientNewPictogramsCubit(
                          dashboardApi: DashboardApi(),
                          patient: patient,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => DashPatientGrammaticalTypeCubit(
                          dashboardApi: DashboardApi(),
                          patient: patient,
                        ),
                      ),
                      BlocProvider(
                        create: (context) =>
                            DashPatientGrammaticalTypeFocusCubit(
                          dashboardApi: DashboardApi(),
                          patient: patient,
                        ),
                      ),
                    ],
                    child: PatientDetailsScreen(),
                  ),
                ),
              ).then((value) {
                var cubit = BlocProvider.of<HomePageCubit>(context);
                cubit.getUser();
              });
            },
          ),
        ),
      ),
    );
  }
}
