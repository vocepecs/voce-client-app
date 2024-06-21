import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'image_list_panel_state.dart';

class ImageListPanelCubit extends Cubit<ImageListPanelState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  late List<CaaImage> _imageList;
  Patient? patient;
  late String _searchText;

  ImageListPanelCubit({
    required this.voceAPIRepository,
    required this.user,
    this.patient,
  }) : super(ImageListPanelInitial()) {
    _imageList = [];
  }

  void getImageList() async {
    if (_searchText.isNotEmpty) {
      emit(ImageListPanelLoading());
      _imageList.clear();
      Map<String, dynamic> data;

      if (patient == null) {
        data = {'phrase': _searchText, 'user_id': user.id};
      } else {
        data = {
          'patient_id': patient!.id.toString(),
          'phrase': _searchText,
          'user_id': user.id.toString(),
        };
      }
      try {
        List<Map<String, dynamic>> imageListData =
            await voceAPIRepository.searchImages(data);
        _imageList.addAll(List.from(
          imageListData.map((e) => CaaImage.fromJson(e)),
        ));
        emit(ImageListPanelLoaded(_imageList));
      } on VoceApiException catch (_) {
        emit(ImageListPanelError());
      }
    } else {
      //TODO Search text is empty
    }
  }

  void updateSearchText(String value) {
    _searchText = value;
    print(_searchText);
  }
}
