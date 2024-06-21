part of 'social_story_manager_cubit.dart';

@immutable
abstract class SocialStoryManagerState {}

class SocialStoryManagerInitial extends SocialStoryManagerState {}

class SocialStoryManagerLoading extends SocialStoryManagerState {}

class SocialStoryManagerLoaded extends SocialStoryManagerState {
  final List<SocialStory> socialStoryList;
  SocialStoryManagerLoaded(this.socialStoryList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocialStoryManagerLoaded &&
        listEquals(other.socialStoryList, socialStoryList);
  }

  @override
  int get hashCode => socialStoryList.hashCode;
}

class SocialStoryManagerError extends SocialStoryManagerState {}

class SocialStoryAddedToPatients extends SocialStoryManagerState {}
