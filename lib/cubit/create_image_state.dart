part of 'create_image_cubit.dart';

@immutable
abstract class CreateImageState {
  const CreateImageState();
}

class CreateImageInitial extends CreateImageState {
  const CreateImageInitial();
}

class CreateImageLoaded extends CreateImageState {
  final CaaImage caaImage;
  const CreateImageLoaded(this.caaImage);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateImageLoaded && other.caaImage == caaImage;
  }

  @override
  int get hashCode => caaImage.hashCode;
}

class CreateImagePending extends CreateImageState {
  final List<CaaImage> caaImageList;
  const CreateImagePending(this.caaImageList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateImagePending &&
        listEquals(other.caaImageList, caaImageList);
  }

  @override
  int get hashCode => caaImageList.hashCode;
}

class CreateImageDone extends CreateImageState {
  const CreateImageDone();
}

class CreateImageFault extends CreateImageState {
  const CreateImageFault();
}

class CreateImageError extends CreateImageState {
  const CreateImageError();
}
