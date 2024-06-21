// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaaImage _$CaaImageFromJson(Map<String, dynamic> json) => CaaImage()
  ..id = json['id']
  ..url = json['url']
  ..label = json['label']
  ..usageCounter = json['usage_counter'] as int?
  // ..grammaticalType = _$enumDecode(
  //     _$GrammaticalTypeEnumMap, json['grammatical_type'][0]['type'])
  ..isPersonal = json['is_personal'] as bool
  //..imageContext = _$enumDecode(_$ImageContextEnumMap, json['image_context'])
  ..insertDate = DateTime.parse(json['insert_date'] as String)
  //..isActive = json['is_active'] as bool
  ..stringCoding = json['string_coding'] as String
  ..synsetList = (json['synset_list'] as List<dynamic>?)
      ?.map((e) => Synset.fromJson(e as Map<String, dynamic>))
      .toList()
  ..audioTTSList = (json['audio_tts_list'] as List<dynamic>?)
      ?.map((e) => AudioTTS.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CaaImageToJson(CaaImage instance) => <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'url': instance.url,
      //'usage_counter': instance.usageCounter,
      // 'grammatical_type': _$GrammaticalTypeEnumMap[instance.grammaticalType],
      // 'is_personal': instance.isPersonal,
      //'image_context': _$ImageContextEnumMap[instance.imageContext],
      'insert_date': DateFormat('yyyy-MM-dd').format(instance.insertDate),
      //'is_active': instance.isActive,
      'string_coding': instance.stringCoding,
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

const _$GrammaticalTypeEnumMap = {
  GrammaticalType.VERB: 'VERB',
  GrammaticalType.NOUN: 'NOUN',
  GrammaticalType.ADJECTIVE: 'ADJECTIVE',
  GrammaticalType.ADVERB: 'ADVERB',
  GrammaticalType.NONE: 'NONE',
};

const _$ImageContextEnumMap = {
  ImageContext.BATHROOM: 'BATHROOM',
  ImageContext.LABORATORY: 'LABORATORY',
  ImageContext.LAUNCH: 'LAUNCH',
};
