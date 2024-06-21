part of "audio_tts.dart";

AudioTTS _$AudioTTSFromJson(Map<String, dynamic> json) => AudioTTS(
      json['id'] as int,
      json['label'] as String,
      _$enumDecode(_$GenderEnumMap, json['gender']),
      json['model'] as String?,
      json['framework'] as String?,
      json['base64_string'] as String,
    );

Map<String, dynamic> _$AudioTTSToJson(AudioTTS instance) => <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'gender': _$GenderEnumMap[instance.gender],
      'model': instance.model,
      'framework': instance.framework,
      'base64String': instance.base64String,
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

const _$GenderEnumMap = {Gender.MALE: 'MALE', Gender.FEMALE: 'FEMALE'};
