// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionHistoryModel _$TransactionHistoryModelFromJson(
  Map<String, dynamic> json,
) => TransactionHistoryModel()
  ..id = transactionStringFromJson(json['id'])
  ..customer_id = transactionStringFromJson(json['customer_id'])
  ..source = transactionStringFromJson(json['source'])
  ..type = transactionStringFromJson(json['type'])
  ..order_id = transactionStringFromJson(json['order_id'])
  ..amount = transactionStringFromJson(json['amount'])
  ..points = transactionStringFromJson(json['points'])
  ..notes = transactionStringFromJson(json['notes'])
  ..created_at = transactionStringFromJson(json['created_at']);

Map<String, dynamic> _$TransactionHistoryModelToJson(
  TransactionHistoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'customer_id': instance.customer_id,
  'source': instance.source,
  'type': instance.type,
  'order_id': instance.order_id,
  'amount': instance.amount,
  'points': instance.points,
  'notes': instance.notes,
  'created_at': instance.created_at,
};
