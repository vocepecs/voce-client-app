part of 'social_story_communication_setup_cubit.dart';

@immutable
abstract class SocialStoryCommunicationSetupState {}

class SocialStoryCommunicationSetupInitial
    extends SocialStoryCommunicationSetupState {}

class SocialStoryCommunicationSetupLoading
    extends SocialStoryCommunicationSetupState {}

class SocialStoryCommunicationSetupNoSocialStory
    extends SocialStoryCommunicationSetupState {}

class SocialStoryCommunicationSetupNoActivePatient
    extends SocialStoryCommunicationSetupState {
  final List<Patient> patientList;
  SocialStoryCommunicationSetupNoActivePatient(this.patientList);
}

class SocialStoryCommunicationSetupLoaded
    extends SocialStoryCommunicationSetupState {
  final List<Patient> patientList;
  final List<SocialStory> socialStoryList;

  SocialStoryCommunicationSetupLoaded(this.patientList, this.socialStoryList);
}

class SocialStoryCommunicationSetupEnded
    extends SocialStoryCommunicationSetupState {
  final SocialStory socialStory;
  final Patient patient;

  SocialStoryCommunicationSetupEnded(this.socialStory, this.patient);
}

class SocialStoryCommunicationSetupError
    extends SocialStoryCommunicationSetupState {}
