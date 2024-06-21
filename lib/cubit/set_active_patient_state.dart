part of 'set_active_patient_cubit.dart';

@immutable
abstract class SetActivePatientState {
  const SetActivePatientState();
}

class SetActivePatientInitial extends SetActivePatientState {
  const SetActivePatientInitial();
}

class SetActivePatientDone extends SetActivePatientState {
  const SetActivePatientDone();
}

class SetActivePatientError extends SetActivePatientState {}
