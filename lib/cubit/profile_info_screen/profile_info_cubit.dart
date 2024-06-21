import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  final VoceAPIRepository voceAPIRepository;
  final AuthRepository authRepository = AuthRepository();
  final int userId;
  late User _user;
  String _oldPassowrd = "";
  String _newPassword = "";

  ProfileInfoCubit({
    required this.voceAPIRepository,
    required this.userId,
  }) : super(ProfileInfoInitial());

  User get user => _user;

  void emitProfileInfoLoaded() {
    emit(ProfileInfoLoaded(_user));
  }

  void getUserData() async {
    try {
      Map<String, dynamic> userData = await voceAPIRepository.getUser(userId);
      _user = User.fromJson(userData);
      emit(ProfileInfoLoaded(_user));
    } on VoceApiException catch (_) {
      emit(ProfileInfoError());
    }
  }

  void updateUserName(String userName) {
    _user.name = userName;
    updateUser();
  }

  void updateUserEmail(String userEmail) {
    _user.email = userEmail;
    updateUser();
  }

  void updateUserPassword(
    String oldPassword,
    String newPassword,
  ) {
    _oldPassowrd = oldPassword;
    _newPassword = newPassword;
    updateUser();
  }

  void updateUser() async {
    emit(ProfileInfoLoading());
    Map<String, dynamic> data = _user.toJson();
    Map<String, dynamic> selectedData = {
      'name': data['name'],
      'email': data['email'],
      'old_password': _oldPassowrd.isEmpty ? null : _oldPassowrd,
      'password': _newPassword.isEmpty ? null : _newPassword,
    };

    try {
      await voceAPIRepository.updateUser(selectedData);
      // emit(ProfileInfoLoaded(_user));
      emit(ProfileInfoUpdated());
    } on VoceApiException catch (error) {
      Map<String, dynamic> errorData = error.data!;
      if (error.statusCode == 401) {
        if (errorData["title"] == "password-not-match") {
          emit(
            ProfileInfoUpdateError(
                "La vecchia password non è corretta. Per favore riprova con un'altra password."),
          );
        } else {
          emit(ProfileInfoError());
        }
      }
      emit(ProfileInfoError());
    }
  }

  void updateLocalUser(User user) {
    _user = user;
    emit(ProfileInfoLoaded(_user));
  }

  void sendDeleteAccountRequest() async {
    emit(ProfileInfoLoading());
    try {
      await voceAPIRepository.sendAccountDeletionRequest(user.id!.toString());
      emit(ProfileInfoDeleted());
    } on VoceApiException catch (_) {
      emit(ProfileInfoError());
    }
  }

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await authRepository.signOut();
      prefs.remove('access_token');
      prefs.remove('refresh_token');
      prefs.remove('user_id');
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('persistent_login');
      emit(UserSignOut());
    } on VoceApiException catch (_) {
      emit(ProfileInfoError());
    }
  }
}
