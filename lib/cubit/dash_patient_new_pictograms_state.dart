part of 'dash_patient_new_pictograms_cubit.dart';

@immutable
abstract class DashPatientNewPictogramsState {}

class DashPatientNewPictogramsInitial extends DashPatientNewPictogramsState {}

class DashPatientNewPictogramsLoading extends DashPatientNewPictogramsState {}

class DashPatientNewPictogramsLoaded extends DashPatientNewPictogramsState {
  final List<Map<String, dynamic>> data;
  DashPatientNewPictogramsLoaded(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashPatientNewPictogramsLoaded &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
