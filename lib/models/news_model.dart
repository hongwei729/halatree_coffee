import 'package:json_annotation/json_annotation.dart';
part 'news_model.g.dart';

@JsonSerializable()
class NewsModel {
  @JsonKey(name: 'news_id') String? news_id;
  @JsonKey(name: 'news_content') String? news_content;

  NewsModel();

  factory NewsModel.fromJson(Map<String, dynamic> json) => _$NewsModelFromJson(json);
  Map<String, dynamic> toJson() => _$NewsModelToJson(this);
}