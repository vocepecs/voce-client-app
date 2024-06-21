import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/gender.dart';
import 'package:voce/models/enums/social_story_view_type.dart';
import 'package:voce/models/enums/vocal_profile.dart';
import 'package:voce/models/image.dart';
import 'package:voce/models/social_story.dart';

part 'patient.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Patient {
  Patient();

  int? _id;
  late String _nickname;
  late DateTime? _dateOfBirth;
  late DateTime _enrollDate;
  late int _communicationLevel;
  late List<CaaTable> _tableList;
  late List<SocialStory> _socialStoryList;
  late List<CaaImage> _privateImageList;
  String? _notes;
  late VocaProfile _vocaProfile;
  late SocialStoryViewType _socialStoryViewType;
  bool? _isActive;
  Gender? _gender;
  late bool _fullTtsEnabled;

  int? get id => this._id;
  set id(value) => this._id = value;
  String get nickname => this._nickname;
  set nickname(value) => this._nickname = value;
  DateTime? get dateOfBirth => this._dateOfBirth;
  set dateOfBirth(value) => this._dateOfBirth = value;
  DateTime get enrollDate => this._enrollDate;
  set enrollDate(value) => this._enrollDate = value;
  int get communicationLevel => this._communicationLevel;
  set communicationLevel(value) => this._communicationLevel = value;
  List<CaaTable> get tableList => this._tableList;
  set tableList(value) => this._tableList = value;
  List<SocialStory> get socialStoryList => this._socialStoryList;
  set socialStoryList(value) => this._socialStoryList = value;
  List<CaaImage> get privateImageList => this._privateImageList;
  set privateImageList(value) => this._privateImageList = value;
  String? get notes => this._notes;
  set notes(value) => this._notes = value;
  Gender? get gender => this._gender;
  set gender(value) => this._gender = value;
  bool get fullTtsEnabled => this._fullTtsEnabled;
  set fullTtsEnabled(value) => this._fullTtsEnabled = value;

  VocaProfile get vocalProfile => this._vocaProfile;
  set vocalProfile(VocaProfile value) => this._vocaProfile = value;

  SocialStoryViewType get socialStoryViewType => this._socialStoryViewType;
  set socialStoryViewType(value) => this._socialStoryViewType = value;

  bool? get isActive => this._isActive;
  set isActive(value) => _isActive = value;

  factory Patient.createNewPatient() {
    Patient patient = Patient();
    patient.nickname = '';
    // patient.dateOfBirth = null;
    patient.notes = '';
    patient.communicationLevel = 0;
    patient.tableList = List<CaaTable>.empty();
    patient.socialStoryList = List<SocialStory>.empty();
    patient.privateImageList = List<CaaImage>.empty();
    patient.enrollDate = DateTime.now();
    patient.vocalProfile = VocaProfile.MALE;
    patient.socialStoryViewType = SocialStoryViewType.SINGLE;
    patient.fullTtsEnabled = false;
    return patient;
  }

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);

  void changeActiveTable(int newActiveTableId) {
    _tableList.forEach((element) {
      if (element.isActive && newActiveTableId != element.id) {
        element.isActive = false;
      } else if (element.isActive == false && newActiveTableId == element.id) {
        element.isActive = true;
      }
    });
  }
}
