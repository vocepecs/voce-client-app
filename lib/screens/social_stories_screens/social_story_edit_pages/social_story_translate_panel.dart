import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/widgets/voce_speech_to_text_button.dart';
import 'package:voce/widgets/voce_speech_to_text_button_v2.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'dart:math' as math;

import 'package:voce/widgets/vocecaa_text_field.dart';

class SocialStoryTranslatePanel extends StatefulWidget {
  const SocialStoryTranslatePanel({Key? key}) : super(key: key);

  @override
  State<SocialStoryTranslatePanel> createState() =>
      _SocialStoryTranslatePanelState();
}

class _SocialStoryTranslatePanelState extends State<SocialStoryTranslatePanel> {
  final TextEditingController textController = TextEditingController();

  late SocialStoryEditorCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.grey[200],
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToExpand: true,
            tapBodyToCollapse: true,
            hasIcon: false,
          ),
          header: Container(
            width: media.width * .9,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      'Pannello di traduzione',
                      style: GoogleFonts.poppins(
                        fontSize: orientation == Orientation.landscape
                            ? media.width * .016
                            : media.height * .016,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    ExpandableIcon(
                      theme: ExpandableThemeData(
                        expandIcon: Icons.keyboard_arrow_right_outlined,
                        collapseIcon: Icons.keyboard_arrow_down_rounded,
                        iconColor: Colors.black87,
                        iconSize: orientation == Orientation.landscape
                            ? media.width * .03
                            : media.height * .03,
                        iconRotationAngle: math.pi / 2,
                        iconPadding: EdgeInsets.only(right: 5),
                        hasIcon: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          collapsed: Container(),
          expanded: Container(
            height: media.height * .23,
            padding: EdgeInsets.all(10.0),
            child: orientation == Orientation.landscape
                ? _buildLandscapeLayout()
                : _buildPortraitLayout(),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 15,
          // width: media.width * .75,
          // height: media.height * .28,
          child: VocecaaTextField(
            controller: textController,
            maxLines: 3,
            onChanged: (value) {
              cubit.updateTextToTranslate(value);
            },
            label: 'Inserisci il testo da tradurre',
            initialValue: cubit.textToTranslate,
          ),
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Spacer(),
            SizedBox(
              width: media.width * .16,
              // height: media.height * .1,
              child: VoceSpeechToTextButtonV2(
                onResult: (lastWords) {
                  cubit.updateTextToTranslate(lastWords);
                  setState(() {
                    textController.text = lastWords;
                  });
                },
              ),
            ),
            // BlocConsumer<SpeechToTextCubit, SpeechToTextState>(
            //   listener: (context, state) {
            //     if (state is SpeechToTextDone) {
            //       cubit.updateTextToTranslate(state.result);
            //       setState(() {
            //         textController.text = state.result;
            //       });
            //     }
            //   },
            //   builder: (context, state) {
            //     return SizedBox(
            //       width: media.width * .15,
            //       height: media.height * .1,
            //       child: VoceSpeechToTextButton(
            //         isRecording: state is SpeechToTextDone ||
            //                 state is SpeechToTextInitial ||
            //                 state is SpeechToTextTimeout
            //             ? false
            //             : true,
            //       ),
            //     );
            //   },
            // ),
            Spacer(),
            SizedBox(
              width: media.width * .16,
              child: VocecaaButton(
                color: Colors.grey[300]!,
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.translate_rounded),
                    SizedBox(width: 3),
                    Text(
                      'Traduci',
                      style: GoogleFonts.poppins(fontSize: media.width * .013),
                    )
                  ],
                ),
                onTap: () {
                  cubit.createNewSession();
                },
              ),
            ),
            Spacer(),
            // SizedBox(
            //   width: media.width * .15,
            //   child: VocecaaButton(
            //     color: Color(0xFFFFE45E),
            //     text: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Icon(Icons.add_photo_alternate_rounded),
            //         SizedBox(width: 3),
            //         Text(
            //           'Aggiungi',
            //           style: GoogleFonts.poppins(
            //               fontSize: media.width * .013),
            //         )
            //       ],
            //     ),
            //     onTap: () {
            //       cubit.createNewSession(concatenate: true);
            //     },
            //   ),
            // ),
            // Spacer()
          ],
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 15,
          // width: media.width * .75,
          // height: media.height * .28,
          child: VocecaaTextField(
            controller: textController,
            maxLines: 3,
            onChanged: (value) {
              cubit.updateTextToTranslate(value);
            },
            label: 'Inserisci il testo da tradurre',
            initialValue: cubit.textToTranslate,
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: media.width * .45,
              height: media.height * .05,
              child: VoceSpeechToTextButtonV2(
                onResult: (lastWords) {
                  cubit.updateTextToTranslate(lastWords);
                  setState(() {
                    textController.text = lastWords;
                  });
                },
              ),
            ),
            // BlocConsumer<SpeechToTextCubit, SpeechToTextState>(
            //   listener: (context, state) {
            //     if (state is SpeechToTextDone) {
            //       cubit.updateTextToTranslate(state.result);
            //       setState(() {
            //         textController.text = state.result;
            //       });
            //     }
            //   },
            //   builder: (context, state) {
            //     return SizedBox(
            //       width: media.width * .45,
            //       height: media.height * .05,
            //       child: VoceSpeechToTextButtonV2(
            //         onResult: (lastWords) {
            //           cubit.updateTextToTranslate(lastWords);
            //           setState(() {
            //             textController.text = lastWords;
            //           });
            //         },
            //       ),
            //     );
            //     // return SizedBox(
            //     //   width: media.width * .45,
            //     //   height: media.height * .05,
            //     //   child: VoceSpeechToTextButton(
            //     //     isRecording: state is SpeechToTextDone ||
            //     //             state is SpeechToTextInitial ||
            //     //             state is SpeechToTextTimeout
            //     //         ? false
            //     //         : true,
            //     //   ),
            //     // );
            //   },
            // ),
            SizedBox(
              width: media.width * .4,
              height: media.height * .05,
              child: VocecaaButton(
                color: Colors.grey[300]!,
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.translate_rounded),
                    SizedBox(width: 3),
                    AutoSizeText(
                      'Traduci',
                      maxLines: 1,
                      style: GoogleFonts.poppins(fontSize: media.height * .2),
                    )
                  ],
                ),
                onTap: () {
                  cubit.createNewSession();
                },
              ),
            ),
            // SizedBox(
            //   width: media.width * .15,
            //   child: VocecaaButton(
            //     color: Color(0xFFFFE45E),
            //     text: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Icon(Icons.add_photo_alternate_rounded),
            //         SizedBox(width: 3),
            //         Text(
            //           'Aggiungi',
            //           style: GoogleFonts.poppins(
            //               fontSize: media.width * .013),
            //         )
            //       ],
            //     ),
            //     onTap: () {
            //       cubit.createNewSession(concatenate: true);
            //     },
            //   ),
            // ),
            // Spacer()
          ],
        ),
      ],
    );
  }
}
