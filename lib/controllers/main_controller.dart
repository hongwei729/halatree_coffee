import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/constants.dart';
import '../webservice/api.dart';
import '../webservice/dio_util.dart';


class MainController extends GetxController {
  final cache = GetStorage();
  late Api apiClient;
  @override
  void onInit() {
    super.onInit();
    apiClient = Api(DioUtil(null).getDio(),baseUrl: DioUtil.mainUrl!);

    initData();
  }


  void initData() async{
    Future.delayed(const Duration(seconds: 2), () {
      //getNewsData();
    });
  }

  void getNewsData() async{
    bool isNetwork = await Constants.checkNetwork();
    if(!isNetwork){
      showToastMessage("You are working with offline mode");

    }else{
        apiClient = Api(DioUtil(null).getDio(),baseUrl: DioUtil.mainUrl!);

        await apiClient.getnews().then((value) {
          // hasUnreadNoti.value = value.unread_count!=null && value.unread_count!>0?true: false;
          // if(fromScreen=="loginbtn") dismissDialog();
          // if(value.message=="success"){
          //   if(Platform.isAndroid && value.versionModel != null){
          //     checkVersionData(value, fromScreen, email, password);
          //   }else{
          //     gotoNextPage(value, fromScreen,email, password);
          //   }
          //
          // }else{
          //   loginVisible.value = true;
          //   showToastMessage(value.message??"Unknown error");
          // }
        }).onError((err, stackTrace) {
          // if(fromScreen=="loginbtn") dismissDialog();
          // loginVisible.value = true;
          // if (err is DioException) {
          //   showToastMessage("DIO error");
          // }else{
          //   showToastMessage("unknownerror");
          // }
        }
        );
    }
  }
}