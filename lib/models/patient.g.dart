// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient()
  ..id = json['id'] as int?
  ..nickname = json['nickname'] as String
  // ..dateOfBirth = DateTime.parse(json['date_of_birth'] as String)
  ..enrollDate = DateTime.parse(json['enroll_date'] as String)
  ..communicationLevel = json['communication_level'] as int
  ..tableList = (json['table_list'] as List<dynamic>?)
      ?.map((e) => CaaTable.fromJson(e as Map<String, dynamic>))
      .toList()
  ..socialStoryList = (json['social_story_list'] as List<dynamic>?)
      ?.map((e) => SocialStory.fromJson(e as Map<String, dynamic>))
      .toList()
  ..privateImageList = (json['image_list'] as List<dynamic>?)
      ?.map((e) => CaaImage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..notes = json['notes'] as String?
  ..vocalProfile = _$enumDecode(
    _$VocalProfileEnumMap,
    json['vocal_profile'],
  )
  ..socialStoryViewType = _$enumDecode(
    _$SocialStoryViewEnumMap,
    json['social_story_view_type'],
  )
  ..isActive = json['is_active'] as bool?
  ..gender = json['gender'] != null
      ? _$enumDecode(
          _$GenderEnumMap,
          json['gender'],
        )
      : null
  ..fullTtsEnabled = json['full_tts_enabled'] as bool;

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      // 'date_of_birth': DateFormat('yyyy-MM-dd').format(instance.dateOfBirth),
      'enroll_date': DateFormat('yyyy-MM-dd').format(instance.enrollDate),
      'communication_level': instance.communicationLevel,
      'table_list': instance.tableList.map((e) => e.toJson()).toList(),
      'social_story_list':
          instance.socialStoryList.map((e) => e.toJson()).toList(),
      'image_list': instance.privateImageList.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
      'vocal_profile': _$VocalProfileEnumMap[instance.vocalProfile],
      'social_story_view_type':
          _$SocialStoryViewEnumMap[instance.socialStoryViewType],
      'is_active': instance.isActive,
      'gender': _$GenderEnumMap[instance.gender],
      'full_tts_enabled': instance.fullTtsEnabled,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$VocalProfileEnumMap = {
  VocaProfile.MALE: 'MALE',
  VocaProfile.FEMALE: 'FEMALE',
};

const _$SocialStoryViewEnumMap = {
  SocialStoryViewType.SINGLE: 'SINGLE',
  SocialStoryViewType.MULTIPLE: 'MULTIPLE',
};

const _$GenderEnumMap = {Gender.MALE: 'MALE', Gender.FEMALE: 'FEMALE'};
