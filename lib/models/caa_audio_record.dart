import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/caa_multimedia_content.dart';

part 'caa_audio_record.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CaaAudioRecord extends CaaMultimediaContent {
  CaaAudioRecord(url, id, label) : super();

  // late int _id;
  // late String _url;
  late String _name;
  late DateTime _creationDate;

  int? get id => super.id;
  set id(value) => super.id = value;
  String get label => super.label;
  set label(value) => super.label = value;
  String get url => super.url;
  set url(value) => super.url = value;
  String get name => this._name;
  set name(value) => this._name = value;
  DateTime get creationDate => this._creationDate;
  set creationDate(value) => this._creationDate = value;

  factory CaaAudioRecord.fromJson(Map<String, dynamic> json) =>
      _$CaaAudioRecordFromJson(json);
  Map<String, dynamic> toJson() => _$CaaAudioRecordToJson(this);
}
