import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:voce/cubit/operator_communication_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/image.dart';
import 'package:voce/screens/auth_screens/mbs/mb_error.dart';
import 'package:voce/screens/communication_screens/ui_components/input_text.dart';
import 'package:voce/widgets/voce_speech_to_text_button.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram_selectable.dart';

class OperatorPageEdit extends StatefulWidget {
  const OperatorPageEdit({
    Key? key,
    required this.onCorrectionDone,
  }) : super(key: key);
  final Function() onCorrectionDone;

  @override
  State<OperatorPageEdit> createState() => _OperatorPageEditState();
}

class _OperatorPageEditState extends State<OperatorPageEdit>
    with TickerProviderStateMixin {
  late AnimationController _translateAnimationController;
  late OperatorCommunicationCubit cubit;

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

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: RichText(
          //       text: TextSpan(children: [
          //     TextSpan(
          //       text: "Correzione frase\n",
          //       style: GoogleFonts.poppins(
          //         color: Colors.black87,
          //         fontSize: media.width * .015,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     TextSpan(
          //       text:
          //           "In questa sezione puoi aggiungere i pittogrammi mancanti nella lista di quelli risultanti dalla traduzione effettuata. Ricerca l'immagine che desideri inserire e poi selezionala tra quelle proposte per aggiungerla in coda",
          //       style: GoogleFonts.poppins(
          //         color: Colors.black87,
          //         fontSize: media.width * .013,
          //       ),
          //     )
          //   ])),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Column(
          //         children: [
          //           OperatorInputTextArea(
          //             onChanged: (value) => cubit.updateSearchText(value),
          //             maxLines: 1,
          //           ),
          //           SizedBox(height: 20),
          //           OperatorInputTextArea(
          //             onChanged: (value) => cubit.updatePhrase(value),
          //             maxLines: 1,
          //             initialValue: cubit.getPhrase(),
          //           ),
          //         ],
          //       ),
          //       Column(
          //         children: [
          //           BlocBuilder<SpeechToTextCubit, SpeechToTextState>(
          //             builder: (context, state) {
          //               return VoceSpeechToTextButton(
          //                 isRecording: state is SpeechToTextDone ||
          //                         state is SpeechToTextInitial
          //                     ? false
          //                     : true,
          //               );
          //             },
          //           ),
          //           SizedBox(height: 10),
          //           Container(
          //             width: media.width * .2,
          //             height: media.height * .08,
          //             decoration: BoxDecoration(
          //               color: Colors.grey[300],
          //               borderRadius: BorderRadius.all(Radius.circular(15)),
          //             ),
          //             child: BlocBuilder<OperatorCommunicationCubit,
          //                 OperatorCommunicationState>(
          //               builder: (context, state) {
          //                 if (state is TranslationLoading) {
          //                   return Center(
          //                     child: Container(
          //                       width: media.width * .2,
          //                       child: Center(
          //                         child: Lottie.network(
          //                           "https://assets1.lottiefiles.com/packages/lf20_yMTq6U/photo.json",
          //                           width: media.width * .3,
          //                           controller: _translateAnimationController,
          //                           onLoaded: (composition) {
          //                             _translateAnimationController
          //                               ..duration = composition.duration
          //                               ..forward();
          //                           },
          //                         ),
          //                       ),
          //                     ),
          //                   );
          //                 } else {
          //                   return GestureDetector(
          //                     onTap: () {
          //                       cubit.searchImages();
          //                     },
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(15.0),
          //                       child: Row(
          //                         children: [
          //                           Icon(
          //                             Icons.search_rounded,
          //                             size: 25,
          //                           ),
          //                           SizedBox(width: 10),
          //                           AutoSizeText(
          //                             'Ricerca immagini',
          //                             maxLines: 1,
          //                             style: GoogleFonts.poppins(),
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                   );
          //                 }
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          BlocBuilder<OperatorCommunicationCubit, OperatorCommunicationState>(
            builder: (context, state) {
              if (state is TranslationDone) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildCustomSliverCorrectionPanel(
                            context,
                            state,
                          ),
                        ),
                        // Expanded(
                        //   child: ListView.separated(
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (context, index) =>
                        //         VocecaaPictogramSelectable(
                        //             caaImage: state.imageCorrectioList[index],
                        //             onTap: (value) {
                        //               if (value) {
                        //                 cubit.updateCorrectImageSelected(
                        //                   state.imageCorrectioList[index],
                        //                 );
                        //               } else {
                        //                 cubit.updateCorrectImageSelected(null);
                        //               }
                        //             },
                        //             isSelected: cubit
                        //                         .getCorrectImageSelected() !=
                        //                     null
                        //                 ? cubit.getCorrectImageSelected()!.id ==
                        //                     state.imageCorrectioList[index].id
                        //                 : false),
                        //     separatorBuilder: (context, index) =>
                        //         SizedBox(width: 10),
                        //     itemCount: state.imageCorrectioList.length,
                        //   ),
                        // ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: media.width * .12,
                              child: VocecaaButton(
                                color: ConstantGraphics.colorPink,
                                text: AutoSizeText(
                                  'Annulla Correzione',
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(),
                                ),
                                onTap: () {
                                  cubit.clearCorrection();
                                  widget.onCorrectionDone();
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: media.width * .1,
                              child: VocecaaButton(
                                color: ConstantGraphics.colorYellow,
                                text: Text(
                                  'Correggi',
                                  style: GoogleFonts.poppins(),
                                ),
                                onTap: () {
                                  if (cubit
                                      .getCorrectImageSelected()
                                      .isNotEmpty) {
                                    cubit.addCorrectionImage();
                                    widget.onCorrectionDone();
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => MbError(
                                        title: 'Problema nella correzione',
                                        subtitle:
                                            "Devi prima selezionare l'immagine per correggere la frase",
                                      ),
                                      backgroundColor:
                                          Colors.black.withOpacity(0),
                                      isScrollControlled: true,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildCustomSliverCorrectionPanel(
    BuildContext context,
    TranslationDone state,
  ) {
    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: state.imageCorrectioList.length,
          itemBuilder: (context, sliverIndex) {
            var key = state.imageCorrectioList.keys.toList()[sliverIndex];
            List<CaaImage>? imageList = state.imageCorrectioList[key];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: "Pittogrammi trovati per la parola ",
                      ),
                      TextSpan(
                        text: "$key",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .13,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => VocecaaPictogramSelectable(
                        caaImage: imageList![index],
                        onTap: (value) {
                          if (value) {
                            cubit.updateCorrectImageSelected(
                              imageList[index],
                            );
                          } else {
                            cubit.clearCorrectImageSelected();
                          }
                        },
                        isSelected: cubit
                            .getCorrectImageSelected()
                            .map((e) => e.id)
                            .contains(imageList[index].id)),
                    separatorBuilder: (_, __) => SizedBox(width: 10),
                    itemCount: imageList!.length,
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
