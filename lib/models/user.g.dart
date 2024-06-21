// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['id'] as int?
  ..name = json['name'] as String
  ..email = json['email'] as String
  ..emailConfirmed = json['email_verified'] as bool
  ..autismCentre = json['autism_centre'] == null
      ? null
      : AutismCentre.fromJson(json['autism_centre'] as Map<String, dynamic>)
  ..patientList = (json['patient_list'] as List<dynamic>?)
      ?.map((e) => Patient.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'autism_centre': instance.autismCentre?.toJson(),
      'patient_list': instance.patientList?.map((e) => e.toJson()).toList(),
      'email_verified': instance.emailConfirmed,
    };
