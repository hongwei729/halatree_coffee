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

  @FormUrlEncoded()
  @POST("halatreeusersignup")
  Future<GeneralResponse> halatreeusersignup(
    @Field("email") String email,
    @Field("first_name") String firstName,
    @Field("last_name") String lastName,
    @Field("password") String password,
  );

  @FormUrlEncoded()
  @POST("halatreeuserlogin")
  Future<GeneralResponse> halatreeuserlogin(
    @Field("email") String email,
    @Field("password") String password,
  );

  @FormUrlEncoded()
  @POST("requesthalatreeforgotpassword")
  Future<GeneralResponse> requesthalatreeforgotpassword(
    @Field("email") String email,
  );

  @FormUrlEncoded()
  @POST("changepassword")
  Future<GeneralResponse> changepassword(
    @Field("email") String email,
    @Field("otp") String otp,
    @Field("password") String newPassword,
  );

}
