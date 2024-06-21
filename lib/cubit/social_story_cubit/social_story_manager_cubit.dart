import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'social_story_manager_state.dart';

class SocialStoryManagerCubit extends Cubit<SocialStoryManagerState> {
  final User user;
  final VoceAPIRepository voceAPIRepository;
  late List<SocialStory> socialStoryList;
  List<SocialStory> filteredSocialStoryList = List.empty(growable: true);
  String searchText = "";
  bool filterPrivate = true;
  bool filterPublic = true;
  bool filterCentre = true;
  SocialStoryManagerCubit({
    required this.user,
    required this.voceAPIRepository,
  }) : super(SocialStoryManagerInitial()) {
    getSocialStories();
  }

  void getSocialStories() async {
    try {
      List<Map<String, dynamic>> socialStoryListData =
          await voceAPIRepository.getSocialStories(
        option: 'PRIVATE',
        userId: user.id,
      );
      socialStoryList = List.from(
        socialStoryListData.map((e) => SocialStory.fromJson(e)),
      );
      socialStoryList.removeWhere((element) => element.patientId != null);
      inspect(socialStoryList);
      _applyFilters();
    } on VoceApiException catch (_) {
      emit(SocialStoryManagerError());
    }
  }

  void getCentreSocialStory() async {
    emit(SocialStoryManagerLoading());

    try {
      List<Map<String, dynamic>> socialStoryListData =
          await voceAPIRepository.getSocialStories(
        option: 'CENTRE',
        userId: user.id,
        centreId: user.autismCentre!.id,
      );

      socialStoryList.addAll(List.from(
        socialStoryListData.map((e) => SocialStory.fromJson(e)),
      ));
      inspect(socialStoryList);
      _applyFilters();
    } on VoceApiException catch (_) {
      emit(SocialStoryManagerError());
    }
  }

  void updateSearchText(String value) {
    searchText = value;
    _filterByPattern(searchText);
  }

  void _filterByPattern(String pattern) {
    emit(SocialStoryManagerLoading());
    if (pattern.isNotEmpty) {
      filteredSocialStoryList = socialStoryList
          .where((element) =>
              element.title.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    _applyFilters();

    // emit(SocialStoryManagerLoaded(filteredSocialStoryList));
  }

  void updateFilterPrivate(bool value) {
    emit(SocialStoryManagerLoading());
    filterPrivate = value;
    _applyFilters();
  }

  void updateFilterPublic(bool value) {
    emit(SocialStoryManagerLoading());
    filterPublic = value;
    _applyFilters();
  }

  void updateFilterCentre(bool value) {
    emit(SocialStoryManagerLoading());
    filterCentre = value;
    _applyFilters();
  }

  void _applyFilters() {
    List<SocialStory> filteredList = List.from(
        searchText.isNotEmpty ? filteredSocialStoryList : socialStoryList);

    if (filterPrivate == false) {
      filteredList.removeWhere((element) => element.isPrivate);
    }

    if (filterCentre == false) {
      filteredList.removeWhere((element) => element.isCentrePrivate);
    }

    if (filterPublic == false) {
      filteredList.removeWhere(
          (element) => !element.isPrivate && !element.isCentrePrivate);
    }

    inspect(filteredList);
    emit(SocialStoryManagerLoaded(filteredList));
  }

  linkTableToPatients(
    List<int> patientSelected,
    SocialStory socialStorySelected,
  ) async {
    emit(SocialStoryManagerLoading());
    if (patientSelected.isNotEmpty) {
      for (var i = 0; i < user.patientList!.length; i++) {
        if (patientSelected.contains(i)) {
          try {
            socialStorySelected.isPrivate = true;
            await voceAPIRepository.createSocialStory(
              socialStorySelected.toJson(),
              user.id!,
              patientId: user.patientList![i].id,
              originalSocialStoryId: socialStorySelected.id,
            );
          } on VoceApiException catch (_) {
            emit(SocialStoryManagerError());
          }
        }
      }
      Future.delayed(
        Duration(milliseconds: 500),
        () => emit(SocialStoryAddedToPatients()),
      );
    }
  }
}
