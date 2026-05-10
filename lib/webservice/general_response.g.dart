// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralResponse _$GeneralResponseFromJson(Map<String, dynamic> json) =>
    GeneralResponse()
      ..message = json['message'] as String?
      ..status = nullableStatusFromJson(json['status'])
      ..newsData = json['newsData'] == null
          ? null
          : NewsModel.fromJson(json['newsData'] as Map<String, dynamic>)
      ..user = json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>)
      ..verification_code = json['verification_code'] as String?
      ..new_amount = nullableStringFromDynamic(json['new_amount'])
      ..transactions = (json['transactions'] as List<dynamic>?)
          ?.map(
            (e) => TransactionHistoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

Map<String, dynamic> _$GeneralResponseToJson(GeneralResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'newsData': instance.newsData,
      'user': instance.user,
      'verification_code': instance.verification_code,
      'new_amount': instance.new_amount,
      'transactions': instance.transactions,
    };
