import 'package:coffee/controllers/main_controller.dart';
import 'package:coffee/controllers/splash_controller.dart';
import 'package:coffee/views/main_screen.dart';
import 'package:coffee/views/splash_screen.dart';
import 'package:get/get.dart';


class RouteName {
  static const String splashView = "/splashView";
  static const String mainView = "/mainView";}


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
        }))

  ];
}