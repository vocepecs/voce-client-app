import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:voce/cubit/operator_communication_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/screens/auth_screens/mbs/mb_error.dart';
import 'package:voce/screens/communication_screens/ui_components/input_text.dart';
import 'package:voce/widgets/voce_speech_to_text_button.dart';
import 'package:voce/widgets/voce_speech_to_text_button_v2.dart';
import 'package:voce/widgets/vocecca_card.dart';

class OperatorPageTranslate extends StatefulWidget {
  const OperatorPageTranslate({Key? key}) : super(key: key);

  @override
  State<OperatorPageTranslate> createState() => _OperatorPageTranslateState();
}

class _OperatorPageTranslateState extends State<OperatorPageTranslate>
    with TickerProviderStateMixin {
  late AnimationController _translateAnimationController;
  late OperatorCommunicationCubit cubit;

  TextEditingController controller = TextEditingController();

  String test = "Test";

  @override
  void initState() {
    super.initState();

    _translateAnimationController = AnimationController(vsync: this);
    _translateAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _translateAnimationController.reset();
        _translateAnimationController.forward();
      }
    });

    cubit = BlocProvider.of<OperatorCommunicationCubit>(context);
  }

  @override
  void dispose() {
    _translateAnimationController.dispose();
    super.dispose();
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Traduzione frase\n",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: media.width * .015,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      "Utilizza l'apposita area di testo sottostante per compilare la frase da tradurre in sequenza di pittogrammi. Ogni volta che avvii una nuova traduzione andrai a sovrascrivere la frase appena tradotta.",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: media.width * .013,
                  ),
                )
              ]))),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OperatorInputTextArea(
                  onChanged: (value) {
                    cubit.updatePhrase(value);
                  },
                  controller: controller,
                  initialValue: cubit.getPhrase(),
                ),
                Column(
                  children: [
                    VoceSpeechToTextButtonV2(
                      onResult: (lastWords) {
                        cubit.updatePhrase(lastWords);
                        setState(() {
                          controller.text = lastWords;
                        });
                      },
                    ),
                    // BlocBuilder<SpeechToTextCubit, SpeechToTextState>(
                    //   builder: (context, state) {
                    //     return VoceSpeechToTextButton(
                    //       isRecording: state is SpeechToTextDone ||
                    //               state is SpeechToTextInitial ||
                    //               state is SpeechToTextTimeout
                    //           ? false
                    //           : true,
                    //     );
                    //   },
                    // ),
                    SizedBox(height: 10),
                    Container(
                      width: media.width * .2,
                      height: media.height * .11,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: BlocBuilder<OperatorCommunicationCubit,
                          OperatorCommunicationState>(
                        builder: (context, state) {
                          if (state is TranslationLoading) {
                            return Center(
                              child: Container(
                                width: media.width * .2,
                                child: Center(
                                  child: Lottie.network(
                                    "https://assets1.lottiefiles.com/packages/lf20_yMTq6U/photo.json",
                                    width: media.width * .3,
                                    controller: _translateAnimationController,
                                    onLoaded: (composition) {
                                      _translateAnimationController
                                        ..duration = composition.duration
                                        ..forward();
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                if (cubit.getPhrase().isEmpty) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => MbError(
                                      title: "Nessuna frase inserita",
                                      subtitle:
                                          "Inserire una frase per avviare la traduzione",
                                    ),
                                    backgroundColor:
                                        Colors.black.withOpacity(0),
                                    isScrollControlled: true,
                                  );
                                } else {
                                  cubit.translateAlgorithm();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.translate_rounded,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    AutoSizeText(
                                      'Avvia traduzione',
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;

    return VocecaaCard(
      child: Column(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "Traduzione frase\n",
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: media.height * .016,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text:
                  "Utilizza l'apposita area di testo sottostante per compilare la frase da tradurre in sequenza di pittogrammi. Ogni volta che avvii una nuova traduzione andrai a sovrascrivere la frase appena tradotta.",
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: media.height * .014,
              ),
            )
          ])),
          SizedBox(height: 10),
          // TextField(
          //   controller: controller,
          //   maxLines: 3,
          //   decoration: InputDecoration(
          //     labelText: 'Registrare una frase o inserire il testo manualmente',
          //     contentPadding: EdgeInsets.symmetric(
          //       horizontal: media.width * 0.01,
          //       vertical: media.height * 0.01,
          //     ),
          //     fillColor: Colors.white,
          //     filled: true,
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(15),
          //       ),
          //     ),
          //     floatingLabelBehavior: FloatingLabelBehavior.never,
          //   ),
          //   showCursor: true,
          //   style: GoogleFonts.poppins(
          //     fontSize: media.height * .015,
          //   ),
          //   onChanged: (value) {
          //     cubit.updatePhrase(value);
          //   },
          // ),
          OperatorInputTextArea(
            maxLines: 3,
            controller: controller,
            onChanged: (value) {
              cubit.updatePhrase(value);
            },
            initialValue: test,
          ),
          SizedBox(height: 10),
          VoceSpeechToTextButtonV2(
            onResult: (lastWords) {
              cubit.updatePhrase(lastWords);
              setState(() {
                controller.text = lastWords;
              });
            },
          ),
          // BlocBuilder<SpeechToTextCubit, SpeechToTextState>(
          //   builder: (context, state) {
          //     return VoceSpeechToTextButton(
          //       isRecording: state is SpeechToTextDone ||
          //               state is SpeechToTextInitial ||
          //               state is SpeechToTextTimeout
          //           ? false
          //           : true,
          //     );
          //   },
          // ),
          SizedBox(height: 10),
          Container(
            width: media.width * .9,
            height: media.height * .07,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: BlocBuilder<OperatorCommunicationCubit,
                OperatorCommunicationState>(
              builder: (context, state) {
                if (state is TranslationLoading) {
                  return Center(
                    child: Container(
                      width: media.width * .2,
                      child: Center(
                        child: Lottie.network(
                          "https://assets1.lottiefiles.com/packages/lf20_yMTq6U/photo.json",
                          width: media.width * .3,
                          controller: _translateAnimationController,
                          onLoaded: (composition) {
                            _translateAnimationController
                              ..duration = composition.duration
                              ..forward();
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      if (cubit.getPhrase().isEmpty) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => MbError(
                            title: "Nessuna frase inserita",
                            subtitle:
                                "Inserire una frase per avviare la traduzione",
                          ),
                          backgroundColor: Colors.black.withOpacity(0),
                          isScrollControlled: true,
                        );
                      } else {
                        cubit.translateAlgorithm();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.translate_rounded,
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          AutoSizeText(
                            'Avvia traduzione',
                            maxLines: 1,
                            style: GoogleFonts.poppins(),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? _buildLandscapeLayout()
        : _buildPortraitLayout();
  }
}
