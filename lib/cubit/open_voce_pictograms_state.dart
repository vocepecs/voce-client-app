part of 'open_voce_pictograms_cubit.dart';

@immutable
abstract class OpenVocePictogramsState {}

class OpenVocePictogramsInitial extends OpenVocePictogramsState {}

class OpenVocePictogramsLoading extends OpenVocePictogramsState {}

class OpenVocePictogramsLoaded extends OpenVocePictogramsState {
  final List<CaaImage> imageList;
  OpenVocePictogramsLoaded(this.imageList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OpenVocePictogramsLoaded &&
        listEquals(other.imageList, imageList);
  }

  @override
  int get hashCode => imageList.hashCode;
}

class OpenVocePictogramsError extends OpenVocePictogramsState {}
