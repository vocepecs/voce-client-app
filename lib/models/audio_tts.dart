import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/enums/gender.dart';

part 'audio_tts.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AudioTTS {
  AudioTTS(
    this._id,
    this._label,
    this._gender,
    this._model,
    this._framework,
    this._base64String,
  );

  final int _id;
  final String _label;
  final Gender _gender;
  final String? _model;
  final String? _framework;
  final String _base64String;

  int get id => _id;
  String get label => _label;
  Gender get gender => _gender;
  String? get model => _model;
  String? get framework => _framework;
  String get base64String => _base64String;

  factory AudioTTS.fromJson(Map<String, dynamic> json) =>
      _$AudioTTSFromJson(json);
  Map<String, dynamic> toJson() => _$AudioTTSToJson(this);
}
