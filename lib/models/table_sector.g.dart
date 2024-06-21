// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_sector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableSector _$TableSectorFromJson(Map<String, dynamic> json) => TableSector()
  ..id = json['id'] as int
  ..tableSectorNumber =
      _$enumDecode(_$TableSectorNumberEnumMap, json['table_sector_number'])
  ..sectorColor = int.parse(json['sector_color'] as String)
  ..imageList = (json['image_list'] as List<dynamic>)
      .map((e) => CaaImage.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TableSectorToJson(TableSector instance) =>
    <String, dynamic>{
      'id': instance.id,
      'table_sector_number':
          _$TableSectorNumberEnumMap[instance.tableSectorNumber],
      'sector_color': instance.sectorColor,
      'image_list': instance.imageList.map((e) => e.toJson()).toList(),
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

const _$TableSectorNumberEnumMap = {
  TableSectorNumber.ONE: 'ONE',
  TableSectorNumber.TWO: 'TWO',
  TableSectorNumber.THREE: 'THREE',
  TableSectorNumber.FOUR: 'FOUR',
};
