import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'image_correction_panel_state.dart';

class ImageCorrectionPanelCubit extends Cubit<ImageCorrectionPanelState> {
  final VoceAPIRepository voceApiRepository;
  final CaaTable? caaTable;
  final Patient? patient;
  final int comunicativeSessionId;
  late CaaImage oldImage;
  late CaaImage _newImage;
  List<CaaImage> _suggestedimageList = List.empty(growable: true);

  ImageCorrectionPanelCubit({
    required this.voceApiRepository,
    this.caaTable,
    this.patient,
    required this.oldImage,
    required this.comunicativeSessionId,
  }) : super(ImageCorrectionPanelInitial());

  void searchSuggestedImages() async {
    Map<String, dynamic> data = {
      "image_id": oldImage.id!,
      "patient_id": patient != null ? patient!.id! : null
    };

    List<Map<String, dynamic>> suggestedListData =
        await voceApiRepository.searchSuggestedImagesV2Post(data);

    try {
      if (suggestedListData.length > 0) {
        _suggestedimageList =
            suggestedListData.map((e) => CaaImage.fromJson(e)).toList();
        emit(ImageCorrectionPanelLoaded(oldImage, _suggestedimageList));
      } else {
        _suggestedimageList = List.empty(growable: true);
        emit(ImageCorrectionPanelLoaded(oldImage, _suggestedimageList));
      }
    } on VoceApiException catch (_) {
      emit(ImageCorrectionPanelLoaded(oldImage, _suggestedimageList));
    }
  }

  void setNewImage(CaaImage image) async {
    emit(ImageCorrectionPanelInitial());
    print("old image: ${oldImage.id!}");
    print("new image: ${image.id}");
    print("comunicative session: $comunicativeSessionId");
    this._newImage = image;
    emit(
      ImageCorrectionPanelLoaded(_newImage, _suggestedimageList),
    );
  }

  void updateCsOutputImage() async {
    try {
      await voceApiRepository.updateCsOutputImage(
        oldImageId: oldImage.id!,
        newImageId: _newImage.id,
        data: <String, dynamic>{},
        comunicativeSessionId: comunicativeSessionId,
      );
    } on VoceApiException catch (_) {
      emit(ImageCorrectionPanelError());
    }
  }

  CaaImage getNewImage() => _newImage;
}
