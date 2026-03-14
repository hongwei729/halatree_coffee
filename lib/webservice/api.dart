import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'general_response.dart';
part 'api.g.dart';

/*
*   This file will define all the endpoint to connect to API backend server
* */

@RestApi(baseUrl: "")

abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  @POST("getnews")
  Future<GeneralResponse> getnews(
      // @Part(name: "user_email") String email,
      // @Part(name: "user_password") String password,
      );

}
