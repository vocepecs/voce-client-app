import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final VoceAPIRepository voceAPIRepository;
  final AuthRepository authRepository;
  final int userId;
  late User _user;
  HomePageCubit({
    required this.voceAPIRepository,
    required this.authRepository,
    required this.userId,
  }) : super(HomePageInitial());

  User get user => _user;

  void getPatientList() {
    if (_user.patientList!.length > 0) {
      emit(PatientListLoaded(_user.patientList!));
    } else {
      emit(NoPatientEnrolled());
    }
  }

  Future<void> getUser() async {
    emit(HomePageInitial());

    try {
      Map<String, dynamic> userData = await voceAPIRepository.getUser(userId);
      _user = User.fromJson(userData);
      emit(PatientListLoaded(_user.patientList!));
    } on VoceApiException catch (_) {
      emit(HomePageStateError());
    }
  }

  void updateUser() async {
    emit(HomePageInitial());
    getUser();
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
      emit(HomePageStateError());
    }
  }
}
