import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'set_active_patient_state.dart';

class SetActivePatientCubit extends Cubit<SetActivePatientState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  SetActivePatientCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(SetActivePatientInitial());

  List<Patient> getPatientList() => user.patientList!;

  Future<void> setActivePatient(int patientId) async {
    try {
      await voceAPIRepository.setActivePatient(
        user.id!,
        patientId,
      );
      emit(SetActivePatientDone());
    } on VoceApiException catch (_) {
      emit(SetActivePatientError());
    }
  }
}
