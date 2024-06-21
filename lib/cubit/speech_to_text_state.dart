part of 'speech_to_text_cubit.dart';

@immutable
abstract class SpeechToTextState {
  const SpeechToTextState();
}

class SpeechToTextInitial extends SpeechToTextState {
  const SpeechToTextInitial();
}

class SpeechToTextLoading extends SpeechToTextState {
  const SpeechToTextLoading();
}

class SpeechToTextDone extends SpeechToTextState {
  final String result;
  const SpeechToTextDone(this.result);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpeechToTextDone && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

class SpeechToTextTimeout extends SpeechToTextState {}
