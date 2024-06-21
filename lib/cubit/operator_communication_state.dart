part of 'operator_communication_cubit.dart';

@immutable
abstract class OperatorCommunicationState {
  const OperatorCommunicationState();
}

class OperatorCommunicationInitial extends OperatorCommunicationState {
  const OperatorCommunicationInitial();
}

class TranslationLoading extends OperatorCommunicationState {
  const TranslationLoading();
}

class TranslationFault extends OperatorCommunicationState {
  const TranslationFault();
}

class ImagesNotFound extends OperatorCommunicationState {}

class TranslationDone extends OperatorCommunicationState {
  final List<CaaImage> imageList;
  final Map<String, List<CaaImage>> imageCorrectioList;
  const TranslationDone(this.imageList, this.imageCorrectioList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TranslationDone &&
        listEquals(other.imageList, imageList) &&
        mapEquals(other.imageCorrectioList, imageCorrectioList);
  }

  @override
  int get hashCode => imageList.hashCode ^ imageCorrectioList.hashCode;
}

class TranslationError extends OperatorCommunicationState {}
