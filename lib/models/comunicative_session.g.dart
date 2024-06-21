part of 'comunicative_session.dart';

ComunicativeSession _$ComunicativeSessionFromJson(Map<String, dynamic> json) =>
    ComunicativeSession(
        json['cs_id'] as int,
        json['title'] as String,
        (json['image_list'] as List<dynamic>)
            .map((e) => CaaImage.fromJson(e as Map<String, dynamic>))
            .toList());

Map<String, dynamic> _$ComunicativeSessionToJson(
        ComunicativeSession instance) =>
    <String, dynamic>{
      'cs_id': instance.id,
      'title': instance.title,
      'image_list': instance.imageList.map((e) => e.toJson()).toList(),
    };
