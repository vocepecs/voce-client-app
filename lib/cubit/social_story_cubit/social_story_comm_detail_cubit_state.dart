part of 'social_story_comm_detail_cubit_cubit.dart';

@immutable
abstract class SocialStoryCommDetailCubitState {}

class SocialStoryCommDetailCubitInitial
    extends SocialStoryCommDetailCubitState {}

class SocialStoryCommDetailCubitLoading
    extends SocialStoryCommDetailCubitState {}

class SocialStoryTargetChanged extends SocialStoryCommDetailCubitState {
  final List<SocialStory> socialStoryList;
  final SocialStory socialStory;

  SocialStoryTargetChanged(this.socialStory, this.socialStoryList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocialStoryTargetChanged &&
        listEquals(other.socialStoryList, socialStoryList) &&
        other.socialStory == socialStory;
  }

  @override
  int get hashCode => socialStoryList.hashCode ^ socialStory.hashCode;
}

class SocialStoryCommDetailError extends SocialStoryCommDetailCubitState {}
