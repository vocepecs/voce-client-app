part of 'social_story.dart';

SocialStory _$SocialStoryFromJson(Map<String, dynamic> json) => SocialStory(
    json['user_id'] as int,
    json['patient_id'] as int?,
    json['title'] as String,
    json['description'] == null ? null : json['description'] as String,
    json['image_string_coding'] == null
        ? null
        : json['image_string_coding'] as String,
    DateTime.parse(json['creation_date'] as String),
    json['is_private'] as bool,
    json['autism_centre_id'] as int?,
    (json['session_list'] as List<dynamic>)
        .map((e) => ComunicativeSession.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['is_active'] as bool)
  ..id = json['id'] as int?;

Map<String, dynamic> _$SocialStoryToJson(SocialStory instance) =>
    <String, dynamic>{
      'title': instance.title,
      'patient_id': instance.patientId,
      'description': instance.description,
      'image_string_coding': instance.imageStringCoding,
      'creation_date': DateFormat('yyyy-MM-dd').format(instance.creationDate),
      'is_user_private': instance.isPrivate,
      'is_centre_private': instance.isCentrePrivate,
      'is_active': instance.isActive,
      'session_list':
          instance.comunicativeSessionList.map((e) => e.toJson()).toList(),
    };

Map<String, dynamic> _$SocialStoryToJsonCustom(SocialStory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'user_id': instance.userId,
      'description': instance.description,
      'image_string_coding': instance.imageStringCoding,
      'creation_date': DateFormat('yyyy-MM-dd').format(instance.creationDate),
      'is_private': instance.isPrivate,
      'is_active': instance.isActive,
      // 'autism_centre_id': instance.autismCentreId, TODO inserire id centro
      'cs_list': instance.comunicativeSessionList
          .map((e) => e.getCsOutputJson())
          .toList()
    };
