import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'social_story_communication_setup_state.dart';

class SocialStoryCommunicationSetupCubit
    extends Cubit<SocialStoryCommunicationSetupState> {
  final VoceAPIRepository voceAPIRepository;
  List<SocialStory> _socialStoryList = List.empty(growable: true);
  List<SocialStory> _userSocialStoryList = List.empty(growable: true);
  final User user;
  Patient? _activePatient;

  SocialStoryCommunicationSetupCubit(
    this.voceAPIRepository,
    this.user,
  ) : super(SocialStoryCommunicationSetupInitial());

  Patient? getActivePatient() {
    try {
      return user.patientList!.firstWhere((element) => element.isActive!);
    } catch (e) {
      return null;
    }
  }

  void getData() async {
    _activePatient = getActivePatient();

    if (_activePatient != null) {
      if (_activePatient!.socialStoryList.isEmpty) {
        // Se non ci sono storie sociali associate al paziente
        // scarico quelle associate all'utente (Operatore/Tutore)

        try {
          List<Map<String, dynamic>> socialStoryListData =
              await voceAPIRepository.getSocialStories(
            option: 'PRIVATE',
            userId: user.id,
          );

          _userSocialStoryList = List.from(socialStoryListData.map(
            (e) => SocialStory.fromJson(e),
          ));

          if (_userSocialStoryList.isEmpty) {
            emit(SocialStoryCommunicationSetupNoSocialStory());
          } else {
            _socialStoryList = List.from(_userSocialStoryList);
          }

          emit(
            SocialStoryCommunicationSetupLoaded(
              user.patientList!,
              _socialStoryList,
            ),
          );
        } catch (e) {
          emit(SocialStoryCommunicationSetupError());
        }
      } else {
        emit(SocialStoryCommunicationSetupLoaded(
          user.patientList!,
          _activePatient!.socialStoryList,
        ));
      }
    } else {
      emit(SocialStoryCommunicationSetupNoActivePatient(user.patientList!));
    }
  }

  void setActivePatient(Patient patient) {
    emit(SocialStoryCommunicationSetupLoading());

    user.patientList!.forEach((element) {
      element.isActive = false;
      if (element.id == patient.id) {
        element.isActive = true;
      }
    });

    try {
      voceAPIRepository.updateUser(user.toJson());
    } on VoceApiException catch (_) {
      emit(SocialStoryCommunicationSetupError());
    }

    getData();
  }

  void setActiveStory(SocialStory socialStory) {
    emit(SocialStoryCommunicationSetupLoading());

    user.patientList!
        .firstWhere((element) => element.isActive!)
        .socialStoryList
        .forEach((element) {
      element.isActive = false;
      if (element.id == socialStory.id) {
        element.isActive = true;
      }
    });

    try {
      voceAPIRepository.updateUser(user.toJson());
    } on VoceApiException catch (_) {
      emit(SocialStoryCommunicationSetupError());
    }

    emit(
      SocialStoryCommunicationSetupEnded(
        socialStory,
        _activePatient!,
      ),
    );
  }

  void linkSocialStoryToPatient(SocialStory socialStory) async {
    socialStory.isPrivate = true;
    socialStory.isActive = true;

    Map<String, dynamic> ssJson = socialStory.toJsonCustom();

    try {
      Map<String, dynamic> responseData =
          await voceAPIRepository.createSocialStory(
        ssJson,
        user.id!,
        patientId: _activePatient!.id,
        originalSocialStoryId: socialStory.id,
      );
      _finalizeSocialStoryLinked(responseData['social_story_id']);
    } on VoceApiException catch (_) {
      emit(SocialStoryCommunicationSetupError());
    }
  }

  void _finalizeSocialStoryLinked(int socialStoryId) async {
    try {
      Map<String, dynamic> socialStoryData =
          await voceAPIRepository.getSocialStory(socialStoryId);

      SocialStory newSocialStory = SocialStory.fromJson(socialStoryData);

      user.patientList!.forEach((element) {
        if (element.id == _activePatient!.id) {
          element.socialStoryList.add(newSocialStory);
        }
      });

      emit(SocialStoryCommunicationSetupEnded(
        newSocialStory,
        _activePatient!,
      ));
    } on VoceApiException catch (_) {
      emit(SocialStoryCommunicationSetupError());
    }
  }
}
