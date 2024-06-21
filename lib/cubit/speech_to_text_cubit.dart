import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_to_text_state.dart';

class SpeechToTextCubit extends Cubit<SpeechToTextState> {
  final SpeechToText stt = SpeechToText();
  bool _isSpeechToTextAvailable = false;
  List<LocaleName> _localeNames = [];
  String _currentLocaleId = "";

  String? _result = "";

  SpeechToTextCubit() : super(SpeechToTextInitial());

  Future<void> initializeSpeechToText() async {
    _isSpeechToTextAvailable = await stt.initialize(
      onError: sttErrorListener,
      onStatus: sttStatusListener,
    );

    if (_isSpeechToTextAvailable) {
      _localeNames = await stt.locales();
      var systemLocale = await stt.systemLocale();
      _currentLocaleId = systemLocale!.localeId;
    }
  }

  void sttErrorListener(SpeechRecognitionError error) {
    print("Speech To Text ERROR: ${error.errorMsg}");
    emit(SpeechToTextTimeout());
  }

  void sttStatusListener(String status) {
    print("Speech To Text STAUS: $status");
  }

  void sttResultListener(SpeechRecognitionResult result) {}

  void startListening() async {
    await initializeSpeechToText();
    print("Locale ID: $_currentLocaleId");
    if (_isSpeechToTextAvailable) {
      if (stt.isNotListening) {
        emit(SpeechToTextLoading());
        stt.listen(
          onResult: (result) {
            _result = result.recognizedWords;
            print("RESULT: $_result");
            print("FINAL RESULT: ${result.finalResult}");
            // stopRecording();
            emit(SpeechToTextDone(_result ?? ""));
          },
          localeId: _currentLocaleId,
          listenMode: ListenMode.deviceDefault,
        );
      }
    }
  }

  void updateResultByTiping(String value) {
    _result = value;
  }

  void stopRecording() {
    stt.stop();
    emit(SpeechToTextInitial());
  }
}
