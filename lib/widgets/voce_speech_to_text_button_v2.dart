import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoceSpeechToTextButtonV2 extends StatefulWidget {
  const VoceSpeechToTextButtonV2({
    Key? key,
    required this.onResult,
    this.widthFactor = .05,
  }) : super(key: key);

  final double widthFactor;
  final Function(String lastWords) onResult;

  @override
  State<VoceSpeechToTextButtonV2> createState() =>
      _VoceSpeechToTextV2ButtonState();
}

class _VoceSpeechToTextV2ButtonState extends State<VoceSpeechToTextButtonV2>
    with SingleTickerProviderStateMixin {
  late final AnimationController _recordingAnimationController;
  SpeechToText _stt = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

  @override
  void initState() {
    super.initState();
    _initSpeech();
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
    _recordingAnimationController.dispose();
    super.dispose();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _stt.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    var locales = await _stt.locales();
    var selectedLocale = locales.firstWhere(
      (element) => Platform.isIOS
          ? element.localeId == "it-IT"
          : element.localeId == "it_IT",
    );

    await _stt.listen(
      onResult: _onSpeechResult,
      localeId: selectedLocale.localeId,
    );
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _stt.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      widget.onResult(_lastWords);
    });
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
      child: GestureDetector(
        onTap: () {
          _stt.isNotListening ? _startListening() : _stopListening();
        },
        child: _stt.isNotListening
            ? Padding(
                padding: EdgeInsets.all(
                    orientation == Orientation.landscape ? 15.0 : 5.0),
                child: Row(
                  mainAxisAlignment: orientation == Orientation.portrait
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.mic,
                      size: orientation == Orientation.landscape ? 25 : 30,
                    ),
                    if (orientation == Orientation.landscape)
                      SizedBox(width: 10),
                    if (orientation == Orientation.landscape)
                      SizedBox(
                        width: orientation == Orientation.portrait
                            ? media.width * .1
                            : media.width * .1,
                        child: AutoSizeText(
                          'Usa il microfono',
                          maxLines: 1,
                          style: GoogleFonts.poppins(),
                        ),
                      )
                  ],
                ),
              )
            : GestureDetector(
                onTap: () => _stopListening(),
                child: Lottie.network(
                  "https://lottie.host/81101779-06d4-406c-9fa4-329f4fdceefb/vRscerFvzS.json",
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
    );
  }
}
