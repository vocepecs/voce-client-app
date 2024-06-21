import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/comunicative_session.dart';
import 'package:voce/models/image.dart';

part 'social_story.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class SocialStory {
  SocialStory(
    this._userId,
    this._patientId,
    this._title,
    this._description,
    this._imageStringConding,
    this._creationDate,
    this._isPrivate,
    this._autismCentreId,
    this._comunicativeSessionList,
    this._isActive,
  );

  int? _id;
  int _userId;
  int? _patientId;
  String _title;
  String? _description;
  DateTime _creationDate;
  List<ComunicativeSession> _comunicativeSessionList;
  bool _isPrivate;
  int? _autismCentreId;
  String? _imageStringConding;
  bool _isActive;

  int? get id => _id;
  int get userId => _userId;
  int? get patientId => _patientId;
  String get title => _title;
  DateTime get creationDate => _creationDate;
  List<ComunicativeSession> get comunicativeSessionList =>
      _comunicativeSessionList;
  bool get isPrivate => _isPrivate;
  bool get isCentrePrivate => _autismCentreId != null;
  int? get autismCentreId => _autismCentreId;
  String? get imageStringCoding => _imageStringConding;
  String? get description => _description;
  bool get isActive => _isActive;

  set id(value) => _id = value;
  set userId(value) => _userId = value;
  set patientId(value) => _patientId = value;
  set title(value) => _title = value;
  set creationDate(value) => _creationDate = value;
  set isPrivate(value) => _isPrivate = value;
  set isCentrePrivate(value) => _autismCentreId = value;
  set imageStringCoding(value) => _imageStringConding = value;
  set description(value) => _description = value;
  set isActive(value) => _isActive = value;

  factory SocialStory.fromJson(Map<String, dynamic> json) =>
      _$SocialStoryFromJson(json);
  Map<String, dynamic> toJson() => _$SocialStoryToJson(this);
  Map<String, dynamic> toJsonCustom() => _$SocialStoryToJsonCustom(this);

  factory SocialStory.createEmptySocialStory(int userId,
          {int? patientId, int? autismCentreId}) =>
      SocialStory(
        userId,
        patientId,
        '',
        '',
        null,
        DateTime.now(),
        patientId != null,
        autismCentreId,
        List<ComunicativeSession>.empty(growable: true),
        false,
      );

  int get getSessionListSize => _comunicativeSessionList.length;
  int get getNumberOfPictograms => _comunicativeSessionList.fold<int>(
      0, (previousValue, element) => previousValue + element.imageList.length);

  void inserNewComunicativeSession(
    int? editIndex,
    int csId,
    String title,
    List<CaaImage> imageList,
  ) {
    var cs = ComunicativeSession(csId, title, imageList);
    if (editIndex != null) {
      comunicativeSessionList.removeAt(editIndex);
      _comunicativeSessionList.insert(editIndex, cs);
    } else {
      _comunicativeSessionList.add(cs);
    }
  }

  void addPictogramsToComunicativeSession(
    int editIndex,
    List<CaaImage> imageList,
  ) {
    _comunicativeSessionList[editIndex].addPictogramsToList(imageList);
  }

  void changeComunicativeSessionPosition(int oldIndex, int newIndex) {
    ComunicativeSession cs = comunicativeSessionList[oldIndex];
    comunicativeSessionList.removeAt(oldIndex);
    comunicativeSessionList.insert(
        oldIndex > newIndex ? newIndex : newIndex - 1, cs);
  }

  Map<String, dynamic> getSessionTitles() {
    Map<String, dynamic> sessionTitles = Map();
    _comunicativeSessionList.forEach((element) {
      sessionTitles.putIfAbsent(element.id.toString(), () => element.title);
    });
    return sessionTitles;
  }

  void deleteComunicativeSessionImage(int comunicativeSessionId, int imageId) {
    comunicativeSessionList
        .firstWhere((element) => element.id == comunicativeSessionId)
        .imageList
        .removeWhere((element) => element.id == imageId);
    comunicativeSessionList
        .firstWhere((element) => element.id == comunicativeSessionId)
        .deleteImage(imageId);
  }

  List<CaaImage> getAllImages() {
    List<CaaImage> imageList = List.empty(growable: true);
    _comunicativeSessionList.forEach((element) {
      imageList.addAll(element.imageList);
    });
    return imageList;
  }
}
