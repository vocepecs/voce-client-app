import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'patient_screen_state.dart';

class PatientScreenCubit extends Cubit<PatientScreenState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  Patient patient;

  PatientScreenCubit({
    required this.voceAPIRepository,
    required this.patient,
    required this.user,
  }) : super(PatientScreenLoading()) {
    emit(PatientScreenLoaded(patient));
  }

  void getPatientData() async {
    try {
      Map<String, dynamic> patientData =
          await voceAPIRepository.getPatient(patient.id!);
      patient = Patient.fromJson(patientData);
      emit(PatientScreenLoaded(patient));
    } on VoceApiException catch (_) {
      emit(PatientScreenLoadingError());
    }
  }

  void deleteTable(int caaTableId) async {
    emit(PatientScreenLoading());
    patient.tableList.removeWhere((element) => element.id == caaTableId);
    try {
      await voceAPIRepository.deleteCaaTable(caaTableId);
      emit(PatientScreenLoaded(patient));
    } on VoceApiException catch (_) {
      emit(PatientScreenTableDeletionError());
    }
  }

  void updateSuccesful() {
    emit(PatientScreenUpdateSuccesful());
  }
}
