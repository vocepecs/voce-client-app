import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextAPIRepository {
  final SpeechToText stt;

  SpeechToTextAPIRepository({required this.stt});

  void sttTranslate({
    required Function(String text) onResult,
    required ValueChanged<String> onListening,
    required ValueChanged<String> onError,
  }) async {
    bool isAvailable = await stt.initialize(
      onStatus: (_) => onListening(stt.lastStatus),
      onError: (errorNotification) => onError(errorNotification.errorMsg),
      debugLogging: true,
    );

    if (isAvailable) {
      var locales = await stt.locales();

      locales.forEach((element) {
        print("Locale: ${element.name} - ID: ${element.localeId}");
      });

      var selectedLocale = locales.firstWhere(
        (element) => element.localeId == "it_IT",
      );

      if (stt.isNotListening) {
        stt.listen(
          onResult: (result) => onResult(result.recognizedWords),
          localeId: selectedLocale.localeId,
        );
      } else {
        print("STT STOP");
        stt.stop();
      }
    }
  }
}
