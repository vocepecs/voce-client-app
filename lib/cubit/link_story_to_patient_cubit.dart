import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'link_story_to_patient_state.dart';

class LinkStoryToPatientCubit extends Cubit<LinkStoryToPatientState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  late List<SocialStory> _socialStoryList;
  late List<SelectableItem> _selectableItemList = [];
  final Patient patient;
  late bool _privateFilter;
  late bool _centreFilter;
  late bool _publicFilter;

  LinkStoryToPatientCubit({
    required this.voceAPIRepository,
    required this.patient,
    required this.user,
  }) : super(LinkStoryToPatientInitial()) {
    _privateFilter = true;
    _centreFilter = true;
    _publicFilter = true;
  }

  void getSocialStories() async {
    try {
      List<Map<String, dynamic>> socialStoryListData =
          await voceAPIRepository.getSocialStories(
        option: 'PRIVATE',
        userId: user.id,
      );

      socialStoryListData.removeWhere(
        (element) => element['linked_to_patient'] == true,
      );

      _socialStoryList = List.from(socialStoryListData.map(
        (e) => SocialStory.fromJson(e),
      ));

      _socialStoryList.removeWhere((element) => element.patientId != null);

      _socialStoryList.forEach((element) {
        _selectableItemList.add(SelectableItem(socialStory: element));
      });

      _applyFilters();
    } on VoceApiException catch (_) {
      emit(LinkStoryToPatientError());
    }
  }

  void getCentreSocialStory() async {
    emit(LinkStoryToPatientLoading());
    try {
      List<Map<String, dynamic>> socialStoryListData =
          await voceAPIRepository.getSocialStories(
        option: 'CENTRE',
        userId: user.id,
        centreId: user.autismCentre!.id,
      );

      _socialStoryList.addAll(List.from(
        socialStoryListData.map((e) => SocialStory.fromJson(e)),
      ));

      _socialStoryList.forEach((element) {
        _selectableItemList.add(SelectableItem(socialStory: element));
      });
      _applyFilters();
    } catch (e) {
      emit(LinkStoryToPatientError());
    }
  }

  void updateSelectableItemList(SocialStory socialStory, bool value) {
    _selectableItemList.forEach((element) {
      if (element.socialStory.id == socialStory.id) {
        element.isSelected = value;
      }
    });
  }

  void updateFilterPrivate(bool value) {
    emit(LinkStoryToPatientLoading());
    _privateFilter = value;
    _applyFilters();
  }

  void updateFilterPublic(bool value) {
    emit(LinkStoryToPatientLoading());
    _publicFilter = value;
    _applyFilters();
  }

  void updateFilterCentre(bool value) {
    emit(LinkStoryToPatientLoading());
    _centreFilter = value;
    _applyFilters();
  }

  void _applyFilters() {
    // List<SocialStory> filteredList = List.from(
    //     searchText.isNotEmpty ? filteredSocialStoryList : socialStoryList);
    List<SocialStory> filteredList = List.from(_socialStoryList);

    if (_privateFilter == false) {
      filteredList.removeWhere((element) => element.isPrivate);
    }

    if (_centreFilter == false) {
      filteredList.removeWhere((element) => element.isCentrePrivate);
    }

    if (_publicFilter == false) {
      filteredList.removeWhere(
          (element) => !element.isPrivate && !element.isCentrePrivate);
    }

    emit(LinkStoryToPatientLoaded(filteredList));
  }

  void linkSocialStoryToPatient() {
    List<SocialStory> selectedStories = _selectableItemList
        .where((element) => element.isSelected)
        .map((e) => e.socialStory)
        .toList();

    selectedStories.forEach((element) async {
      Map<String, dynamic> ssJson = element.toJsonCustom();
      await voceAPIRepository.createSocialStory(
        ssJson,
        user.id!,
        patientId: patient.id,
        originalSocialStoryId: element.id,
      );
    });
    Future.delayed(
      Duration(milliseconds: 500),
      () => emit(LinkStoryToPatientStoryAdded()),
    );
  }
}

class SelectableItem {
  final SocialStory socialStory;
  bool isSelected;

  SelectableItem({
    required this.socialStory,
    this.isSelected = false,
  });
}
