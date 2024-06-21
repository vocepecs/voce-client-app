import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/image.dart';

part 'comunicative_session.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class ComunicativeSession {
  ComunicativeSession(
    this._id,
    this._title,
    this._imageList,
  ) : _csOutputUpdateMap = [] {
    this._imageList.forEach((element) {
      this.addUnmodifiedImage(element.id!);
    });
  }

  int _id;
  String _title;
  List<CaaImage> _imageList;
  List<Map<String, dynamic>> _csOutputUpdateMap;

  int get id => _id;
  String get title => _title;
  List<CaaImage> get imageList => _imageList;

  set title(value) => _title = value;

  factory ComunicativeSession.fromJson(Map<String, dynamic> json) =>
      _$ComunicativeSessionFromJson(json);
  Map<String, dynamic> toJson() => _$ComunicativeSessionToJson(this);

  void updateCsOutputUpdateMap(int imageId) {
    _csOutputUpdateMap.add(<String, dynamic>{"status": 1, "image_id": imageId});
  }

  void changeImagePosition(int oldPosition, int newPosition) {
    CaaImage image = _imageList[oldPosition];
    _imageList.removeAt(oldPosition);
    _imageList.insert(newPosition, image);

    Map<String, dynamic> csOutputImage = _csOutputUpdateMap[oldPosition];
    _csOutputUpdateMap.removeAt(oldPosition);
    _csOutputUpdateMap.insert(newPosition, csOutputImage);
  }

  void deleteImage(int imageId) {
    _imageList.removeWhere((element) => element.id == imageId);
    int targetIndex = _csOutputUpdateMap
        .indexWhere((element) => element["image_id"] == imageId);
    _csOutputUpdateMap[targetIndex]["status"] =
        CsOutputStatus.DELETED.index + 1;
  }

  void changeImage(int oldImageId, CaaImage newImage) {
    _imageList.replaceRange(
      _imageList.indexWhere((element) => element.id == oldImageId),
      _imageList.indexWhere((element) => element.id == oldImageId) + 1,
      [newImage],
    );

    int targetIndex = _csOutputUpdateMap
        .indexWhere((element) => element["image_id"] == oldImageId);
    _csOutputUpdateMap[targetIndex]["status"] =
        CsOutputStatus.MODIFIED.index + 1;
    _csOutputUpdateMap[targetIndex]["correct_image_id"] = newImage.id!;
  }

  void addImage(CaaImage image) {
    _imageList.add(image);
    addUnmodifiedImage(image.id!);
  }

  void addUnmodifiedImage(int imageId) => _csOutputUpdateMap.add({
        "status": CsOutputStatus.UNMODIFIED.index + 1,
        "image_id": imageId,
      });

  Map<String, dynamic> getCsOutputJson() {
    return <String, dynamic>{
      "cs_id": _id,
      "title": _title,
      "image_list": _csOutputUpdateMap
    };
  }

  void addPictogramsToList(List<CaaImage> imageList) =>
      _imageList.addAll(imageList);
}

enum CsOutputStatus { UNMODIFIED, MODIFIED, DELETED }
