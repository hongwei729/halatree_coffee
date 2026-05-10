import 'package:coffee/models/news_model.dart';
import 'package:coffee/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'general_response.g.dart';

int? nullableStatusFromJson(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

String? nullableStringFromDynamic(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

@JsonSerializable()
class GeneralResponse {
  String? message;
  /// Many PHP APIs return `1` / `0` or `"1"` / `"0"`.
  @JsonKey(fromJson: nullableStatusFromJson)
  int? status;
  //========= Login API======
  NewsModel? newsData;
  UserModel? user;
  String? verification_code;
  @JsonKey(name: 'new_amount', fromJson: nullableStringFromDynamic)
  String? new_amount;

  GeneralResponse();



  factory GeneralResponse.fromJson(Map<String, dynamic> json) => _$GeneralResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralResponseToJson(this);
}