// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caa_audio_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaaAudioRecord _$CaaAudioRecordFromJson(Map<String, dynamic> json) =>
    CaaAudioRecord(
      json['url'],
      json['id'],
      json['label'],
    )
      ..name = json['name'] as String
      ..creationDate = DateTime.parse(json['creation_date'] as String);

Map<String, dynamic> _$CaaAudioRecordToJson(CaaAudioRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'url': instance.url,
      'name': instance.name,
      'creation_date': instance.creationDate.toIso8601String(),
    };
