import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/audio_tts.dart';
import 'package:voce/models/caa_multimedia_content.dart';
import 'package:voce/models/enums/grammatical_type.dart';
import 'package:voce/models/enums/image_context.dart';
import 'package:voce/models/synset.dart';

part 'image.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CaaImage extends CaaMultimediaContent {
  CaaImage() : super();

  late int? _usageCounter;
  late GrammaticalType _grammaticalType;
  late bool _isPersonal;
  late ImageContext _imageContext;
  late DateTime _insertDate;
  late bool _isActive;
  late String _stringCoding;
  late List<Synset> _synsetList;
  late List<AudioTTS> _audioTTSList;

  int? get id => super.id;
  set id(value) => super.id = value;
  String get label => super.label;
  set label(value) => super.label = value;
  String get url => super.url;
  set url(value) => super.url = value;
  int? get usageCounter => this._usageCounter;
  set usageCounter(value) => this._usageCounter = value;
  GrammaticalType get grammaticalType => this._grammaticalType;
  set grammaticalType(value) => this._grammaticalType = value;
  bool get isPersonal => this._isPersonal;
  set isPersonal(value) => this._isPersonal = value;
  ImageContext get imageContext => this._imageContext;
  set imageContext(value) => this._imageContext = value;
  DateTime get insertDate => this._insertDate;
  set insertDate(value) => this._insertDate = value;
  bool get isActive => this._isActive;
  set isActive(value) => this._isActive = value;
  String get stringCoding => this._stringCoding;
  set stringCoding(value) => this._stringCoding = value;
  List<Synset> get synsetList => _synsetList;
  set synsetList(value) => _synsetList = value;
  List<AudioTTS> get audioTTSList => _audioTTSList;
  set audioTTSList(value) => _audioTTSList = value;

  factory CaaImage.fromJson(Map<String, dynamic> json) =>
      _$CaaImageFromJson(json);
  Map<String, dynamic> toJson() => _$CaaImageToJson(this);
}
