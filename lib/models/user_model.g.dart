// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel()
  ..id = json['id'] as String?
  ..email = json['email'] as String?
  ..first_name = json['first_name'] as String?
  ..last_name = json['last_name'] as String?
  ..total_points = json['total_points'] as String?
  ..password = json['password'] as String?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'first_name': instance.first_name,
  'last_name': instance.last_name,
  'total_points': instance.total_points,
  'password': instance.password,
};
