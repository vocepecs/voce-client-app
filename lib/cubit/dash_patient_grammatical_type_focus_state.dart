part of 'dash_patient_grammatical_type_focus_cubit.dart';

@immutable
abstract class DashPatientGrammaticalTypeFocusState {}

class DashPatientGrammaticalTypeFocusInitial
    extends DashPatientGrammaticalTypeFocusState {}

class DashPatientGrammaticalTypeFocusLoading
    extends DashPatientGrammaticalTypeFocusState {}

class DashPatientGrammaticalTypeFocusLoaded
    extends DashPatientGrammaticalTypeFocusState {
  final List<Map<String, dynamic>> data;
  final String? grammaticalTypeFocus;
  final String? periodFocus;
  DashPatientGrammaticalTypeFocusLoaded(
    this.data,
    this.grammaticalTypeFocus,
    this.periodFocus,
  );
}
