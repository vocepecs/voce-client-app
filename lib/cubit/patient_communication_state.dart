part of 'patient_communication_cubit.dart';

@immutable
abstract class PatientCommunicationState {
  const PatientCommunicationState();
}

class PatientCommunicationInitial extends PatientCommunicationState {
  const PatientCommunicationInitial();
}

class PatientCommunicationLoaded extends PatientCommunicationState {
  final Patient activePatient;
  final List<Tuple2<CaaImage, Color>> imageBar;

  const PatientCommunicationLoaded(
    this.imageBar,
    this.activePatient,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientCommunicationLoaded &&
        other.activePatient == activePatient &&
        listEquals(other.imageBar, imageBar);
  }

  @override
  int get hashCode => activePatient.hashCode ^ imageBar.hashCode;
}

class PatientCommunicationError extends PatientCommunicationState {
  const PatientCommunicationError();
}
