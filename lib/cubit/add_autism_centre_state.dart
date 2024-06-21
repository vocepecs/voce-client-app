part of 'add_autism_centre_cubit.dart';

@immutable
abstract class AddAutismCentreState {
  const AddAutismCentreState();
}

class AddAutismCentreInitial extends AddAutismCentreState {
  const AddAutismCentreInitial();
}

class AddAutismCentreLoading extends AddAutismCentreState {
  const AddAutismCentreLoading();
}

class AutismCentreCreated extends AddAutismCentreState {
  final String secretCode;
  const AutismCentreCreated(this.secretCode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutismCentreCreated && other.secretCode == secretCode;
  }

  @override
  int get hashCode => secretCode.hashCode;
}

class AddAutismCentreError extends AddAutismCentreState {}
