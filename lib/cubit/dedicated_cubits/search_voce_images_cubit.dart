import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'search_voce_images_state.dart';

class SearchVoceImagesCubit extends Cubit<SearchVoceImagesState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  late List<CaaImage> _imageList = List.empty(growable: true);
  Map<int, dynamic> imageSelectedList = {};
  late String _searchText;
  SearchVoceImagesCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(SearchVoceImagesInitial());

  set searchText(value) => _searchText = value;

  void getImageList() async {
    if (_searchText.isNotEmpty) {
      emit(SearchVoceImagesLoading());
      _imageList.clear();

      try {
        List<Map<String, dynamic>> imageListData =
            await voceAPIRepository.searchImages(
          <String, dynamic>{
            "phrase": _searchText,
            "user_id": user.id,
          },
        );

        _imageList.addAll(List.from(
          imageListData.map((e) => CaaImage.fromJson(e)),
        ));
        setImageSelectedList(_imageList);
        emit(SearchVoceImagesloaded(_imageList));
      } on VoceApiException catch (_) {
        emit(SearchVoceImagesError());
      }
    } else {
      //TODO Search text is empty
    }
  }

  void setImageSelectedList(List<CaaImage> imageList) {
    imageSelectedList = Map.fromIterable(
      imageList,
      key: (element) => (element as CaaImage).id!,
      value: (element) => false,
    );
  }
}
