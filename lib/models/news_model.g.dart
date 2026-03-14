// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => NewsModel()
  ..news_id = json['news_id'] as String?
  ..news_content = json['news_content'] as String?;

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
  'news_id': instance.news_id,
  'news_content': instance.news_content,
};
