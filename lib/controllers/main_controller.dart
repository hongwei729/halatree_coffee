import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';
import '../webservice/api.dart';
import '../webservice/dio_util.dart';

class ShopContact {
  final String name;
  final String phone;
  final String email;
  final String website;
  final double latitude;
  final double longitude;

  const ShopContact({
    required this.name,
    required this.phone,
    required this.email,
    required this.website,
    required this.latitude,
    required this.longitude,
  });
}

class MainController extends GetxController {
  final cache = GetStorage();
  late Api apiClient;

  /// Kaaawa location index in [shopContacts].
  static const int kaaawaShopIndex = 1;

  /// Shown when user selects Kaaawa: contact only during these hours.
  static const String kaaawaHoursMessage =
      'Hala Tree Cafe Kaaawa is open 7am to 4pm every day. '
      'You can only reach us during these hours.';

  static const List<ShopContact> shopContacts = [
    ShopContact(
      name: 'Hala Tree Cafe Waikiki',
      phone: 'tel:+1234567890',
      email: 'mailto:waikiki@halatree.com',
      website: 'https://halatree.com/waikiki',
      latitude: 21.278432,
      longitude: -157.824195,
    ),
    ShopContact(
      name: 'Hala Tree Cafe Kaaawa',
      phone: 'tel:+1234567891',
      email: 'mailto:kaaawa@halatree.com',
      website: 'https://halatree.com/kaaawa',
      latitude: 21.559102,
      longitude: -157.862947,
    ),
    ShopContact(
      name: 'Hala Tree Cafe Captain Cook',
      phone: 'tel:+18082385005',
      email: 'mailto:captaincook@halatree.com',
      website: 'https://halatree.com/captaincook',
      latitude: 19.482207,
      longitude: -155.898887,
    ),
  ];

  final selectedShopIndex = 0.obs;
  final newsHtml = ''.obs;
  final newsLoading = false.obs;
  /// True while fetching user location to select nearest shop.
  final locationLoading = false.obs;

  ShopContact get selectedContact => shopContacts[selectedShopIndex.value];

  @override
  void onInit() {
    super.onInit();
    apiClient = Api(DioUtil(null).getDio(), baseUrl: DioUtil.mainUrl!);
    initData();
  }

  void initData() async {
    getNewsData();
    ensureLocationAndSelectNearestShop();
  }

  /// Check/request location permission, get user position, and select nearest shop.
  /// If permission denied or location fails, defaults to first shop (index 0).
  Future<void> ensureLocationAndSelectNearestShop() async {
    final status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      if (status.isDenied) {
        final result = await Permission.locationWhenInUse.request();
        if (!result.isGranted) {
          selectShop(0);
          return;
        }
      } else if (status.isPermanentlyDenied) {
        // User chose "Don't ask again" – open app settings so they can enable location.
        await openAppSettings();
        selectShop(0);
        return;
      } else {
        selectShop(0);
        return;
      }
    }

    // Permission granted – check if location services (GPS) are on.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // Still continue: getLastKnownPosition or default may apply when user returns.
    }

    locationLoading.value = true;
    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (_) {
        position = null;
      }
      // Fallback: last known position (e.g. after emulator sets a mock location once)
      position ??= await Geolocator.getLastKnownPosition();
      // Fallback for emulator/no GPS: use first shop so app still works
      final lat = position?.latitude ?? shopContacts[0].latitude;
      final lon = position?.longitude ?? shopContacts[0].longitude;
      final index = _indexOfNearestShop(lat, lon);
      selectedShopIndex.value = index;
    } catch (_) {
      selectShop(0);
    } finally {
      locationLoading.value = false;
    }
  }

  int _indexOfNearestShop(double userLat, double userLon) {
    print(userLat);
    print(userLon);
    int nearest = 0;
    double minDist = double.infinity;
    for (int i = 0; i < shopContacts.length; i++) {
      final d = _haversineKm(
        userLat,
        userLon,
        shopContacts[i].latitude,
        shopContacts[i].longitude,
      );
      if (d < minDist) {
        minDist = d;
        nearest = i;
      }
    }
    return nearest;
  }

  static double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const p = math.pi / 180;
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a));
  }

  void selectShop(int index) {
    selectedShopIndex.value = index;
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      showToastMessage("Could not open link");
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

  void openWaikiki() {
    showToastMessage("Opening soon, under construction");
  }

  void openKaaawa() {
    openUrl("https://www.clover.com/online-ordering/hala-tree-cafe-1");
  }

  void openShopOnline() {
    openUrl("https://www.halatreecoffee.com");
  }

}
