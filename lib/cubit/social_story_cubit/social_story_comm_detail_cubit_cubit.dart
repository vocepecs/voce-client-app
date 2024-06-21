import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/enums/gender.dart';
import 'package:voce/models/enums/social_story_view_type.dart';
import 'package:voce/models/enums/vocal_profile.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

import '../../models/audio_tts.dart';

part 'social_story_comm_detail_cubit_state.dart';

class SocialStoryCommDetailCubitCubit
    extends Cubit<SocialStoryCommDetailCubitState> {
  VoceAPIRepository voceAPIRepository;
  User user;
  SocialStory socialStory;
  Patient activePatient;
  late SocialStory oneStepSocialStoryTarget;

  List<GlobalKey> globalKeyList = List.empty(growable: true);

  SocialStoryCommDetailCubitCubit({
    required this.voceAPIRepository,
    required this.user,
    required this.socialStory,
    required this.activePatient,
  }) : super(SocialStoryCommDetailCubitInitial());

  List<SocialStory> _getInactiveSocialStories() => activePatient.socialStoryList
      .where((element) => element.isActive == false)
      .toList();

  void initializeSocialStoryList() {
    if (activePatient.socialStoryViewType == SocialStoryViewType.SINGLE) {
      oneStepSocialStoryTarget = SocialStory(
        socialStory.userId,
        socialStory.patientId,
        socialStory.title,
        socialStory.description,
        socialStory.imageStringCoding,
        socialStory.creationDate,
        socialStory.isPrivate,
        socialStory.autismCentreId,
        [],
        false,
      );

      oneStepSocialStoryTarget.comunicativeSessionList.add(
        socialStory.comunicativeSessionList[0],
      );

      emit(SocialStoryTargetChanged(
        oneStepSocialStoryTarget,
        _getInactiveSocialStories(),
      ));
    } else {
      emit(SocialStoryTargetChanged(
        socialStory,
        activePatient.socialStoryList
            .where((element) => element.isActive == false)
            .toList(),
      ));
    }
  }

  void showNextComunicativeSession() {
    if (oneStepSocialStoryTarget.comunicativeSessionList.length <
        socialStory.comunicativeSessionList.length) {
      emit(SocialStoryCommDetailCubitLoading());
      int index = oneStepSocialStoryTarget.comunicativeSessionList.length;
      oneStepSocialStoryTarget.comunicativeSessionList
          .add(socialStory.comunicativeSessionList[index]);
      emit(SocialStoryTargetChanged(
          oneStepSocialStoryTarget, _getInactiveSocialStories()));
    }
  }

  void changeSocialStoryTarget(SocialStory socialStoryTarget) {
    emit(SocialStoryCommDetailCubitLoading());

    activePatient.socialStoryList.forEach((element) {
      element.isActive = false;
      if (element.id == socialStoryTarget.id) {
        element.isActive = true;
      }
    });

    socialStory = socialStoryTarget;

    user.patientList!
        .firstWhere((element) => element.isActive!)
        .socialStoryList
        .forEach((element) {
      element.isActive = false;
      if (element.id == socialStory.id) {
        element.isActive = true;
      }
    });
    try {
      voceAPIRepository.updateUser(user.toJson());
    } on VoceApiException catch (_) {
      emit(SocialStoryCommDetailError());
    }

    initializeSocialStoryList();
  }

  void insertGlobalKey(GlobalKey key) {
    if (!globalKeyList.contains(key)) {
      globalKeyList.add(key);
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

  void playAllAudios(int csIndex) async {
    for (var image in socialStory.comunicativeSessionList[csIndex].imageList) {
      List<AudioTTS> audioTTSList = image.audioTTSList;
      await playAudio(audioTTSList);
      await Future.delayed(Duration(
        milliseconds: image.label.length > 18 ? 2000 : 1000,
      ));
    }
  }
}
