import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/services/dashboard_api.dart';

part 'dash_patient_image_count_state.dart';

class DashPatientImageCountCubit extends Cubit<DashPatientImageCountState> {
  final DashboardApi dashboardApi;
  final Patient patient;
  List<Map<String, dynamic>> data = List.empty(growable: true);

  // usata per switch vista pittogrammi/contesti
  bool chartTypePictograms = true;

  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();

  DateTime get starteDate => _startDate;
  DateTime get endDate => _endDate;

  DashPatientImageCountCubit({
    required this.dashboardApi,
    required this.patient,
  }) : super(DashPatientImageCountInitial()) {
    getPatientImageAndContextStats();
  }

  void _checkInputDate() {
    if (_startDate.isAfter(_endDate)) {
      // TODO Errore input data
    } else if (_startDate.difference(_endDate) > Duration(days: 365)) {
      // TODO Errore input data
    }
    {
      getPatientImageAndContextStats();
    }
  }

  void updateChartType(bool value) {
    emit(DashPatientImageCountLoading());
    chartTypePictograms = value;
    getPatientImageAndContextStats();
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

  void getPatientImageAndContextStats() async {
    emit(DashPatientImageCountLoading());
    List<dynamic>? resdata;
    try {
      if (chartTypePictograms) {
        resdata = await dashboardApi.getMostFrequentImages(
          dateStart: _startDate,
          dateEnd: _endDate,
          patientId: patient.id,
        );
      } else {
        resdata = await dashboardApi.getMostFrequentContexts(
          dateStart: _startDate,
          dateEnd: _endDate,
          patientId: patient.id,
        );
      }

      data = resdata!.map((e) => e as Map<String, dynamic>).toList();
      emit(DashPatientImageCountLoaded(data));
    } on VoceApiException catch (error) {
      print("STATUS CODE: ${error.statusCode}\n${error.message}");
      if (error.statusCode == 404) {
        emit(DashPatientImageCountNotEnoughtData());
      }
    }
  }

  void contextImageFocus(int contextIndex) {
    emit(DashPatientImageCountLoading());
    Map<String, dynamic> context = data[contextIndex];
    List<Map<String, dynamic>> imageList = (context["image_list"] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    emit(
      DashPatientImageCountFocusContext(
        imageList.length > 10 ? imageList.sublist(0, 10) : imageList,
        context["type"],
      ),
    );
  }
}
