import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';

class VoceSpeechToTextButton extends StatefulWidget {
  const VoceSpeechToTextButton({
    Key? key,
    required this.isRecording,
    this.widthFactor = .05,
  }) : super(key: key);

  final bool isRecording;
  final double widthFactor;

  @override
  State<VoceSpeechToTextButton> createState() => _VoceSpeechToTextButtonState();
}

class _VoceSpeechToTextButtonState extends State<VoceSpeechToTextButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _recordingAnimationController;
  late SpeechToTextCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = BlocProvider.of<SpeechToTextCubit>(context);
    // cubit.initializeSpeechToText();
    _recordingAnimationController = AnimationController(vsync: this);

    _recordingAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _recordingAnimationController.reset();
        _recordingAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    cubit.close();
    _recordingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.orientationOf(context);
    return Container(
      width: orientation == Orientation.landscape
          ? media.width * .2
          : media.width * .9,
      height: orientation == Orientation.landscape
          ? media.height * .07
          : media.height * .07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[300],
        shape: BoxShape.rectangle,
      ),
      child: !widget.isRecording
          ? GestureDetector(
              onTap: () {
                cubit.startListening();
              },
              child: Padding(
                padding: EdgeInsets.all(
                    orientation == Orientation.landscape ? 15.0 : 5.0),
                child: Row(
                  mainAxisAlignment: orientation == Orientation.portrait
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.mic,
                      size: orientation == Orientation.landscape ? 25 : 25,
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: orientation == Orientation.portrait
                          ? media.width * .3
                          : media.width * .1,
                      child: AutoSizeText(
                        'Usa il microfono',
                        maxLines: 1,
                        style: GoogleFonts.poppins(),
                      ),
                    )
                  ],
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Container(
                    width: media.width * .1,
                    height: media.height * .07,
                    child: Lottie.network(
                      "https://assets5.lottiefiles.com/packages/lf20_1xbk4d2v.json",
                      // width: media.width * .2,
                      fit: BoxFit.scaleDown,
                      controller: _recordingAnimationController,
                      onLoaded: (composition) {
                        _recordingAnimationController
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.grey[400],
                      shape: BoxShape.rectangle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        cubit.stopRecording();
                      },
                      icon: Icon(
                        Icons.stop,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
