import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:voce/cubit/add_new_patient_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/social_story_view_type.dart';
import 'package:voce/models/enums/vocal_profile.dart';
import 'package:voce/screens/home_page/mbs/ui_components/dropdown_vocal_profile.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/mbs/vocecaa_mbs_input_date.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class MbAddNewPatient extends StatefulWidget {
  const MbAddNewPatient({Key? key}) : super(key: key);

  @override
  State<MbAddNewPatient> createState() => _MbAddNewPatientState();
}

class _MbAddNewPatientState extends State<MbAddNewPatient> {
  late String _dateOfBirthText = '';
  late AddNewPatientCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<AddNewPatientCubit>(context);
    cubit.getPatientData();
  }

  Widget _buildModalHeader(double scaleBase) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: SizedBox(
          height: constraints.maxWidth < 600 ? 50 : 75,
          width: double.maxFinite,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Informazioni sul soggetto',
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: constraints.maxWidth < 600
                    ? scaleBase * .02
                    : scaleBase * .025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalFooter(double scaleBase) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              VocecaaButton(
                color: Colors.transparent,
                text: Text(
                  'Chiudi',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: constraints.maxWidth < 600
                        ? scaleBase * .018
                        : scaleBase * .02,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
              VocecaaButton(
                color: Color(0xFFFFE45E),
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.save,
                      size: constraints.maxWidth < 600
                          ? scaleBase * .025
                          : scaleBase * .028,
                    ),
                    SizedBox(
                      width: constraints.maxWidth < 600 ? 8.0 : 12.0,
                    ),
                    Text(
                      'Salva',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: constraints.maxWidth < 600
                            ? scaleBase * .018
                            : scaleBase * .02,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  cubit.savePatient();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLandscapeLayout({required double scaleBase}) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildModalHeader(scaleBase),
          BlocBuilder<AddNewPatientCubit, AddNewPatientState>(
            builder: (context, state) {
              if (state is PatientDataLoaded) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: scaleBase * .25,
                                child: VocecaaTextField(
                                  onChanged: (value) {
                                    cubit.updateName(value);
                                  },
                                  label: 'Nome',
                                  initialValue: state.patient.nickname,
                                ),
                              ),
                              // const SizedBox(height: 20.0),
                              // Container(
                              //   width: scaleBase * .25,
                              //   child: GestureDetector(
                              //     onTap: () =>
                              //         _buildInputDateBottomSheet(context),
                              //     child: VocecaaTextField(
                              //       onChanged: (value) {},
                              //       label: 'Data di nascita',
                              //       initialValue: (() {
                              //         try {
                              //           DateTime d = state.patient.dateOfBirth;
                              //           _dateOfBirthText =
                              //               DateFormat('dd-MM-yyyy').format(d);
                              //         } catch (e) {
                              //           // data non inizializzata
                              //         }
                              //         return _dateOfBirthText;
                              //       }()),
                              //       enable: false,
                              //       suffixIcon: Icon(Icons.calendar_today),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Spacer(),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: scaleBase * .5,
                                  child: VocecaaTextField(
                                    onChanged: (value) {
                                      cubit.updateNotes(value);
                                    },
                                    label: 'Note e appunti',
                                    initialValue: state.patient.notes!,
                                    maxLines: 5,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: scaleBase * .3,
                                      child: ListTile(
                                        title: Text(
                                          'Profilazione Vocale',
                                          style: GoogleFonts.poppins(
                                            fontSize: scaleBase * .013,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Seleziona il profilo vocale per il nuovo soggetto',
                                          style: GoogleFonts.poppins(
                                            fontSize: scaleBase * .013,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DropDownVocalProfile(
                                      onChanged: (newValue) {
                                        cubit.updateVocalProfile(newValue);
                                      },
                                      items: [
                                        'Maschio',
                                        'Femmina',
                                      ],
                                      initialValue: (() {
                                        switch (state.patient.vocalProfile) {
                                          case VocaProfile.MALE:
                                            return "Maschio";
                                          case VocaProfile.FEMALE:
                                            return "Femmina";
                                        }
                                      }()),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: scaleBase * .3,
                                      child: ListTile(
                                        title: Text(
                                          'Abilitazione TTS completo',
                                          style: GoogleFonts.poppins(
                                            fontSize: scaleBase * .013,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Se abilitato, nella sessione comunicativa, viene riprodotto l\'audio alla selezione del pittogramma all\'interno della tabella',
                                          style: GoogleFonts.poppins(
                                            fontSize: scaleBase * .013,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DropDownVocalProfile(
                                      onChanged: (newValue) {
                                        cubit.updateFullTtsEnabled(newValue);
                                      },
                                      items: [
                                        'Abilitato',
                                        'Disabilitato',
                                      ],
                                      initialValue: (() {
                                        if(state.patient.fullTtsEnabled){
                                          return "Abilitato";
                                        } else {
                                          return "Disabilitato";
                                        }
                                      }()),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: scaleBase * .3,
                                      child: ListTile(
                                        title: Text(
                                          'Visualizzazione storie sociali',
                                          style: GoogleFonts.poppins(
                                            fontSize: scaleBase * .013,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Seleziona il criterio di visualizzazione delle frasi delle storie sociali',
                                          style: GoogleFonts.poppins(
                                            fontSize: scaleBase * .013,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DropDownVocalProfile(
                                      onChanged: (newValue) {
                                        //cubit.updateVocalProfile(newValue);
                                        cubit.updateSocialStoryViewType(
                                            newValue);
                                      },
                                      items: [
                                        'Singola frase',
                                        'Frasi multiple'
                                      ],
                                      initialValue: (() {
                                        switch (
                                            state.patient.socialStoryViewType) {
                                          case SocialStoryViewType.SINGLE:
                                            return "Singola frase";
                                          case SocialStoryViewType.MULTIPLE:
                                            return "Frasi multiple";
                                        }
                                      }()),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          _buildModalFooter(scaleBase),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout({required double scaleBase}) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(24, scaleBase * .1, 24,
            24 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildModalHeader(scaleBase),
            BlocBuilder<AddNewPatientCubit, AddNewPatientState>(
              builder: (context, state) {
                if (state is PatientDataLoaded) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            VocecaaTextField(
                              onChanged: (value) {
                                cubit.updateName(value);
                              },
                              label: "Nome",
                              initialValue: state.patient.nickname,
                            ),
                            // const SizedBox(height: 20.0),
                            // GestureDetector(
                            //   onTap: () => _buildInputDateBottomSheet(context),
                            //   child: VocecaaTextField(
                            //     onChanged: (value) {},
                            //     label: 'Data di nascita',
                            //     initialValue: (() {
                            //       try {
                            //         DateTime d = state.patient.dateOfBirth;
                            //         _dateOfBirthText =
                            //             DateFormat('dd-MM-yyyy').format(d);
                            //       } catch (e) {
                            //         // data non inizializzata
                            //       }
                            //       return _dateOfBirthText;
                            //     }()),
                            //     enable: false,
                            //     suffixIcon: Icon(Icons.calendar_today),
                            //   ),
                            // ),
                            const SizedBox(height: 20.0),
                            VocecaaTextField(
                              onChanged: (value) {
                                cubit.updateNotes(value);
                              },
                              label: 'Note e appunti',
                              initialValue: state.patient.notes!,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      'Profilazione Vocale',
                                      style: GoogleFonts.poppins(
                                        fontSize: scaleBase * .015,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Seleziona il profilo vocale per il nuovo soggetto',
                                      style: GoogleFonts.poppins(
                                        fontSize: scaleBase * .015,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                DropDownVocalProfile(
                                  onChanged: (newValue) {
                                    cubit.updateVocalProfile(newValue);
                                  },
                                  items: [
                                    'Maschio',
                                    'Femmina',
                                  ],
                                  initialValue: (() {
                                    switch (state.patient.vocalProfile) {
                                      case VocaProfile.MALE:
                                        return "Maschio";
                                      case VocaProfile.FEMALE:
                                        return "Femmina";
                                    }
                                  }()),
                                )
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      'Abilitazione TTS completo',
                                      style: GoogleFonts.poppins(
                                        fontSize: scaleBase * .015,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Se abilitato, nella sessione comunicativa, viene riprodotto l'audio alla selezione del pittogramma all'interno della tabella",
                                      style: GoogleFonts.poppins(
                                        fontSize: scaleBase * .015,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                DropDownVocalProfile(
                                  onChanged: (newValue) {
                                    cubit.updateFullTtsEnabled(newValue);
                                  },
                                  items: ['Abilitato', 'Disabilitato'],
                                  initialValue: (() {
                                    if(state.patient.fullTtsEnabled){
                                      return "Abilitato";
                                    } else {
                                      return "Disabilitato";
                                    }
                                  }()),
                                )
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      'Visualizzazione storie sociali',
                                      style: GoogleFonts.poppins(
                                        fontSize: scaleBase * .015,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Seleziona come visualizzare le frasi delle storie sociali',
                                      style: GoogleFonts.poppins(
                                        fontSize: scaleBase * .015,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                DropDownVocalProfile(
                                  onChanged: (newValue) {
                                    cubit.updateSocialStoryViewType(newValue);
                                  },
                                  items: ['Singola frase', 'Frasi multiple'],
                                  initialValue: (() {
                                    switch (state.patient.socialStoryViewType) {
                                      case SocialStoryViewType.SINGLE:
                                        return "Singola frase";
                                      case SocialStoryViewType.MULTIPLE:
                                        return "Frasi multiple";
                                    }
                                  }()),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            _buildModalFooter(scaleBase),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    print("current width: ${media.width}");
    return BlocListener<AddNewPatientCubit, AddNewPatientState>(
      listener: (context, state) {
        if (state is AddNewPatientConfirmed ||
            state is PatientUpdatedSuccessfully) {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: "Profilo aggiornato",
              subtitle: "Il profilo CAA è stato aggiornato con successo!",
              animationPath: "assets/anim_confirm.json",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          );
        }
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return _buildLandscapeLayout(scaleBase: media.width);
          } else {
            return _buildPortraitLayout(scaleBase: media.height);
          }
        },
      ),
    );
  }

  void _buildInputDateBottomSheet(BuildContext context) {
    var cubit = BlocProvider.of<AddNewPatientCubit>(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => VocecaaMbsInputDate(
        onSetDate: (date) {
          cubit.updateDateOfBirth(date);
        },
        limitUpToday: true,
      ),
      backgroundColor: Colors.black.withOpacity(0),
      isScrollControlled: true,
    );
  }
}
