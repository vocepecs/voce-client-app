import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'social_story_editor_state.dart';

class SocialStoryEditorCubit extends Cubit<SocialStoryEditorState> {
  final VoceAPIRepository voceAPIRepository;
  late SocialStory socialStory;
  final User user;
  final Patient? patient;
  int? editIndex;
  String textToTranslate = "";
  List<dynamic>? editImageList;
  final CAAContentOperation caaContentOperation;

  // Lemmi che non trova con l'algoritmo di traduzione
  List<String> lemmasToFind = List.empty(growable: true);
  Map<String, List<CaaImage>> _imageCorrectionList = {};

  SocialStoryEditorCubit({
    required this.user,
    required this.voceAPIRepository,
    required this.socialStory,
    required this.caaContentOperation,
    this.patient,
  }) : super(SocialStoryEditorInitial()) {
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void emitSocialStory() => emit(SocialStoryEditorLoaded(socialStory));

  void updateTextToTranslate(String value) {
    // emit(SocialStoryEditorLoading());
    textToTranslate = value;
    // emit(SocialStoryEditorLoaded(socialStory));
  }

  void updateSocialStoryImageStringConding(CaaImage image) {
    emit(SocialStoryEditorLoading());
    socialStory.imageStringCoding = image.stringCoding;
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void updateSocialStoryTitle(String value) => socialStory.title = value;
  void updateSocialStoryDescription(String value) =>
      socialStory.description = value;

  void updateSocialStoryUserPrivacy(bool value) {
    emit(SocialStoryEditorLoading());
    socialStory.isPrivate = value;
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void updateSocialStoryCentrePrivacy(bool value) {
    emit(SocialStoryEditorLoading());
    socialStory.isCentrePrivate = value;
    emit(SocialStoryEditorLoaded(socialStory));
  }

  bool isUserSocialStory() =>
      (socialStory.id == null || socialStory.userId == user.id);

  bool isPatientSocialStory() => patient != null;

  void createNewSession({concatenate = false}) async {
    emit(SocialStoryTranslationLoading());
    Map<String, dynamic> data = {"phrase": textToTranslate};

    try {
      Map<String, dynamic> responseData =
          await voceAPIRepository.translatePhraseV2(
        data,
        null,
        user.id,
        patient?.id,
      );

      int comunicativeSessionId = responseData['cs_id'];
      List<dynamic> imageListData = responseData['caa_images'];
      List<CaaImage> imageList =
          imageListData.map((e) => CaaImage.fromJson(e)).toList();

      if (concatenate) {
        if (editIndex != null) {
          socialStory.addPictogramsToComunicativeSession(editIndex!, imageList);
          emit(SocialStoryEditorLoaded(socialStory));
        } else {
          print("unavailable");
          emit(SocialStoryEditorContenateUnavailable());
          emit(SocialStoryEditorLoaded(socialStory));
        }
      } else {
        socialStory.inserNewComunicativeSession(
          editIndex,
          comunicativeSessionId,
          textToTranslate,
          imageList,
        );

        if (responseData['lemmas_not_found'] != null) {
          lemmasToFind = (responseData['lemmas_not_found'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
          if (lemmasToFind.isNotEmpty) {
            await _searchImages(comunicativeSessionId);
          }
        }
        emit(SocialStoryEditorLoaded(socialStory));
      }
      editIndex = null;
    } on VoceApiException catch (error) {
      if (error.statusCode == 404) {
        int comunicativeSessionId = error.data!['cs_id'];
        socialStory.inserNewComunicativeSession(
          editIndex,
          comunicativeSessionId,
          textToTranslate,
          [],
        );

        lemmasToFind = (error.data!['lemmas_not_found'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();

        await _searchImages(comunicativeSessionId);
      } else {
        emit(SocialStoryEditorTranslationError());
      }
    }
  }

  Future<void> _searchImages(int sessionId) async {
    if (lemmasToFind.isNotEmpty) {
      _imageCorrectionList.clear();

      for (String element in lemmasToFind) {
        try {
          List<Map<String, dynamic>> imageListData =
              await voceAPIRepository.searchImages(
            <String, dynamic>{
              "phrase": element,
              "patient_list": [],
              "user_id": user.id
            },
          );

          List<CaaImage> correctionList = List.from(
            imageListData.map((e) => CaaImage.fromJson(e)),
          );
          _imageCorrectionList.putIfAbsent(element, () => correctionList);
        } on VoceApiException catch (_) {
          emit(SocialStoryEditorTranslationError());
        }
      }
      emit(SocialStoryEditorImagesNotFound(sessionId, _imageCorrectionList));
    }
  }

  void fixComunicativeSession(
    int comunicativeSessionId,
    List<CaaImage> imageList,
  ) {
    emit(SocialStoryEditorLoading());

    String searchText = "";

    try {
      _imageCorrectionList.forEach((key, value) async {
        value.forEach((image) async {
          if (imageList.map((e) => e.id).toList().contains(image.id)) {
            searchText = key;

            await voceAPIRepository.addCsOutputImage(
              image.id!,
              comunicativeSessionId,
              searchText,
              textToTranslate,
            );
          }
        });
      });
    } on VoceApiException catch (_) {
      emit(SocialStoryEditorTranslationError());
    }

    socialStory.comunicativeSessionList.forEach((element) {
      if (element.id == comunicativeSessionId) {
        element.imageList.addAll(imageList);
        imageList.forEach((image) {
          element.updateCsOutputUpdateMap(image.id!);
        });
      }
    });

    emit(SocialStoryEditorLoaded(socialStory));
  }

  void renameComunicativeSession(int index, String value) {
    print(value);
    emit(SocialStoryEditorLoading());
    socialStory.comunicativeSessionList[index].title = value;
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void changeComunicativeSessionPosition(int oldIndex, int newIndex) {
    emit(SocialStoryEditorLoading());
    socialStory.changeComunicativeSessionPosition(oldIndex, newIndex);
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void changeImagePosition(
    int comunicativeSessionId,
    int oldPosition,
    int newPosition,
  ) async {
    emit(SocialStoryEditorLoading());
    int csIndex = socialStory.comunicativeSessionList.indexWhere(
      (element) => element.id == comunicativeSessionId,
    );

    List<int> oldImageIdList = socialStory
        .comunicativeSessionList[csIndex].imageList
        .map<int>((e) => e.id!)
        .toList();

    socialStory.comunicativeSessionList[csIndex].changeImagePosition(
      oldPosition,
      newPosition,
    );

    List<int> newImageList = socialStory
        .comunicativeSessionList[csIndex].imageList
        .map<int>((e) => e.id!)
        .toList();

    Map<String, dynamic> data = {
      "initial_id_list": oldImageIdList,
      "final_id_list": newImageList,
    };

    try {
      await voceAPIRepository.updateCsOutputImage(
        comunicativeSessionId: socialStory.comunicativeSessionList[csIndex].id,
        data: data,
      );
      emit(SocialStoryEditorLoaded(socialStory));
    } catch (e) {
      emit(SocialStoryEditorTranslationError());
    }
  }

  void changeImage(
    int comunicativeSessionId,
    CaaImage image,
    CaaImage newImage,
    int index,
  ) {
    emit(SocialStoryEditorLoading());
    int csIndex = socialStory.comunicativeSessionList.indexWhere(
      (element) => element.id == comunicativeSessionId,
    );
    socialStory.comunicativeSessionList[csIndex].changeImage(
      image.id!,
      newImage,
    );
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void deleteComunicativeSessionImage(int comunicativeSessionId, int imageId) {
    emit(SocialStoryEditorLoading());
    socialStory.deleteComunicativeSessionImage(
      comunicativeSessionId,
      imageId,
    );

    inspect(socialStory);
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void duplicateSocialStory() async {
    socialStory.id = null;
    socialStory.userId = user.id;
    socialStory.title += " <copia>";
    Map<String, dynamic> ssJson = socialStory.toJsonCustom();

    try {
      await voceAPIRepository.createSocialStory(
        ssJson,
        user.id!,
        patientId: socialStory.patientId,
      );

      emit(SocialStoryEditorDuplicateDone());
    } catch (e) {
      emit(SocialStoryEditorTranslationError());
    }
  }

  void saveSocialStory({bool confirmPersonalImages = false}) async {
    emit(SocialStoryEditorLoading());

    if (socialStory.getAllImages().any((element) => element.isPersonal) &&
        !confirmPersonalImages &&
        patient == null) {
      emit(SocialStoryPersonalImagesWarning());
    } else if (socialStory.getSessionListSize > 0) {
      if (confirmPersonalImages) {
        socialStory.isPrivate = true;
      }
      Map<String, dynamic> ssJson = socialStory.toJsonCustom();
      ssJson.putIfAbsent('user_id', () => user.id);
      if (socialStory.id != null) {
        try {
          await voceAPIRepository.updateSocialStory(
            ssJson,
          );
          emit(SocialStoryEditorUpdateDone());
        } on VoceApiException catch (_) {
          emit(SocialStoryEditorTranslationError());
        }
      } else {
        try {
          await voceAPIRepository.createSocialStory(
            ssJson,
            user.id!,
            patientId: patient?.id,
          );

          emit(SocialStoryEditorCreateDone());
        } catch (e) {
          emit(SocialStoryEditorTranslationError());
        }
      }
    } else {
      emit(SocialStoryEditorError());
    }
  }

  void deleteComunicativeSession(int sessionIndex) {
    emit(SocialStoryEditorLoading());
    socialStory.comunicativeSessionList.removeAt(sessionIndex);
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void deleteSocialStory() async {
    try {
      await voceAPIRepository.deleteSocialStory(socialStory.id!);
      emit(SocialStoryEditorDeleteDone());
    } on VoceApiException catch (_) {
      emit(SocialStoryEditorTranslationError());
    }
  }

  void addImageToSession(
    CaaImage image,
    int comunicativeSessionIndex,
  ) {
    emit(SocialStoryEditorLoading());
    socialStory.comunicativeSessionList[comunicativeSessionIndex]
        .addImage(image);
    emit(SocialStoryEditorLoaded(socialStory));
  }

  void dispose() {
    super.close();
  }
}
