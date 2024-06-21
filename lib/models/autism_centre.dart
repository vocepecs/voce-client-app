import 'package:json_annotation/json_annotation.dart';

part 'autism_centre.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AutismCentre {
  AutismCentre();

  factory AutismCentre.createNew(String name, String address) {
    final autismCentre = AutismCentre();
    autismCentre.name = name;
    autismCentre.address = address;
    return autismCentre;
  }

  int? _id;
  late String _name;
  String? _address;
  String? _secretCode;

  int? get id => this._id;
  set id(value) => this._id = value;
  String get name => this._name;
  set name(value) => this._name = value;
  String? get address => this._address;
  set address(value) => this._address = address;
  String? get secretCode => this._secretCode;
  set secretCode(value) => this._secretCode = value;

  factory AutismCentre.fromJson(Map<String, dynamic> json) =>
      _$AutismCentreFromJson(json);
  Map<String, dynamic> toJson() => _$AutismCentreToJson(this);
}
