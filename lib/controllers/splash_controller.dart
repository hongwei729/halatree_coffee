import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../route.dart';


class SplashController extends GetxController {
  final cache = GetStorage();
  @override
  void onInit() {
    super.onInit();
    initData();
  }

  gotoNextView() {
    Get.offNamed(RouteName.mainView);
  }

  void initData() async{
    Future.delayed(const Duration(seconds: 3), () {
     // gotoNextView();
    });
  }
}