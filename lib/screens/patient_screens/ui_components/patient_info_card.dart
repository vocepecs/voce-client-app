import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:voce/cubit/add_new_patient_cubit.dart';
import 'package:voce/cubit/patient_screen_cubit.dart';
import 'package:voce/models/enums/patient_operation.dart';
import 'package:voce/models/enums/vocal_profile.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/home_page/mbs/mb_add_new_patient.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientInfoCard extends StatelessWidget {
  const PatientInfoCard({
    Key? key,
    required this.patient,
  }) : super(key: key);

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<PatientScreenCubit>(context);
    Orientation orientation = MediaQuery.of(context).orientation;

    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;

    Widget _buildLandscapeLayout() {
      return VocecaaCard(
          child: SizedBox(
        height: media.height * .2,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  patient.vocalProfile == VocaProfile.MALE
                      ? "assets/icons/icon_boy.png"
                      : "assets/icons/icon_girl.png",
                  height: textBaseSize * .07,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      patient.nickname,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: textBaseSize * .02),
                    ),
                    // AutoSizeText(
                    //   "\u{1F382}  ${DateFormat('dd/MM/yyyy').format(patient.dateOfBirth)}",
                    //   maxLines: 1,
                    //   style: GoogleFonts.poppins(fontSize: textBaseSize * .014),
                    // ),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: orientation == Orientation.landscape
                            ? media.width * .12
                            : media.width * .3,
                        child: VocecaaButton(
                          color: Color(0xFFFFE45E),
                          text: Row(
                            children: [
                              Icon(Icons.mode),
                              SizedBox(
                                width: 8.0,
                              ),
                              AutoSizeText(
                                'Modifica',
                                maxLines: 1,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: textBaseSize * .016,
                                ),
                              )
                            ],
                          ),
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => BlocProvider(
                              child: MbAddNewPatient(),
                              create: (context) => AddNewPatientCubit(
                                user: cubit.user,
                                voceAPIRepository: VoceAPIRepository(),
                                patientOperation: PatientOperation.UPDATE,
                                patient: patient,
                              ),
                            ),
                            backgroundColor: Colors.black.withOpacity(0),
                            isScrollControlled: true,
                          ).then((_) {
                            var patientScreenCubit =
                                BlocProvider.of<PatientScreenCubit>(context);
                            patientScreenCubit.getPatientData();
                          }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ));
    }

    Widget _buildPortraitLayout() {
      return VocecaaCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                patient.vocalProfile == VocaProfile.MALE
                    ? "assets/icons/icon_boy.png"
                    : "assets/icons/icon_girl.png",
                height: textBaseSize * .07,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    patient.nickname,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: textBaseSize * .02),
                  ),
                  // AutoSizeText(
                  //   "\u{1F382}  ${DateFormat('dd/MM/yyyy').format(patient.dateOfBirth)}",
                  //   maxLines: 1,
                  //   style: GoogleFonts.poppins(
                  //     fontSize: textBaseSize * .014,
                  //   ),
                  // ),
                ],
              ),
            ),
            Spacer(),
            VocecaaButton(
              color: Color(0xFFFFE45E),
              text: AutoSizeText(
                'Modifica',
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: media.width < 600
                      ? textBaseSize * .015
                      : textBaseSize * .019,
                ),
              ),
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => BlocProvider(
                  child: MbAddNewPatient(),
                  create: (context) => AddNewPatientCubit(
                    user: cubit.user,
                    voceAPIRepository: VoceAPIRepository(),
                    patientOperation: PatientOperation.UPDATE,
                    patient: patient,
                  ),
                ),
                backgroundColor: Colors.black.withOpacity(0),
                isScrollControlled: true,
              ).then((_) {
                var patientScreenCubit =
                    BlocProvider.of<PatientScreenCubit>(context);
                patientScreenCubit.getPatientData();
              }),
            ),
          ],
        ),
      );
    }

    return orientation == Orientation.landscape
        ? _buildLandscapeLayout()
        : _buildPortraitLayout();
  }
}
