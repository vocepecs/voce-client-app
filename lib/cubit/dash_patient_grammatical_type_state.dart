part of 'dash_patient_grammatical_type_cubit.dart';

@immutable
abstract class DashPatientGrammaticalTypeState {}

class DashPatientGrammaticalTypeInitial
    extends DashPatientGrammaticalTypeState {}

class DashPatientGrammaticalTypeLoading
    extends DashPatientGrammaticalTypeState {}

class DashPatientGrammaticalTypeLoaded extends DashPatientGrammaticalTypeState {
  final List<Map<String, dynamic>> data;
  DashPatientGrammaticalTypeLoaded(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashPatientGrammaticalTypeLoaded &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}

class DashPatientGrammaticalTypeFocus extends DashPatientGrammaticalTypeState {
  final List<Map<String,dynamic>> grammaticalTypeData;
  final String grammaticalTypeFocus;
  final String periodFocus;
  DashPatientGrammaticalTypeFocus(
    this.grammaticalTypeData,
    this.grammaticalTypeFocus,
    this.periodFocus,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DashPatientGrammaticalTypeFocus &&
      listEquals(other.grammaticalTypeData, grammaticalTypeData) &&
      other.grammaticalTypeFocus == grammaticalTypeFocus &&
      other.periodFocus == periodFocus;
  }

  @override
  int get hashCode => grammaticalTypeData.hashCode ^ grammaticalTypeFocus.hashCode ^ periodFocus.hashCode;
}
