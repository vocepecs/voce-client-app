part of 'dash_patient_image_count_cubit.dart';

@immutable
abstract class DashPatientImageCountState {}

class DashPatientImageCountInitial extends DashPatientImageCountState {}

class DashPatientImageCountLoading extends DashPatientImageCountState {}

class DashPatientImageCountLoaded extends DashPatientImageCountState {
  final List<Map<String, dynamic>> data;
  DashPatientImageCountLoaded(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashPatientImageCountLoaded && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}

class DashPatientImageCountFocusContext extends DashPatientImageCountState {
  final List<Map<String, dynamic>> imageList;
  final String context;

  DashPatientImageCountFocusContext(this.imageList, this.context);
}

class DashPatientImageCountNotEnoughtData extends DashPatientImageCountState {}
