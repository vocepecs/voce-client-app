part of 'social_stories_view_cubit.dart';

@immutable
abstract class SocialStoriesViewState {}

class SocialStoriesViewInitial extends SocialStoriesViewState {}

class SocialStorisViewLoading extends SocialStoriesViewState {}

class SocialStoriesViewLoaded extends SocialStoriesViewState {
  final List<SocialStory> socialStoryList;
  SocialStoriesViewLoaded(this.socialStoryList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocialStoriesViewLoaded &&
        listEquals(other.socialStoryList, socialStoryList);
  }

  @override
  int get hashCode => socialStoryList.hashCode;
}

class SocialStoriesViewError extends SocialStoriesViewState {}
