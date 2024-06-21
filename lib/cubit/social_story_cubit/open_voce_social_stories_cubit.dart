import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'open_voce_social_stories_state.dart';

class OpenVoceSocialStoriesCubit extends Cubit<OpenVoceSocialStoriesState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  List<SocialStory> socialStoryList = List.empty(growable: true);
  List<SocialStory> mostUsedSocialStoryList = List.empty(growable: true);
  late String text;
  OpenVoceSocialStoriesCubit({
    required this.user,
    required this.voceAPIRepository,
  }) : super(OpenVoceSocialStoriesInitial()) {
    getMostUsedSocialStories();
  }

  void getMostUsedSocialStories() async {
    try {
      List<Map<String, dynamic>> socialStoryListData =
          await voceAPIRepository.getSocialStories(
        option: 'PUBLIC',
        searchMostUsed: true,
      );
      mostUsedSocialStoryList = List.from(
        socialStoryListData.map((e) => SocialStory.fromJson(e)),
      );
      emit(OpenVoceSocialStoriesLoaded(
        socialStoryList,
        mostUsedSocialStoryList,
      ));
    } on VoceApiException catch (_) {
      emit(OpenVoceSocialStoriesError());
    }
  }

  void updatePattern(value) => text = value;

  void getSocialStories() async {
    if (text.isNotEmpty) {
      emit(OpenVoceSocialStoriesLoading(mostUsedSocialStoryList));
      socialStoryList.clear();

      try {
        List<Map<String, dynamic>> socialStoryListData =
            await voceAPIRepository.getSocialStories(
          option: 'PUBLIC',
          text: text,
        );
        socialStoryList = List.from(
          socialStoryListData.map((e) => SocialStory.fromJson(e)),
        );
        if (socialStoryList.isEmpty) {
          emit(OpenVoceSocialStoriesEmpty(mostUsedSocialStoryList));
        } else {
          emit(OpenVoceSocialStoriesLoaded(
            socialStoryList,
            mostUsedSocialStoryList,
          ));
        }
      } catch (e) {
        emit(OpenVoceSocialStoriesError());
      }
    }
  }
}
