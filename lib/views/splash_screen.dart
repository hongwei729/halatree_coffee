import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../controllers/splash_controller.dart';
import '../utils/color.dart';

class SplashScreen extends GetView<SplashController>{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        color: colorBackground,
        child: Center(child: Image.asset('assets/logo.png', width: 180, height: 180,)),
      ),
    );
  }
}