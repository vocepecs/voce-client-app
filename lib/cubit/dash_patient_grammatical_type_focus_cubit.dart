import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/services/dashboard_api.dart';

part 'dash_patient_grammatical_type_focus_state.dart';

class DashPatientGrammaticalTypeFocusCubit
    extends Cubit<DashPatientGrammaticalTypeFocusState> {
  final DashboardApi dashboardApi;
  final Patient patient;

  List<Map<String, dynamic>> data = List.empty(growable: true);

  DashPatientGrammaticalTypeFocusCubit({
    required this.dashboardApi,
    required this.patient,
  }) : super(DashPatientGrammaticalTypeFocusInitial()) {
    getPatientGrammaticalTypeFocusStats([], "", "");
  }

  void getPatientGrammaticalTypeFocusStats(
    List<dynamic> grammaticalTypeData,
    String grammaticalTypeFocus,
    String periodFocus,
  ) async {
    emit(DashPatientGrammaticalTypeFocusLoading());
    data = grammaticalTypeData.map((e) => e as Map<String, dynamic>).toList();
    emit(DashPatientGrammaticalTypeFocusLoaded(
      data.length > 10 ? data.sublist(0, 10) : data,
      grammaticalTypeFocus,
      periodFocus,
    ));
  }
}
