import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'social_stories_view_state.dart';

class SocialStoriesViewCubit extends Cubit<SocialStoriesViewState> {
  SocialStoriesViewCubit({
    required this.user,
    required this.voceAPIRepository,
  }) : super(SocialStoriesViewInitial());
  final User user;
  final VoceAPIRepository voceAPIRepository;
  late List<SocialStory> socialStoryList;
  String searchText = "";
  int selectedIndex = 0;

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

      inspect(socialStoryList);
      emit(SocialStoriesViewLoaded(filterByPatient(socialStoryList)));
    } on VoceApiException catch (_) {
      emit(SocialStoriesViewError());
    }
  }

  List<SocialStory> filterByPatient(List<SocialStory> list) {
    print(user.patientList);
    Patient patient = user.patientList![selectedIndex];
    return list.where((e) => e.patientId == patient.id).toList();
  }

  void filterByTextSearch(String text) {
    emit(SocialStorisViewLoading());
    if (text.isEmpty) {
      emit(SocialStoriesViewLoaded(filterByPatient(socialStoryList)));
    } else {
      List<SocialStory> socialStoryFiltered = socialStoryList
          .where((element) =>
              element.title.toUpperCase().contains(text.toUpperCase()))
          .toList();
      emit(SocialStoriesViewLoaded(filterByPatient(socialStoryFiltered)));
    }
  }

  void updateSelectedPatientIndex(int newIndex) {
    emit(SocialStorisViewLoading());
    selectedIndex = newIndex;
    emit(SocialStoriesViewLoaded(filterByPatient(socialStoryList)));
  }
}
