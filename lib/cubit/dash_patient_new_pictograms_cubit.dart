import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/services/dashboard_api.dart';

part 'dash_patient_new_pictograms_state.dart';

class DashPatientNewPictogramsCubit
    extends Cubit<DashPatientNewPictogramsState> {
  final DashboardApi dashboardApi;
  final Patient patient;
  List<Map<String, dynamic>> data = List.empty(growable: true);
  bool weekView = false;

  DateTime _startDate = DateTime.now().subtract(Duration(days: 365));
  DateTime _endDate = DateTime.now();

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  DashPatientNewPictogramsCubit({
    required this.dashboardApi,
    required this.patient,
  }) : super(DashPatientNewPictogramsInitial()) {
    getPatientPictogramsStats();
  }

  void _checkInputDate() {
    if (_startDate.isAfter(_endDate)) {
      // TODO Errore input data
    } else if (_startDate.difference(_endDate) > Duration(days: 365)) {
      // TODO Errore input data
    }
    {
      getPatientPictogramsStats();
    }
  }

  void updateStartDate(DateTime value) {
    _startDate = value;
    _checkInputDate();
  }

  void updateEndDate(DateTime value) {
    //20/07/2023
    _endDate = value;
    _checkInputDate();
  }

  void updateWeekView(bool value) {
    weekView = value;
    getPatientPictogramsStats();
  }

  void getPatientPictogramsStats() async {
    emit(DashPatientNewPictogramsLoading());

    List<dynamic> resData;

    try {
      resData = await dashboardApi.getNewPictogramsStats(
        dateStart: _startDate,
        dateEnd: _endDate,
        patientId: patient.id,
        weekView: weekView,
      );

      data = resData.map((e) => e as Map<String, dynamic>).toList();

      emit(DashPatientNewPictogramsLoaded(data));
    } on VoceApiException catch (error) {
      print("STATUS CODE: ${error.statusCode}\n${error.message}");
    }
  }
}
