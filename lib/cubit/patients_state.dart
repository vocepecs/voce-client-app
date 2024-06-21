part of 'patients_cubit.dart';

@immutable
abstract class PatientsState {
  const PatientsState();
}

class PatientsInitial extends PatientsState {
  const PatientsInitial();
}

class PatientsLoaded extends PatientsState {
  final List<Patient> patientList;
  const PatientsLoaded(this.patientList);
}
