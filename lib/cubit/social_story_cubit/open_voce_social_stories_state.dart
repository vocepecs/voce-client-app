part of 'open_voce_social_stories_cubit.dart';

@immutable
abstract class OpenVoceSocialStoriesState {
  final List<SocialStory> mostUsedSocialStoryList;
  OpenVoceSocialStoriesState({this.mostUsedSocialStoryList = const []});
}

class OpenVoceSocialStoriesInitial extends OpenVoceSocialStoriesState {}

class OpenVoceSocialStoriesLoading extends OpenVoceSocialStoriesState {
  final List<SocialStory> mostUsedSocialStoryList;
  OpenVoceSocialStoriesLoading(this.mostUsedSocialStoryList);
}

class OpenVoceSocialStoriesLoaded extends OpenVoceSocialStoriesState {
  final List<SocialStory> socialStoryList;
  final List<SocialStory> mostUsedSocialStoryList;
  OpenVoceSocialStoriesLoaded(
      this.socialStoryList, this.mostUsedSocialStoryList);
}

class OpenVoceSocialStoriesEmpty extends OpenVoceSocialStoriesState {
  final List<SocialStory> mostUsedSocialStoryList;
  OpenVoceSocialStoriesEmpty(this.mostUsedSocialStoryList);
}

class OpenVoceSocialStoriesError extends OpenVoceSocialStoriesState {}
