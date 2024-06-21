part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpLoaded extends SignUpState {
  final List<AutismCentre> autismCentreList;
  const SignUpLoaded(this.autismCentreList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignUpLoaded &&
        listEquals(other.autismCentreList, autismCentreList);
  }

  @override
  int get hashCode => autismCentreList.hashCode;
}

class UserCreated extends SignUpState {
  final User user;
  const UserCreated(this.user);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserCreated && other.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class EmptyFieldData extends SignUpState {
  const EmptyFieldData();
}

class WrongPasswordConfirmation extends SignUpState {
  const WrongPasswordConfirmation();
}

class UserDataCorrect extends SignUpState {}

class UserAlreadyExists extends SignUpState {}

class UserCreationError extends SignUpState {}
