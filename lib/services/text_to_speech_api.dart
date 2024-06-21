import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechApi {
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  bool isCurrentLanguageInstalled = false;

  String? _newVoiceText;
  int? _inputLength;

  // TtsState ttsState = TtsState.stopped;

  // get isPlaying => ttsState == TtsState.playing;
  // get isStopped => ttsState == TtsState.stopped;
  // get isPaused => ttsState == TtsState.paused;
  // get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  TextToSpeechApi() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage('it-IT');

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }

    // flutterTts.setStartHandler(() {
    //   ttsState = TtsState.playing;
    // });

    // flutterTts.setCompletionHandler(() {
    //   ttsState = TtsState.stopped;
    // });

    // flutterTts.setCancelHandler(() {
    //   ttsState = TtsState.stopped;
    // });

    // if (isWeb || isIOS || isWindows) {
    //   flutterTts.setPauseHandler(() {
    //     ttsState = TtsState.paused;
    //   });

    //   flutterTts.setContinueHandler(() {
    //     ttsState = TtsState.continued;
    //   });

    //   flutterTts.setErrorHandler((message) {
    //     ttsState = TtsState.stopped;
    //   });
    // }
  }

  Future<dynamic> _getLanguages() => flutterTts.getLanguages;
  Future<dynamic> _getEngines() => flutterTts.getEngines;

  void _getVoices() async {
    List<dynamic> voiceList = await flutterTts.getVoices;
    voiceList.forEach((element) {
      if (element['locale'] == 'it-IT') {
        print(element);
      }
    });
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future speak({
    String? text,
    required double volume,
    required double rate,
    required double pitch,
    required String name,
  }) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setVoice({
      'name': name,
      'locale': 'it-IT',
    });

    // List<Map<String, dynamic>> itVoiceList =
    //     voiceList.where((element) => (element as Map<String,dynamic>)['locale'] == 'it-IT').toList();
    // print(itVoiceList);

    if (text != null) {
      if (text.isNotEmpty) {
        await flutterTts.speak(text);
      }
    }
  }

  // Future _stop() async {
  //   var result = await flutterTts.stop();
  //   if (result == 1) ttsState = TtsState.stopped;
  // }

  // Future _pause() async {
  //   var result = await flutterTts.pause();
  //   if (result == 1) ttsState = TtsState.paused;
  // }

  void dispose() {
    flutterTts.stop();
  }
}
