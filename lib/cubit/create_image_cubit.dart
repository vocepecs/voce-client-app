import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'create_image_state.dart';

class CreateImageCubit extends Cubit<CreateImageState> {
  final VoceAPIRepository voceAPIRepository;
  late CaaImage _newCaaImage = CaaImage();
  final User user;
  late List<Patient> _selectedPatients = [];
  late String _imageBase64Encoding;

  CreateImageCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(CreateImageInitial());

  List<Patient>? get getPatientList => user.patientList;

  void getImageData() => emit(CreateImageLoaded(_newCaaImage));
  void updateImageName(String value) => _newCaaImage.label = value;

  void addSelectedPatient(Patient patient) {
    _selectedPatients.add(patient);
    print(_selectedPatients.length);
  }

  void removeSelectedPatient(int id) {
    _selectedPatients.removeWhere((element) => element.id == id);
    print(_selectedPatients.length);
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

  void createImage({String? correctionLabel}) async {
    _newCaaImage.stringCoding = _imageBase64Encoding;
    _newCaaImage.url = '';
    _newCaaImage.isPersonal = true;
    _newCaaImage.insertDate = DateTime.now();
    _newCaaImage.isActive = true;

    Map<String, dynamic> imageData = _newCaaImage.toJson();
    imageData.putIfAbsent('user_id', () => user.id);

    try {
      Map<String, dynamic> imageCreationPendingData =
          await voceAPIRepository.createCustomImage(
        imageData,
        correctionLabel: correctionLabel,
      );

      List<Map<String, dynamic>> imageListData =
          (imageCreationPendingData['caa_images'] as List<dynamic>)
              .map((item) => item as Map<String, dynamic>)
              .toList();

      // (imageCreationPendingData['caa_images'] as List<Map<String, dynamic>>)
      //     .toList();

      List<CaaImage> imageList = List.from(imageListData.map(
        (e) => CaaImage.fromJson(e),
      ));
      emit(CreateImagePending(imageList));
    } on VoceApiException catch (error) {
      if (error.statusCode == 400) {
        emit(CreateImageFault());
      } else {
        emit(CreateImageError());
      }
    }
  }

  void finalizePendingCreation(int suggestedImageId) async {
    Map<String, dynamic> imageData = _newCaaImage.toJson();
    imageData.putIfAbsent('user_id', () => user.id);

    try {
      Map<String, dynamic> imageCreatedData =
          await voceAPIRepository.createCustomImage(
        imageData,
        imageId: suggestedImageId,
      );

      int imageId = imageCreatedData['image_id'];

      if (_selectedPatients.length > 0) {
        List<int> patientIdList = List.from(_selectedPatients.map((e) => e.id));

        //! Sto usando un try catch su VoceApiException per due risorse differenti
        //! (addImageToPatients e createCustomImage) e non sono in grado di distinguere chi solleva l'eccezione
        // TODO Sistemare il try catch per distinguere le due eccezioni

        Map<String, dynamic> data = {'patient_list': patientIdList};
        await voceAPIRepository.addImageToPatients(
          data,
          imageId,
        );

        emit(CreateImageDone());
      } else {
        emit(CreateImageDone());
      }
    } on VoceApiException catch (_) {
      emit(CreateImageError());
    }
  }
}
