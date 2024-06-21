import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/audio_tts.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/gender.dart';
import 'package:voce/models/enums/vocal_profile.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/text_to_speech_api.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'patient_communication_state.dart';

class PatientCommunicationCubit extends Cubit<PatientCommunicationState> {
  final VoceAPIRepository voceApiRepository;
  final TextToSpeechApi ttsApi;
  final User user;
  late List<Tuple2<CaaImage, Color>> _imageList = List.empty(growable: true);

  PatientCommunicationCubit({
    required this.voceApiRepository,
    required this.ttsApi,
    required this.user,
  }) : super(PatientCommunicationInitial()) {
    emit(PatientCommunicationLoaded(_imageList, getActivePatient()));
  }

  void resetImageList() {
    _imageList.clear();
  }

  Patient getActivePatient() =>
      user.patientList!.firstWhere((element) => element.isActive!);

  void updateImageBar(Tuple2<CaaImage, Color> value, CaaTable caaTable) async {
    emit(PatientCommunicationInitial());
    int position = _imageList.length;
    _imageList.add(value);
    Map<String, dynamic> data = {
      "date": DateTime.now()
          .toString()
          .substring(0, DateTime.now().toString().indexOf('.')),
      "log_type": "INSERT_IMAGE",
      "patient_id": getActivePatient().id,
      "user_id": user.id,
      "caa_table_id": caaTable.id,
      "image_id": value.item1.id,
      "image_position": position,
    };
    try {
      await voceApiRepository.insertPatientCsLog(data);
      emit(PatientCommunicationLoaded(_imageList, getActivePatient()));
    } on VoceApiException catch (_) {
      emit(PatientCommunicationError());
    }
  }

  void deleteImage(int index) {
    emit(PatientCommunicationInitial());
    _imageList.removeAt(index);
    emit(PatientCommunicationLoaded(_imageList, getActivePatient()));
  }

  void deleteAllImages(){
    emit(PatientCommunicationInitial());
    _imageList.clear();
    emit(PatientCommunicationLoaded(_imageList, getActivePatient()));
  }

  void deleteLastImage(CaaTable caaTable) {
    emit(PatientCommunicationInitial());
    if (_imageList.isNotEmpty) {
      int deletedImageId = _imageList.last.item1.id!;
      _imageList.removeLast();

      Map<String, dynamic> data = {
        "date": DateTime.now()
            .toString()
            .substring(0, DateTime.now().toString().indexOf('.')),
        "image_id": deletedImageId,
        "log_type": "DELETE_LAST",
        "patient_id": getActivePatient().id,
        "user_id": user.id,
        "caa_table_id": caaTable.id,
      };

      try {
        voceApiRepository.insertPatientCsLog(data);
      } on VoceApiException catch (_) {
        emit(PatientCommunicationError());
      }
    }
    emit(PatientCommunicationLoaded(_imageList, getActivePatient()));
  }

  void clearImageList(CaaTable caaTable) {
    emit(PatientCommunicationInitial());
    _imageList.clear();
    Map<String, dynamic> data = {
      "date": DateTime.now()
          .toString()
          .substring(0, DateTime.now().toString().indexOf('.')),
      "log_type": "DELETE_ALL",
      "patient_id": getActivePatient().id,
      "user_id": user.id,
      "caa_table_id": caaTable.id,
    };
    try {
      voceApiRepository.insertPatientCsLog(data);
      emit(PatientCommunicationLoaded(_imageList, getActivePatient()));
    } on VoceApiException catch (_) {
      emit(PatientCommunicationError());
    }
  }

  void getImageBarSubject() {
    emit(PatientCommunicationLoaded(_imageList, getActivePatient()));
  }

  CaaTable getActiveTable() {
    return getActivePatient()
        .tableList
        .firstWhere((element) => element.isActive);
  }

  List<CaaTable> getInactiveTables() {
    return getActivePatient()
        .tableList
        .where((element) => !element.isActive)
        .toList();
  }

  void changeActiveTable(int tableId) {
    emit(PatientCommunicationInitial());
    getActivePatient().changeActiveTable(tableId);
    emit(PatientCommunicationLoaded(_imageList, getActivePatient()));
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
      List<AudioTTS> audioTTSList = image.item1.audioTTSList;
      await playAudio(audioTTSList);
      await Future.delayed(Duration(
        milliseconds: image.item1.label.length > 18 ? 2000 : 1000,
      ));
    }
  }

  // void ttsSpeak(String text) {
  //   late String vocalCodification;
  //   late double rate;
  //   late double pitch;

  //   switch (_getActivePatient().vocalProfile) {
  //     case VocaProfile.MAN:
  //       vocalCodification = "it-it-x-itc-network";
  //       rate = 0.5;
  //       pitch = 1.0;
  //       break;
  //     case VocaProfile.WOMAN:
  //       vocalCodification = "it-it-x-itb-network";
  //       rate = 0.5;
  //       pitch = 1.0;
  //       break;
  //     case VocaProfile.BOY:
  //       vocalCodification = "it-it-x-itc-network";
  //       rate = 0.5;
  //       pitch = 1.5;
  //       break;
  //     case VocaProfile.GIRL:
  //       vocalCodification = "it-it-x-itb-network";
  //       rate = 0.5;
  //       pitch = 1.4;
  //       break;
  //   }

  //   ttsApi.speak(
  //     text: text,
  //     volume: 1.0,
  //     rate: rate,
  //     pitch: pitch,
  //     name: vocalCodification,
  //   );
  // }
}
