import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../route.dart';
import '../utils/auth_storage.dart';
import '../utils/constants.dart';
import '../webservice/api.dart';
import '../webservice/dio_util.dart';

class LoginController extends GetxController {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final loading = false.obs;
  final cache = GetStorage();
  late final Api api;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    api = Api(DioUtil(null).getDio(), baseUrl: DioUtil.mainUrl!);
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void persistCredentials(String email, String password) {
    cache.write(AuthStorage.emailKey, email);
    cache.write(AuthStorage.passwordKey, password);
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;

    final online = await Constants.checkNetwork();
    if (!online) {
      showToastMessage('No internet connection');
      return;
    }

    loading.value = true;
    try {
      final res = await api.halatreeuserlogin(email, password);
      if (res.message!="success") {
        showToastMessage(res.message ?? 'Login failed');
        return;
      }
      Constants.userModel = res.user;
      persistCredentials(email, password);
      showToastMessage(res.message ?? 'Welcome');
      await Get.offAllNamed(RouteName.mainView);
    } catch (_) {
      showToastMessage('Login failed. Please try again.');
    } finally {
      loading.value = false;
    }
  }

  void openSignup() => Get.toNamed(RouteName.signupView);

  void openForgotPassword() => Get.toNamed(RouteName.forgotPasswordView);
}
