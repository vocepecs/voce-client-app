part of 'profile_info_cubit.dart';

@immutable
abstract class ProfileInfoState {
  const ProfileInfoState();
}

class ProfileInfoInitial extends ProfileInfoState {}

class ProfileInfoLoading extends ProfileInfoState {}

class ProfileInfoLoaded extends ProfileInfoState {
  final User user;
  const ProfileInfoLoaded(this.user);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileInfoLoaded && other.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class ProfileInfoUpdated extends ProfileInfoState {}

class ProfileInfoError extends ProfileInfoState {}

class ProfileInfoUpdateError extends ProfileInfoState {
  final String message;
  const ProfileInfoUpdateError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileInfoUpdateError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class ProfileInfoDeleted extends ProfileInfoState {}

class UserSignOut extends ProfileInfoState {}
