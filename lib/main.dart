import 'package:coffee/controllers/splash_controller.dart';
import 'package:coffee/route.dart';
import 'package:coffee/utils/color.dart';
import 'package:coffee/utils/constants.dart';
import 'package:coffee/views/splash_screen.dart';
import 'package:coffee/webservice/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
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
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: colorPrimary,
          onPrimary: colorOnPrimary,
          surface: colorSurface,
          onSurface: colorOnSurface,
          background: colorBackground,
          onBackground: colorOnBackground,
          outline: colorOutline,
        ),
        scaffoldBackgroundColor: colorBackground,
        textTheme: GoogleFonts.robotoTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colorBackground,
          foregroundColor: colorOnBackground,
          elevation: 0,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorOnBackground,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimaryDark,
            foregroundColor: colorOnPrimary,
            textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
            elevation: 1,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: colorOnBackground,
            side: const BorderSide(color: colorPrimaryDark),
            textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w500),
          ),
        ),
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
