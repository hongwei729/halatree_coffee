import 'package:coffee/models/news_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'general_response.g.dart';

@JsonSerializable()
class GeneralResponse {
  String? message;
  //========= Login API======
  NewsModel? newsData;

  GeneralResponse();
  factory GeneralResponse.fromJson(Map<String, dynamic> json) => _$GeneralResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralResponseToJson(this);
}