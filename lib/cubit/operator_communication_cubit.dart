import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/audio_tts.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/gender.dart';
import 'package:voce/models/enums/vocal_profile.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/speech_to_text_API.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'operator_communication_state.dart';

class OperatorCommunicationCubit extends Cubit<OperatorCommunicationState> {
  final VoceAPIRepository voceAPIRepository;
  final SpeechToTextAPIRepository sttAPIRepository;
  final User user;
  final CaaTable caaTable;
  final Patient patient;
  late List<CaaImage> _imageList = List.empty(growable: true);
  late Map<String, List<CaaImage>> _imageCorrectioList = {};
  int? comunicativeSessionId;
  List<String> lemmasToFind = List.empty(growable: true);
  late String _phrase = "";
  late String _searchText = "";
  List<CaaImage> _correctImageSelected = List.empty(growable: true);

  OperatorCommunicationCubit({
    required this.user,
    required this.voceAPIRepository,
    required this.sttAPIRepository,
    required this.caaTable,
    required this.patient,
  }) : super(OperatorCommunicationInitial());

  List<CaaImage> getImageList() => _imageList;
  String getPhrase() => _phrase;

  void updateCorrectImageSelected(CaaImage image) {
    emit(TranslationLoading());
    _correctImageSelected.add(image);
    emit(TranslationDone(_imageList, _imageCorrectioList));
  }

  void clearCorrectImageSelected() => _correctImageSelected.clear();
  void clearTranslatedImageList() {
    emit(TranslationLoading());
    _imageList.clear();
    emit(TranslationDone(_imageList, _imageCorrectioList));
  }

  List<CaaImage> getCorrectImageSelected() => _correctImageSelected;

  void translateAlgorithm({concatenate = false}) async {
    print('Start\nPhrase: $_phrase');
    emit(TranslationLoading());
    _imageList.clear();
    _imageCorrectioList.clear();
    // Response response = await voceAPIRepository.translatePhrase(
    //   _phrase,
    //   _caaTable.id!,
    //   user.id,
    //   _patient.id!,
    // );
    Map<String, dynamic> data = {"phrase": _phrase};

    try {
      Map<String, dynamic> responseData =
          await voceAPIRepository.translatePhraseV2(
        data,
        caaTable.id!,
        user.id,
        patient.id!,
      );
      comunicativeSessionId = responseData['cs_id'];
      List<dynamic> imageListData = responseData['caa_images'];
      _imageList = imageListData.map((e) => CaaImage.fromJson(e)).toList();
      if (data['lemmas_not_found'] != null) {
        lemmasToFind = (data['lemmas_not_found'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();

        if (lemmasToFind.isNotEmpty) {
          emit(ImagesNotFound());
        } else {
          emit(TranslationDone(_imageList, _imageCorrectioList));
        }
      } else {
        emit(TranslationDone(_imageList, _imageCorrectioList));
      }
    } on VoceApiException catch (error) {
      if (error.statusCode == 404) {
        comunicativeSessionId = error.data!['cs_id'];
        lemmasToFind = (error.data!['lemmas_not_found'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        if (lemmasToFind.isNotEmpty) {
        emit(ImagesNotFound());
        } else {
          emit(TranslationError());
        }
      } else {
        emit(TranslationError());
      }
    }
  }

  void searchImages() async {
    if (lemmasToFind.isNotEmpty) {
      emit(TranslationLoading());
      _imageCorrectioList.clear();

      lemmasToFind.forEach((element) async {
        try {
          List<Map<String, dynamic>> imageListData =
              await voceAPIRepository.searchImages(
            <String, dynamic>{
              "phrase": element,
              "patient_list": patient.id.toString(),
              "user_id": user.id,
            },
          );
          List<CaaImage> correctionList = List.from(
            imageListData.map((e) => CaaImage.fromJson(e)),
          );
          _imageCorrectioList.putIfAbsent(element, () => correctionList);
          emit(TranslationDone(_imageList, _imageCorrectioList));
        } on VoceApiException catch (_) {
          emit(TranslationError());
        }
      });
    }
  }

  void updatePhrase(String value) => _phrase = value;
  void updateSearchText(String value) => _searchText = value;

  void updateTranslateResult(CaaImage oldImange, CaaImage newImage, int index) {
    emit(TranslationLoading());

    //image replacement
    _imageList.removeAt(index);
    _imageList.insert(index, newImage);

    emit(TranslationDone(_imageList, _imageCorrectioList));
  }

  void deleteImage(int index) {
    emit(TranslationLoading());
    _imageList.removeAt(index);
    emit(TranslationDone(_imageList, _imageCorrectioList));
  }

  void deleteAllImages() async {
    emit(TranslationLoading());
    _imageList.clear();
    emit(TranslationDone(_imageList, _imageCorrectioList));
  }

  void deleteLastImage() async {
    emit(TranslationLoading());
    if (_imageList.isNotEmpty) {
      deleteImage(_imageList.length - 1);
    }
    emit(TranslationDone(_imageList, _imageCorrectioList));
  }

  void deleteCsOutputImage(int oldImageId, int index) async {
    try {
      await voceAPIRepository.deleteCsOutputImage(
        oldImageId: oldImageId,
        comunicativeSessionId: comunicativeSessionId!,
      );
      deleteImage(index);
    } on VoceApiException catch (_) {
      emit(TranslationError());
    }
  }

  void reorderlist(int oldIndex, newIndex) async {
    emit(TranslationLoading());
    List<int> oldImageIdList = _imageList.map<int>((e) => e.id!).toList();
    CaaImage imageBuffer = _imageList[oldIndex];
    _imageList.removeAt(oldIndex);
    _imageList.insert(newIndex, imageBuffer);
    List<int> newImageIdList = _imageList.map<int>((e) => e.id!).toList();

    Map<String, dynamic> data = {
      "initial_id_list": oldImageIdList,
      "final_id_list": newImageIdList,
    };

    try {
      await voceAPIRepository.updateCsOutputImage(
        comunicativeSessionId: comunicativeSessionId!,
        data: data,
      );

      emit(TranslationDone(_imageList, _imageCorrectioList));
    } on VoceApiException catch (_) {
      emit(TranslationError());
    }
  }

  void clearCorrection() {
    _searchText = "";
    _correctImageSelected.clear();
    _imageCorrectioList.clear();
  }

  void addCorrectionImage() async {
    emit(TranslationLoading());
    _imageList.addAll(_correctImageSelected);
    String searchText = "";

    try {
      _correctImageSelected.forEach((element) async {
        _imageCorrectioList.forEach((key, value) {
          value.forEach((image) {
            if (image.id == element.id) {
              searchText = key;
            }
          });
        });

        await voceAPIRepository.addCsOutputImage(
          element.id!,
          comunicativeSessionId!,
          searchText,
          _phrase,
        );
      });

      clearCorrection();

      emit(TranslationDone(_imageList, _imageCorrectioList));
    } on VoceApiException catch (_) {
      emit(TranslationError());
    }
  }

  Future<void> playAudio(List<AudioTTS> audioTTSList) async {
    if (audioTTSList.isNotEmpty) {
      Patient activePatient =
          user.patientList!.firstWhere((element) => element.isActive!);
      final vocalProfile = activePatient.vocalProfile;
      late AudioTTS audioTTS;
      switch (vocalProfile) {
        case VocaProfile.MALE:
          audioTTS = audioTTSList.firstWhere(
            (element) => element.gender == Gender.MALE,
          );
          break;
        case VocaProfile.FEMALE:
          audioTTS = audioTTSList.firstWhere(
            (element) => element.gender == Gender.FEMALE,
          );
          break;
      }

      String base64String = audioTTS.base64String;
      final bytes = Uint8List.fromList(base64.decode(base64String));
      final audioPlayer = AudioPlayer();
      if (Platform.isAndroid) {
        await audioPlayer.play(BytesSource(bytes));
      } else {
        final Directory tempDir = await getTemporaryDirectory();
        final String tempFilePath = "${tempDir.path}/temp_audio.mp3";
        File(tempFilePath).writeAsBytesSync(bytes);

        await audioPlayer.play(DeviceFileSource(tempFilePath));

        audioPlayer.onPlayerComplete.listen((event) {
          audioPlayer.dispose();
        });
      }
    }
  }

  void playAllAudios() async {
    for (var image in _imageList) {
      List<AudioTTS> audioTTSList = image.audioTTSList;
      await playAudio(audioTTSList);
      await Future.delayed(Duration(
        milliseconds: image.label.length > 18 ? 2000 : 1000,
      ));
    }
  }
}
