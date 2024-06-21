part of 'image_picker_cubit.dart';

@immutable
abstract class ImagePickerState {
  const ImagePickerState();
}

class ImagePickerInitial extends ImagePickerState {
  const ImagePickerInitial();
}

class ImagePickerLoaded extends ImagePickerState {
  final File imageFile;
  const ImagePickerLoaded(this.imageFile);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImagePickerLoaded && other.imageFile == imageFile;
  }

  @override
  int get hashCode => imageFile.hashCode;
}
