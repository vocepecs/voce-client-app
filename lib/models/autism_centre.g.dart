// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autism_centre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutismCentre _$AutismCentreFromJson(Map<String, dynamic> json) => AutismCentre()
  ..id = json['id'] as int?
  ..name = json['name'] as String
  ..address = json['address'] as String?
  ..secretCode = json['secret_code'] as String;

Map<String, dynamic> _$AutismCentreToJson(AutismCentre instance) =>
    <String, dynamic>{
      //'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'secret_code': instance.secretCode,
    };
