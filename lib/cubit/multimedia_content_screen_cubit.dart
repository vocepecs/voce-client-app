import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_multimedia_content.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'multimedia_content_screen_state.dart';

class MultimediaContentScreenCubit extends Cubit<MultimediaContentScreenState> {
  final VoceAPIRepository voceAPIRepository;
  late List<CaaImage> _multimediaContentList = [];
  late Map<int, bool> filterSelectedPatients;
  late Map<int, bool> downloadSelectedPatients;
  bool filterPublic = false;
  bool filterPrivate = false;
  String? _searchText;

  final User user;

  MultimediaContentScreenCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(MultimediaContentScreenInitial()) {
    filterSelectedPatients = Map.fromIterable(
      user.patientList!.toList(),
      key: (element) => element.id,
      value: (_) => false,
    );

    downloadSelectedPatients = Map.fromIterable(
      user.patientList!.toList(),
      key: (element) => element.id,
      value: (_) => false,
    );
  }

  void updateFilterPublic(bool value) {
    filterPublic = value;
    _filterImages();
  }

  void updateFilterPrivate(bool value) {
    filterPrivate = value;
    _filterImages();
  }

  void updateFilterSelectedPatients(int patientId, bool value) {
    filterSelectedPatients.update(patientId, (_) => value);
    _filterImages();
  }

  void updateDownloadSelectedPatients(int patientId, bool value) {
    downloadSelectedPatients.update(patientId, (_) => value);
  }

  void _resetAllFilters() {
    filterSelectedPatients.updateAll((key, value) => false);
    updateFilterPrivate(false);
    updateFilterPublic(false);
  }

  bool _checkIfPrivateImage(int imageId) {
    bool flag = false;
    user.patientList!.forEach((element) {
      if (element.privateImageList.any((element) => element.id == imageId)) {
        flag = true;
      }
    });
    return flag;
  }

  bool _checkIfPatientImage(int patientId, int imageId) {
    return user.patientList!
        .firstWhere((element) => element.id == patientId)
        .privateImageList
        .any((element) => element.id == imageId);
  }

  void _filterImages() {
    List<CaaMultimediaContent> imageFilteredList =
        List.from(_multimediaContentList);

    if (filterPublic && !filterPrivate) {
      imageFilteredList.removeWhere(
        (element) => _checkIfPrivateImage(element.id!),
      );
    } else if (!filterPublic && filterPrivate) {
      imageFilteredList.removeWhere(
        (element) => !_checkIfPrivateImage(element.id!),
      );
    }

    imageFilteredList.removeWhere((element) {
      bool flag = true;
      if (filterSelectedPatients.values.every((element) => element == false)) {
        flag = false;
      } else {
        filterSelectedPatients.forEach((key, value) {
          if (value) {
            if (_checkIfPatientImage(key, element.id!) == true) {
              flag = false;
            }
          }
        });
      }
      return flag;
    });

    emit(MultimediaContentScreenLoaded(imageFilteredList));
  }

  void getMultimediaContents() async {
    emit(MultimediaContentScreenLoading());

    _multimediaContentList.clear();
    List<String> patientIdList =
        List.from(user.patientList!.map((e) => e.id.toString()));
    Map<String, dynamic> data = {
      'patient_list': patientIdList,
      'phrase': _searchText ?? '',
      'user_id': user.id,
    };
    try {
      List<Map<String, dynamic>> imageListData =
          await voceAPIRepository.searchImages(data);

      List<CaaImage> imageList =
          List.from(imageListData.map((e) => CaaImage.fromJson(e)));

      _multimediaContentList.addAll(imageList);
      _filterImages();
    } on VoceApiException catch (_) {
      emit(MultimediaContentScreenError());
    }
  }

  bool checkPrivateImage(int imageId) {
    return user.patientList!.any((element) =>
        element.privateImageList.any((element) => element.id == imageId));
  }

  void updateSearchText(String value) {
    _searchText = value;
    print(_searchText);
  }

  void filterByPatients(Map<int, bool> selectedPatients) {
    List<CaaMultimediaContent> newList =
        List<CaaMultimediaContent>.from(_multimediaContentList);

    List<Patient> patientsTarget = user.patientList!
        .where((element) => selectedPatients[element.id!] == true)
        .toList();

    if (patientsTarget.length > 0) {
      newList.removeWhere((image) => patientsTarget.every((element) =>
          element.privateImageList.every((element) => element.id != image.id)));
    }

    emit(MultimediaContentScreenLoaded(newList));
  }

  void filterOnlyPublicImages() {
    List<CaaMultimediaContent> newList =
        List<CaaMultimediaContent>.from(_multimediaContentList);

    newList.removeWhere((image) => user.patientList!.any((element) =>
        element.privateImageList.any((element) => element.id == image.id)));

    emit(MultimediaContentScreenLoaded(newList));
  }

  void resetFilters() {
    emit(MultimediaContentScreenLoaded(_multimediaContentList));
  }

  void searchPrivateImages(Map<int, bool> selectedPatients) async {
    //Get images
    emit(MultimediaContentScreenLoading());
    _multimediaContentList.clear();

    List<Patient> patientsTarget = user.patientList!
        .where((element) => selectedPatients[element.id!] == true)
        .toList();

    List<String> patientIdList;
    if (patientsTarget.length == 0) {
      patientIdList = List.from(user.patientList!.map((e) => e.id.toString()));
    } else {
      patientIdList = List.from(patientsTarget.map((e) => e.id.toString()));
    }

    Map<String, dynamic> data = {
      'patient_list': patientIdList,
      'phrase': _searchText ?? '',
    };

    try {
      List<Map<String, dynamic>> imageListData =
          await voceAPIRepository.searchImages(
        data,
        searchType: 'IMAGE_SEARCH_PRIVATE',
      );

      List<CaaImage> imageList =
          List.from(imageListData.map((e) => CaaImage.fromJson(e)));

      _multimediaContentList.addAll(imageList);
      _filterImages();
    } on VoceApiException catch (_) {
      emit(MultimediaContentScreenError());
    }
  }
}
