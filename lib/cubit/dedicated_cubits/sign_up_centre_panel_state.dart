part of 'sign_up_centre_panel_cubit.dart';

@immutable
abstract class SignUpCentrePanelState {}

class SignUpCentrePanelInitial extends SignUpCentrePanelState {}

class SignUpCentrePanelLoading extends SignUpCentrePanelState {}

class SignUpCentrePanelLoaded extends SignUpCentrePanelState {
  final List<AutismCentre> autismCentreList;
  SignUpCentrePanelLoaded(this.autismCentreList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignUpCentrePanelLoaded &&
        listEquals(other.autismCentreList, autismCentreList);
  }

  @override
  int get hashCode => autismCentreList.hashCode;
}

class SecretCodeCorrect extends SignUpCentrePanelState {}

class SecretCodeIncorrect extends SignUpCentrePanelState {}

class SignUpCentrePanelError extends SignUpCentrePanelState {}
