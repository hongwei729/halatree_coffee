import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../route.dart';
import '../utils/auth_storage.dart';
import '../utils/constants.dart';
import '../webservice/api.dart';
import '../webservice/dio_util.dart';

class SplashController extends GetxController {
  final cache = GetStorage();
  late final Api api;

  @override
  void onInit() {
    super.onInit();
    api = Api(DioUtil(null).getDio(), baseUrl: DioUtil.mainUrl!);
  }

  /// Called when splash animations finish: tries cached login, otherwise opens sign-in.
  Future<void> onSplashAnimationComplete() async {
    final email = cache.read(AuthStorage.emailKey)?.toString();
    final password = cache.read(AuthStorage.passwordKey)?.toString();

    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      final online = await Constants.checkNetwork();
      if (online) {
        try {
          final res = await api.halatreeuserlogin(email, password);
          if (res.message=="success") {
            await Get.offAllNamed(RouteName.mainView);
            return;
          }else{
            showToastMessage(res.message??"");
            await Get.offAllNamed(RouteName.loginView);
            return;
          }
        } catch (_) {}
      }
    }

    await Get.offAllNamed(RouteName.loginView);
  }
}
