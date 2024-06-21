part of 'auth_cubit.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthStateNotLoggedIn extends AuthState {}

class AuthStateUserLoggedIn extends AuthState {
  final int userId;
  const AuthStateUserLoggedIn(this.userId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthStateUserLoggedIn && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}

class AuthStateInvalidCredentials extends AuthState {}
class AuthStateUserNotFound extends AuthState {}
class AuthStatePasswordResetEmailSent extends AuthState {}
class AuthStateUserEmailNotConfirmed extends AuthState {}
class AuthStateUserNotEnabled extends AuthState {}

class AuthSignUpError extends AuthState {
  final String message;
  AuthSignUpError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthSignUpError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class AuthSignUpSuccesful extends AuthState {
  final User user;
  AuthSignUpSuccesful(this.user);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthSignUpSuccesful && other.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}
