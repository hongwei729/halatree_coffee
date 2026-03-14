import 'package:coffee/controllers/splash_controller.dart';
import 'package:coffee/route.dart';
import 'package:coffee/utils/constants.dart';
import 'package:coffee/views/splash_screen.dart';
import 'package:coffee/webservice/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
void main() async {
  await GetStorage.init();
  DioUtil(baseUrl);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State {
  final cache = GetStorage();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme: GoogleFonts.latoTextTheme()//.nunitoTextTheme(),//.robotoTextTheme(),
      ),
      home: const SplashScreen(),
      initialRoute: '/',
      initialBinding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
      getPages: Routes.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}
