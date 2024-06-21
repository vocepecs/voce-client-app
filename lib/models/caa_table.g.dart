// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caa_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaaTable _$CaaTableFromJson(Map<String, dynamic> json) =>
    CaaTable(json['user_id'] as int)
      ..id = json['id'] as int?
      ..name = json['name'] as String
      ..tableFormat = _$enumDecode(_$TableFormatEnumMap, json['table_format'])
      ..creationDate = DateTime.parse(json['creation_date'] as String)
      ..lastModifyDate = json['last_modify_date'] == null
          ? null
          : DateTime.parse(json['last_modify_date'] as String)
      ..sectorList = (json['sector_list'] as List<dynamic>)
          .map((e) => TableSector.fromJson(e as Map<String, dynamic>))
          .toList()
      ..isActive = json['is_active'] as bool
      ..description = json['description'] as String?
      ..isPrivate = json['is_private'] as bool
      ..autismCentreId = json['autism_centre_id'] as int?
      ..imageStringCoding = json['image_string_coding'];

Map<String, dynamic> _$CaaTableToJson(CaaTable instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'table_format': _$TableFormatEnumMap[instance.tableFormat],
      'creation_date': DateFormat('yyyy-MM-dd').format(instance.creationDate),
      'last_modify_date':
          DateFormat('yyyy-MM-dd').format(instance.creationDate),
      'sector_list': instance.sectorList.map((e) => e.toJson()).toList(),
      'is_active': instance.isActive,
      'description': instance.description,
      'is_private': instance.isPrivate,
      'user_id': instance.userId,
      'autism_centre_id': instance.autismCentreId,
      'image_string_coding': instance.imageStringCoding,
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

const _$TableFormatEnumMap = {
  TableFormat.SINGLE_SECTOR: 'SINGLE_SECTOR',
  TableFormat.TWO_SECTORS_VERTICAL: 'TWO_SECTORS_VERTICAL',
  TableFormat.TWO_SECTORS_HORIZONTAL: 'TWO_SECTORS_HORIZONTAL',
  TableFormat.THREE_SECTORS_RIGHT: 'THREE_SECTORS_RIGHT',
  TableFormat.THREE_SECTORS_LEFT: 'THREE_SECTORS_LEFT',
  TableFormat.FOUR_SECTORS: 'FOUR_SECTORS',
};
