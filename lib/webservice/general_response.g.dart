// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralResponse _$GeneralResponseFromJson(Map<String, dynamic> json) =>
    GeneralResponse()
      ..message = json['message'] as String?
      ..newsData = json['newsData'] == null
          ? null
          : NewsModel.fromJson(json['newsData'] as Map<String, dynamic>);

Map<String, dynamic> _$GeneralResponseToJson(GeneralResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'newsData': instance.newsData,
    };
