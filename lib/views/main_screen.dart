import 'package:coffee/controllers/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MainScreen extends GetView<MainController>{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child: Center(child: Image.asset('assets/logo.png', width: 180, height: 180,)),
      ),
    );
  }
}