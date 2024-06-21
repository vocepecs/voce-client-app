import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/image.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'edit_image_state.dart';

class EditImageCubit extends Cubit<EditImageState> {
  final VoceAPIRepository voceAPIRepository;
  String _imageBase64Encoding = "";
  EditImageCubit({required this.voceAPIRepository}) : super(EditImageInitial());

  Future<void> editImage(CaaImage image) async {
    emit(EditImageLoading());
    try {
      image.stringCoding = _imageBase64Encoding;
      try {
        await voceAPIRepository.editImage(
          imageId: image.id!,
          data: image.toJson(),
        );
        emit(EditImageSuccess());
      } on VoceApiException catch (error) {
        if (error.statusCode == 404) {
          emit(EditImageErrorNotFound());
        } else if (error.statusCode == 400) {
          emit(EditImageErrorArasaacImage());
        } else {
          emit(EditImageError());
        }
      }
    } catch (e) {
      emit(EditImageInitial());
    }
  }

  void updateImageBase64Encoding(File file) async {
    Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 256,
      minHeight: 256,
      quality: 70,
    );

    _imageBase64Encoding = base64Encode(compressedImage!);
    print(_imageBase64Encoding);
  }
}
