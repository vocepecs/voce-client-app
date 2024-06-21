import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/image.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'open_voce_pictograms_state.dart';

class OpenVocePictogramsCubit extends Cubit<OpenVocePictogramsState> {
  final VoceAPIRepository voceAPIRepository;
  List<CaaImage> _imageList = [];
  String _searchText = "";

  OpenVocePictogramsCubit({
    required this.voceAPIRepository,
  }) : super(OpenVocePictogramsInitial());

  void updateSearchText(String value) => _searchText = value;

  void searchPictograms() async {
    emit(OpenVocePictogramsLoading());

    Map<String, dynamic> data = {'phrase': _searchText};
    try {
      List<Map<String, dynamic>> imageListData =
          await voceAPIRepository.searchImages(data);
      _imageList = List.from(
        imageListData.map((e) => CaaImage.fromJson(e)),
      );
      emit(OpenVocePictogramsLoaded(_imageList));
    } on VoceApiException catch (_) {
      emit(OpenVocePictogramsError());
    }
  }
}
