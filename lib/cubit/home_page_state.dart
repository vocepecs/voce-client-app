part of 'home_page_cubit.dart';

@immutable
abstract class HomePageState {
  const HomePageState();
}

class HomePageInitial extends HomePageState {
  const HomePageInitial();
}

class PatientListLoaded extends HomePageState {
  final List<Patient> patientList;
  const PatientListLoaded(this.patientList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientListLoaded &&
        listEquals(other.patientList, patientList);
  }

  @override
  int get hashCode => patientList.hashCode;
}

class NoPatientEnrolled extends HomePageState {
  const NoPatientEnrolled();
}

class HomePageStateError extends HomePageState {
  const HomePageStateError();
}

class UserSignOut extends HomePageState {
  const UserSignOut();
}
