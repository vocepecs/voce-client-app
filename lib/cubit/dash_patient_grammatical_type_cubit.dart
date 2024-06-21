import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/services/dashboard_api.dart';

part 'dash_patient_grammatical_type_state.dart';

class DashPatientGrammaticalTypeCubit
    extends Cubit<DashPatientGrammaticalTypeState> {
  final DashboardApi dashboardApi;
  final Patient patient;

  String grammaticalTypeFocus = "";
  String periodFocus = "";
  final Map<String, String> grammaticalTypeMap = {
    "ADJECTIVE": "Aggettivo",
    "ADVERB": "Avverbio",
    "MAIN VERB": "Verbo",
    "COMMON NOUN": "Sostantivo",
    "RESIDUAL CLASS (UNDEFINED)": "indefinito",
  };
  List<Map<String, dynamic>> data = List.empty(growable: true);
  bool weekView = false;

  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  DashPatientGrammaticalTypeCubit({
    required this.dashboardApi,
    required this.patient,
  }) : super(DashPatientGrammaticalTypeInitial()) {
    getPatientGrammaticalTypeStats();
  }

  void _checkInputDate() {
    if (_startDate.isAfter(_endDate)) {
      // TODO Errore input data
    } else if (_startDate.difference(_endDate) > Duration(days: 365)) {
      // TODO Errore input data
    }
    {
      getPatientGrammaticalTypeStats();
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
    getPatientGrammaticalTypeStats();
  }

  void getPatientGrammaticalTypeStats() async {
    emit(DashPatientGrammaticalTypeLoading());

    List<dynamic> resData;

    try {
      resData = await dashboardApi.getGrammaticalTypesStats(
        dateStart: _startDate,
        dateEnd: _endDate,
        patientId: patient.id,
        weekView: weekView,
      );

      data = resData.map((e) => e as Map<String, dynamic>).toList();
      emit(DashPatientGrammaticalTypeLoaded(data));
    } on VoceApiException catch (error) {
      print("STATUS CODE: ${error.statusCode}\n${error.message}");
    }
  }

  void emitGrammaticalTypeFocusState(List<dynamic> grammaticalTypeData) {
    emit(DashPatientGrammaticalTypeLoading());
    data = grammaticalTypeData.map((e) => e as Map<String, dynamic>).toList();
    emit(
      DashPatientGrammaticalTypeFocus(
        data.length > 10 ? data.sublist(0, 10) : data,
        grammaticalTypeFocus,
        periodFocus,
      ),
    );
  }

  List<dynamic> getGrammaticalTypeFocus(int barIndex, String grammaticalType) {
    List<dynamic> imageList = List.empty(growable: true);
    List<Map<String, dynamic>> grammTypeList =
        (data[barIndex]["values"] as List)
            .map((e) => (e as Map<String, dynamic>))
            .toList();
    periodFocus = data[barIndex]["date_start_interval"] +
        " - " +
        data[barIndex]["date_end_interval"];
    grammaticalTypeFocus = grammaticalTypeMap[grammaticalType]!;
    grammTypeList.forEach((element) {
      if (element["gramm_type"] == grammaticalType) {
        imageList.addAll(element["image_list"]);
      }
    });
    return imageList;
  }
}
