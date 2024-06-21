import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/services/dashboard_api.dart';

part 'dash_patient_phrase_stats_state.dart';

class DashPatientPhraseStatsCubit extends Cubit<DashPatientPhraseStatsState> {
  final DashboardApi dashboardApi;
  final Patient patient;
  List<Map<String, dynamic>> data = List.empty(growable: true);
  bool weekWiew = false;
  bool chartTypeLength = true;

  DateTime _startDate = DateTime.now().subtract(Duration(days: 60));
  DateTime _endDate = DateTime.now();

  DateTime get starteDate => _startDate;
  DateTime get endDate => _endDate;

  DashPatientPhraseStatsCubit({
    required this.dashboardApi,
    required this.patient,
  }) : super(DashPatientPhraseStatsInitial()) {
    getPatientPhraseStats();
  }

  void _checkInputDate() {
    if (_startDate.isAfter(_endDate)) {
      // TODO Errore input data
    } else if (_startDate.difference(_endDate) > Duration(days: 365)) {
      // TODO Errore input data
    }
    {
      getPatientPhraseStats();
    }
  }

  void updateChartType(bool value) {
    emit(DashPatientPhraseStatsloading());
    chartTypeLength = value;
    emit(DashPatientPhraseStatsLoaded(data));
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
    weekWiew = value;
    getPatientPhraseStats();
  }

  void getPatientPhraseStats() async {
    emit(DashPatientPhraseStatsloading());

    List<dynamic> resData;

    try {
      resData = await dashboardApi.getPhraseStats(
        dateStart: _startDate,
        dateEnd: _endDate,
        patientId: patient.id,
        weekView: weekWiew,
      );

      data = resData.map((e) => e as Map<String, dynamic>).toList();
      emit(DashPatientPhraseStatsLoaded(data));
    } on VoceApiException catch (error) {
      print("STATUS CODE: ${error.statusCode}\n${error.message}");
    }
  }
}
