part of 'patient_screen_cubit.dart';

@immutable
abstract class PatientScreenState {
  const PatientScreenState();
}

class PatientScreenLoading extends PatientScreenState {
  const PatientScreenLoading();
}

class PatientScreenLoaded extends PatientScreenState {
  final Patient patient;
  const PatientScreenLoaded(this.patient);
}

class PatientScreenTableDeletionError extends PatientScreenState {}

class PatientScreenLoadingError extends PatientScreenState {}

class PatientScreenUpdateSuccesful extends PatientScreenState {}
