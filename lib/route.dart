import 'package:coffee/controllers/edit_profile_controller.dart';
import 'package:coffee/controllers/forgot_password_controller.dart';
import 'package:coffee/controllers/login_controller.dart';
import 'package:coffee/controllers/main_controller.dart';
import 'package:coffee/controllers/profile_controller.dart';
import 'package:coffee/controllers/signup_controller.dart';
import 'package:coffee/controllers/splash_controller.dart';
import 'package:coffee/views/forgot_password_screen.dart';
import 'package:coffee/views/login_screen.dart';
import 'package:coffee/views/main_screen.dart';
import 'package:coffee/views/edit_profile_screen.dart';
import 'package:coffee/views/profile_screen.dart';
import 'package:coffee/views/redeem_history_screen.dart';
import 'package:coffee/views/signup_screen.dart';
import 'package:coffee/views/splash_screen.dart';
import 'package:get/get.dart';


class RouteName {
  static const String splashView = "/splashView";
  static const String mainView = "/mainView";
  static const String loginView = "/loginView";
  static const String signupView = "/signupView";
  static const String forgotPasswordView = "/forgotPasswordView";
  static const String profileView = "/profileView";
  static const String profileEditView = "/profileEditView";
  static const String redeemHistoryView = "/redeemHistoryView";
}


abstract class Routes {
  static final routes = [
    GetPage(
        name: RouteName.splashView,
        page: () => const SplashScreen(),
        binding: BindingsBuilder(() {
          Get.put(SplashController());
        })),
    GetPage(
        name: RouteName.mainView,
        page: () => const MainScreen(),
        binding: BindingsBuilder(() {
          Get.put(MainController());
        })),
    GetPage(
        name: RouteName.profileView,
        page: () => const ProfileScreen(),
        binding: BindingsBuilder(() {
          Get.put(ProfileController());
        })),
    GetPage(
        name: RouteName.profileEditView,
        page: () => const EditProfileScreen(),
        binding: BindingsBuilder(() {
          Get.put(EditProfileController());
        })),
    GetPage(
        name: RouteName.redeemHistoryView,
        page: () => const RedeemHistoryScreen()),
    GetPage(
        name: RouteName.loginView,
        page: () => const LoginScreen(),
        binding: BindingsBuilder(() {
          Get.put(LoginController());
        })),
    GetPage(
        name: RouteName.signupView,
        page: () => const SignupScreen(),
        binding: BindingsBuilder(() {
          Get.put(SignupController());
        })),
    GetPage(
        name: RouteName.forgotPasswordView,
        page: () => const ForgotPasswordScreen(),
        binding: BindingsBuilder(() {
          Get.put(ForgotPasswordController());
        })),
  ];
}