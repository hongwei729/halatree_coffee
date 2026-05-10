import 'package:json_annotation/json_annotation.dart';

part 'transaction_history_model.g.dart';

String? transactionStringFromJson(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

@JsonSerializable()
class TransactionHistoryModel {
  @JsonKey(name: 'id', fromJson: transactionStringFromJson)
  String? id;
  @JsonKey(name: 'customer_id', fromJson: transactionStringFromJson)
  String? customer_id;
  @JsonKey(name: 'source', fromJson: transactionStringFromJson)
  String? source;
  @JsonKey(name: 'type', fromJson: transactionStringFromJson)
  String? type;
  @JsonKey(name: 'order_id', fromJson: transactionStringFromJson)
  String? order_id;
  @JsonKey(name: 'amount', fromJson: transactionStringFromJson)
  String? amount;
  @JsonKey(name: 'points', fromJson: transactionStringFromJson)
  String? points;
  @JsonKey(name: 'notes', fromJson: transactionStringFromJson)
  String? notes;
  @JsonKey(name: 'created_at', fromJson: transactionStringFromJson)
  String? created_at;

  TransactionHistoryModel();

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionHistoryModelToJson(this);
}
