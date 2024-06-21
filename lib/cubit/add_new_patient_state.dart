part of 'add_new_patient_cubit.dart';

@immutable
abstract class AddNewPatientState {
  const AddNewPatientState();
}

class AddNewPatientInitial extends AddNewPatientState {
  const AddNewPatientInitial();
}

class PatientDataLoaded extends AddNewPatientState {
  final Patient patient;
  const PatientDataLoaded(this.patient);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientDataLoaded && other.patient == patient;
  }

  @override
  int get hashCode => patient.hashCode;
}

class AddNewPatientConfirmed extends AddNewPatientState {
  const AddNewPatientConfirmed();
}

class PatientUpdatedSuccessfully extends AddNewPatientState {
  const PatientUpdatedSuccessfully();
}

class AddNewPatientError extends AddNewPatientState {
  const AddNewPatientError();
}

class PatientUpdateError extends AddNewPatientState {
  const PatientUpdateError();
}
