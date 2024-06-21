part of 'synset.dart';

Synset _$SynsetFromJson(Map<String, dynamic> json) => Synset(
      json['id'],
      json['synset_name'],
      json['synset_name_short'],
    );

Map<String, dynamic> _$SynsetToJson(Synset instance) => <String, dynamic>{
      'id': instance.id,
      'synset_name': instance.synsetName,
      'synset_name_short': instance.synsetNameShort,
    };
