import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/enums/patient_operation.dart';
import 'package:voce/models/enums/social_story_view_type.dart';
import 'package:voce/models/enums/vocal_profile.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'add_new_patient_state.dart';

class AddNewPatientCubit extends Cubit<AddNewPatientState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  final PatientOperation patientOperation;
  Patient? patient;
  VocaProfile vocalProfile = VocaProfile.MALE;

  AddNewPatientCubit({
    required this.voceAPIRepository,
    required this.patientOperation,
    required this.user,
    this.patient,
  }) : super(AddNewPatientInitial());

  void updateName(String value) => patient!.nickname = value;
  void updateDateOfBirth(DateTime value) {
    emit(AddNewPatientInitial());
    patient!.dateOfBirth = value;
    emit(PatientDataLoaded(patient!));
  }

  void updateNotes(String value) => patient!.notes = value;

  void getPatientData() {
    if (patientOperation == PatientOperation.CREATE) {
      patient = Patient.createNewPatient();
    }
    emit(PatientDataLoaded(patient!));
  }

  void updateVocalProfile(String? value) {
    switch (value) {
      case "Maschio":
        vocalProfile = VocaProfile.MALE;
        break;
      case "Femmina":
        vocalProfile = VocaProfile.FEMALE;
        break;
      default:
        vocalProfile = VocaProfile.MALE;
        break;
    }
  }

  void updateSocialStoryViewType(String? value) {
    switch (value) {
      case 'Singola frase':
        patient!.socialStoryViewType = SocialStoryViewType.SINGLE;
        break;
      case 'Frasi multiple':
        patient!.socialStoryViewType = SocialStoryViewType.MULTIPLE;
        break;
    }
  }

  void updateFullTtsEnabled(String? value) {
    switch(value){
      case 'Abilitato':
        patient!.fullTtsEnabled = true;
        break;
      case 'Disabilitato':
        patient!.fullTtsEnabled = false;
        break;
    }
  }

  Future<void> savePatient() async {
    patient!.vocalProfile = vocalProfile;
    switch (patientOperation) {
      case PatientOperation.CREATE:
        try {
          /// ! ATTENZIONE:
          /// ! Sto usando un solo try catch per due chiamate API diverse
          /// ! Questo è un anti-pattern, ma per ora non ho trovato una soluzione migliore
          /// ! In futuro, se possibile, separare le due chiamate API in due metodi diversi
          /// ! e gestire i due errori separatamente
          Map<String, dynamic> patientCreatedData =
              await voceAPIRepository.createPatient(
            patient!.toJson(),
            user.id!,
          );
          await voceAPIRepository.enrollPatient(
              user.id!, patientCreatedData['patient_id']);
          emit(AddNewPatientConfirmed());
        } on VoceApiException catch (_) {
          emit(AddNewPatientError());
        }

        break;
      case PatientOperation.UPDATE:
        try {
          await voceAPIRepository.updatePatient(
            patient!.toJson(),
            patient!.id!,
          );
          emit(PatientUpdatedSuccessfully());
        } on VoceApiException catch (_) {
          emit(PatientUpdateError());
        }
        break;
    }
  }
}
