import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/constants/app_constants.dart';
import 'package:voce/models/enums/auth_error_type.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final VoceAPIRepository voceAPIRepository;
  final AuthRepository authRepository;

  String _username = '';
  String _email = '';
  String _password = '';
  String _passwordConfirmation = '';
  bool _emailCommunicationConfirmed = false;
  bool _isSignupPage = false;

  bool _persistentLogin = false;

  AuthCubit({
    required this.voceAPIRepository,
    required this.authRepository,
  }) : super(AuthInitial());

  void emitNotLoggedIn() {
    emit(AuthStateNotLoggedIn());
  }

  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get passwordConfirmation => _passwordConfirmation;
  bool get emailCommunicationConfirmed => _emailCommunicationConfirmed;
  bool get persistentLogin => _persistentLogin;
  bool get isSignupPage => _isSignupPage;

  set username(String value) => _username = value;
  set email(String value) => _email = value;
  set password(String value) => _password = value;
  set passwordConfirmation(String value) => _passwordConfirmation = value;
  set emailCommunicationConfirmed(bool value) =>
      _emailCommunicationConfirmed = value;
  set persistentLogin(bool value) => _persistentLogin = value;
  set isSignupPage(bool value) => _isSignupPage = value;

  bool checkSignUpData() {
    if (_username.isEmpty || _email.isEmpty || _password.isEmpty) {
      emit(AuthSignUpError(MAP_ERROR_MESSAGE[AuthErrorType.EMPTY_FIELD_DATA]!));
      return false;
    } else if (_passwordConfirmation.compareTo(_password) != 0) {
      emit(AuthSignUpError(
          MAP_ERROR_MESSAGE[AuthErrorType.WRONG_PASSWORD_CONFIRMATION]!));
      return false;
    } else {
      return true;
    }
  }

  Future<void> signUpWhitEmailAndPassword() async {
    User? user;

    if (checkSignUpData()) {
      Map<String, dynamic> data = {
        "email": _email.trim(),
        "password": _password.trim(),
        "name": _username.trim(),
        "role_id": 1,
        "email_subscription": _emailCommunicationConfirmed,
        "first_access": true,
      };

      try {
        Map<String, dynamic> userData = await authRepository.signUpUser(data);
        user = User.fromJson(userData);
      } on VoceApiException catch (e) {
        if (e.statusCode == 400) {
          if (e.data!['error'] == 'user-already-exists') {
            emit(AuthSignUpError(
                MAP_ERROR_MESSAGE[AuthErrorType.USER_ALREADY_EXISTS]!));
          } else if (e.data!['error'] == 'invalid-email-format') {
            emit(AuthSignUpError(
                MAP_ERROR_MESSAGE[AuthErrorType.INVALID_EMAIL]!));
          } else {
            emit(
                AuthSignUpError(MAP_ERROR_MESSAGE[AuthErrorType.GENERIC_ERROR]!));
          }
        } else {
          emit(
              AuthSignUpError(MAP_ERROR_MESSAGE[AuthErrorType.GENERIC_ERROR]!));
        }
      }

      try {
        await authRepository.sendEmailConfirmation(user!.email);
        emit(AuthSignUpSuccesful(user));
      } on VoceApiException catch (e) {
        if (e.statusCode == 400) {
          emit(
              AuthSignUpError(MAP_ERROR_MESSAGE[AuthErrorType.INVALID_EMAIL]!));
        } else {
          emit(
              AuthSignUpError(MAP_ERROR_MESSAGE[AuthErrorType.GENERIC_ERROR]!));
        }
      }
    }
  }

  void automatedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool isPersistentLogin = prefs.getBool('persistent_login') ?? false;
    print('[Info] Persisten Login : $isPersistentLogin');

    if (isPersistentLogin) {
      final email = prefs.getString('email')!;
      final password = prefs.getString('password')!;

      try {
        Map<String, dynamic> responseData =
            await authRepository.signInWithEmailAndPassword(
          email,
          password,
        );

        prefs.setString(
          'access_token',
          responseData['access_token'],
        );
        prefs.setString(
          'refresh_token',
          responseData['refresh_token'],
        );
        prefs.setInt(
          'user_id',
          responseData['user_id'],
        );
        emit(AuthStateUserLoggedIn(responseData['user_id']));
      } on VoceApiException catch (error) {
        if (error.statusCode == 401) {
          emit(AuthStateInvalidCredentials());
        } else if (error.statusCode == 404) {
          emit(AuthStateUserNotFound());
        }
      }
    } else {
      checkToken();
    }
  }

  void checkToken() {
    SharedPreferences.getInstance().then((prefs) async {
      String? accessToken = prefs.getString('access_token');
      int? userId = prefs.getInt('user_id');
      if (accessToken != null) {
        try {
          await authRepository.handShake();
          emit(AuthStateUserLoggedIn(userId!));
        } on VoceApiException catch (_) {
          emit(AuthStateNotLoggedIn());
        }
      } else {
        emit(AuthStateNotLoggedIn());
      }
    });
  }

  void signInWithEmailAndPassword() async {
    try {
      Map<String, dynamic> responseData =
          await authRepository.signInWithEmailAndPassword(
        _email.trim(),
        _password.trim(),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(
        'access_token',
        responseData['access_token'],
      );

      prefs.setString(
        'refresh_token',
        responseData['refresh_token'],
      );

      prefs.setInt(
        'user_id',
        responseData['user_id'],
      );

      prefs.setBool('persistent_login', _persistentLogin);

      if (_persistentLogin) {
        prefs.setString('email', _email.trim());
        prefs.setString('password', _password.trim());
      }
      emit(AuthStateUserLoggedIn(responseData['user_id']));
    } on VoceApiException catch (error) {
      if (error.statusCode == 401) {
        if (error.data!['error'] == 'invalid-credentials')
          emit(AuthStateInvalidCredentials());
        else if (error.data!['error'] == 'user-not-verified') {
          emit(AuthStateUserEmailNotConfirmed());
        } else if (error.data!['error'] == 'user-not-enabled') {
          emit(AuthStateUserNotEnabled());
        }
      } else if (error.statusCode == 404) {
        emit(AuthStateUserNotFound());
      }
    }
  }

  void sendPasswordResetEmail(value) async {
    try {
      await voceAPIRepository.sendPasswordResetEmail(value);
      emit(AuthStatePasswordResetEmailSent());
    } on VoceApiException catch (error) {
      if (error.statusCode == 404) {
        emit(AuthStateUserNotFound());
      }
    }
  }

  void resendConfirmationEmail() async {
    await authRepository.sendEmailConfirmation(_email);
  }
}
