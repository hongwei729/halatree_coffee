import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';
import '../utils/constants.dart';
import '../webservice/api.dart';
import '../webservice/dio_util.dart';

class ShopContact {
  final String name;
  final String phone;
  final String email;
  final String website;

  const ShopContact({
    required this.name,
    required this.phone,
    required this.email,
    required this.website,
  });
}

class MainController extends GetxController {
  final cache = GetStorage();
  late Api apiClient;

  static const List<ShopContact> shopContacts = [
    ShopContact(
      name: 'Waikiki',
      phone: 'tel:+1234567890',
      email: 'mailto:waikiki@halatree.com',
      website: 'https://halatree.com/waikiki',
    ),
    ShopContact(
      name: 'Kaaawa',
      phone: 'tel:+1234567891',
      email: 'mailto:kaaawa@halatree.com',
      website: 'https://halatree.com/kaaawa',
    ),
    ShopContact(
      name: 'Captain Cook',
      phone: 'tel:+1234567892',
      email: 'mailto:captaincook@halatree.com',
      website: 'https://halatree.com/captaincook',
    ),
  ];

  final selectedShopIndex = 0.obs;
  final newsHtml = ''.obs;
  final newsLoading = false.obs;

  ShopContact get selectedContact => shopContacts[selectedShopIndex.value];

  @override
  void onInit() {
    super.onInit();
    apiClient = Api(DioUtil(null).getDio(), baseUrl: DioUtil.mainUrl!);
    initData();
  }

  void initData() async {
    getNewsData();
  }

  void selectShop(int index) {
    selectedShopIndex.value = index;
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void callUs() => openUrl(selectedContact.phone);
  void emailUs() => openUrl(selectedContact.email);
  void openWebsite() => openUrl(selectedContact.website);

  void getNewsData() async {
    bool isNetwork = await Constants.checkNetwork();
    if (!isNetwork) {
      showToastMessage("You are working with offline mode");
      newsHtml.value = '<p>News will appear here when available.</p>';
      return;
    }
    newsLoading.value = true;
    try {
      apiClient = Api(DioUtil(null).getDio(), baseUrl: DioUtil.mainUrl!);
      final value = await apiClient.getnews();
      if (value.newsData?.news_content != null && value.newsData!.news_content!.isNotEmpty) {
        newsHtml.value = value.newsData!.news_content!;
      } else {
        newsHtml.value = '<p>News will appear here when available.</p>';
      }
    } catch (e) {
      newsHtml.value = '<p>News will appear here when available.</p>';
    } finally {
      newsLoading.value = false;
    }
  }
}
