part of 'search_voce_images_cubit.dart';

@immutable
abstract class SearchVoceImagesState {}

class SearchVoceImagesInitial extends SearchVoceImagesState {}

class SearchVoceImagesLoading extends SearchVoceImagesState {}

class SearchVoceImagesloaded extends SearchVoceImagesState {
  final List<CaaImage> imageList;
  SearchVoceImagesloaded(this.imageList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchVoceImagesloaded &&
        listEquals(other.imageList, imageList);
  }

  @override
  int get hashCode => imageList.hashCode;
}

class SearchVoceImagesError extends SearchVoceImagesState {}
