import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  late File _imageFile;

  ImagePickerCubit() : super(ImagePickerInitial());

  void updateImageFile(File file) {
    emit(ImagePickerInitial());
    _imageFile = file;
    print('image file path: ${_imageFile.path}');
    emit(ImagePickerLoaded(_imageFile));
  }
}
