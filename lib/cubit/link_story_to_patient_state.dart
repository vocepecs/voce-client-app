part of 'link_story_to_patient_cubit.dart';

@immutable
abstract class LinkStoryToPatientState {}

class LinkStoryToPatientInitial extends LinkStoryToPatientState {}

class LinkStoryToPatientLoading extends LinkStoryToPatientState {}

class LinkStoryToPatientLoaded extends LinkStoryToPatientState {
  final List<SocialStory> socialStoryList;
  LinkStoryToPatientLoaded(this.socialStoryList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinkStoryToPatientLoaded &&
        listEquals(other.socialStoryList, socialStoryList);
  }

  @override
  int get hashCode => socialStoryList.hashCode;
}

class LinkStoryToPatientStoryAdded extends LinkStoryToPatientState {}

class LinkStoryToPatientError extends LinkStoryToPatientState {}
