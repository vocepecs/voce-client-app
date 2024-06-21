import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'pictograms_state.dart';

class PictogramsCubit extends Cubit<PictogramsState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  List<CaaImage> _pictogramList = List.empty(growable: true);
  Map<int, bool> _filterSelectedPatients = {};
  String _filterText = "";

  PictogramsCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(PictogramsInitial()) {
    getUserPictograms();
  }

  void getUserPictograms() async {
    emit(PictogramsLoading());

    try {
      List<Map<String, dynamic>> imageListData =
          await voceAPIRepository.getImageList(
        userId: user.id,
        searchUserImages: true,
      );

      _pictogramList = imageListData.map((e) => CaaImage.fromJson(e)).toList();
      user.patientList!.forEach(
        (element) {
          _filterSelectedPatients.putIfAbsent(element.id!, () => true);
        },
      );
      emit(PictogramsLoaded(_pictogramList));
    } on VoceApiException catch (error) {
      if (error.statusCode == 404) {
        emit(PictogramsNotFound());
      } else {
        emit(PictogramsError());
      }
    }
  }

  List<String> patientsImage(int imageId) {
    List<String> patientsNickNameList = [];
    user.patientList!.forEach((element) {
      if (element.privateImageList
          .map((e) => e.id)
          .toList()
          .contains(imageId)) {
        patientsNickNameList.add(element.nickname);
      }
    });

    return patientsNickNameList;
  }

  List<Patient> getUserPatientList() => user.patientList!;

  bool isSelectedPatient(int patientId) => _filterSelectedPatients[patientId]!;

  void filterByText(String text) {
    _filterText = text;
    List<CaaImage> tempPictogramList = List<CaaImage>.from(_pictogramList);
    if (_filterText.isNotEmpty) {
      tempPictogramList.removeWhere(
        (element) =>
            !element.label.toLowerCase().contains(_filterText.toLowerCase()),
      );
    }
    emit(PictogramsLoaded(tempPictogramList));
  }

  void filterByPatients(Patient patient, bool value) {
    List<CaaImage> tempPictogramList = List<CaaImage>.from(_pictogramList);

    _filterSelectedPatients.update(patient.id!, (_) => value);

    _filterSelectedPatients.forEach((key, value) {
      Patient p = user.patientList!.firstWhere(
        (element) => element.id == key,
      );
      if (value == false) {
        p.privateImageList.forEach((privateImage) {
          tempPictogramList.removeWhere(
            (image) => image.id! == privateImage.id,
          );
        });
      }
    });

    if (_filterText.isNotEmpty) {
      tempPictogramList.removeWhere(
        (element) => !element.label.contains(_filterText),
      );
    }

    emit(PictogramsLoaded(tempPictogramList));
  }

  void deletePictogram(CaaImage caaImage) async {
    emit(PictogramsLoading());

    try {
      await voceAPIRepository.deleteImage(
        caaImage.id!,
      );
      _pictogramList.removeWhere((element) => element.id == caaImage.id);
      emit(PictogramDeleted());
    } on VoceApiException catch (_) {
      emit(PictogramDeleteError());
    }
  }
}
