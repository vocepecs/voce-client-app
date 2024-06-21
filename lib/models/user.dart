import 'package:json_annotation/json_annotation.dart';
import 'package:voce/models/autism_centre.dart';
import 'package:voce/models/patient.dart';
part 'user.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class User {
  User();

  factory User.createNew(
    String userName,
    AutismCentre? autismCentre,
  ) {
    final user = User();
    user._username = userName;
    user._autismCentre = autismCentre;
    return user;
  }

  int? _id;
  late String _username;
  late String _email;
  late AutismCentre? _autismCentre;
  late List<Patient>? _patientList;
  bool _emailConfirmed = false;

  int? get id => this._id;
  set id(value) => this._id = value;
  String get name => this._username;
  set name(value) => this._username = value;
  String get email => this._email;
  set email(value) => this._email = value;
  AutismCentre? get autismCentre => this._autismCentre;
  set autismCentre(value) => this._autismCentre = value;
  List<Patient>? get patientList => this._patientList;
  set patientList(value) => this._patientList = value;

  bool get emailConfirmed => this._emailConfirmed;
  set emailConfirmed(value) => this._emailConfirmed = value;

  void addPatient(Patient patient) {
    this._patientList!.add(patient);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
