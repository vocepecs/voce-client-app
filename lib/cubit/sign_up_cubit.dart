import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/autism_centre.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final VoceAPIRepository voceAPIRepository;
  final AuthRepository authRepository;
  AutismCentre? _autismCentreSelected;
  late String _autismCentreCode;
  late String _userName = '';
  late String _email = '';
  late String _password = '';
  late String _passwordConfirmation = '';
  bool _emailCommunicationConfirmed = false;

  SignUpCubit({
    required this.authRepository,
    required this.voceAPIRepository,
  }) : super(SignUpInitial());

  String get userName => this._userName;
  String get email => this._email;
  String get password => this._password;
  String get passwordConfirmation => this._passwordConfirmation;

  void updateAutsimCentreCode(String value) => _autismCentreCode = value;
  void updateUserName(String value) => _userName = value;
  void updateEmail(String value) => _email = value;
  void updatePassword(String value) => _password = value;
  void updatePasswordConfirmation(String value) =>
      _passwordConfirmation = value;
  
  void updateEmailCommunicationConfirmed(bool value) => _emailCommunicationConfirmed = value;

  void checkSignUpData() {
    emit(SignUpInitial());
    if (_userName.isEmpty || _email.isEmpty || _password.isEmpty) {
      emit(EmptyFieldData());
    } else if (_passwordConfirmation.compareTo(_password) != 0) {
      emit(WrongPasswordConfirmation());
    } else {
      emit(UserDataCorrect());
    }
  }

  Future<void> createUser() async {
    Map<String, dynamic> data = {
      "email": _email.trim(),
      "password": _password.trim(),
      "name": _userName.trim(),
      "role_id": 1,
      "autism_centre_code": _autismCentreSelected?.id,
      "email_subscription": _emailCommunicationConfirmed,
    };

    try {
      Map<String, dynamic> userData = await authRepository.signUpUser(data);
      User user = User.fromJson(userData);

      await authRepository.sendEmailConfirmation(user.email);

      emit(UserCreated(user));
    } on VoceApiException catch (e) {
      if (e.statusCode == 400) {
        emit(UserAlreadyExists());
      } else {
        emit(UserCreationError());
      }
    }
  }
}
