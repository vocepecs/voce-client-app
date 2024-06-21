import 'package:json_annotation/json_annotation.dart';

part 'synset.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Synset {
  int _id;
  String _synsetName;
  String _synsetNameShort;

  Synset(
    this._id,
    this._synsetName,
    this._synsetNameShort,
  );

  int get id => _id;
  String get synsetName => _synsetName;
  String get synsetNameShort => _synsetNameShort;

  factory Synset.fromJson(Map<String, dynamic> json) => _$SynsetFromJson(json);
  Map<String, dynamic> toJson() => _$SynsetToJson(this);
}
