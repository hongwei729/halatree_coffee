import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
      phone: '',
      email: '',
      website: '',
      latitude: 21.278432,
      longitude: -157.824195,
    ),
    ShopContact(
      name: 'Hala Tree Cafe Kaaawa',
      phone: 'tel:+17815662669',
      email: 'mailto:info@halatreecafe.com',
      website: 'https://www.halatreecafe.com/',
      latitude: 21.559102,
      longitude: -157.862947,
    ),
    ShopContact(
      name: 'Hala Tree Captain Cook',
      phone: 'tel:+18082385005',
      email: 'mailto:sales@halatreecoffee.com',
      website: 'https://halatreecoffee.com/',
      latitude: 19.482207,
      longitude: -155.898887,
    ),
  ];

  final selectedShopIndex = 0.obs;
  /// URL to load in the news WebView; empty when offline or on error.
  final newsUrl = ''.obs;
  final newsLoading = false.obs;
  WebViewController? newsWebViewController;
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
    if(url.isEmpty){
      showToastMessage("Coming Soon");
      return;
    }
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Common on iOS Simulator: no Phone/Mail app for tel:/mailto:
        final isTelOrMail = uri.scheme == 'tel' || uri.scheme == 'mailto';
        showToastMessage(
          isTelOrMail
              ? "Phone and email links need a real device (not supported on simulator)."
              : "Could not open link",
        );
      }
    } catch (e) {
      showToastMessage("Could not open link");
    }
  }

  void callUs() => openUrl(selectedContact.phone);
  void emailUs() => openUrl(selectedContact.email);
  void openWebsite() => openUrl(selectedContact.website);

  void getNewsData() async {
    debugPrint('[News] getNewsData() started');
    bool isNetwork = await Constants.checkNetwork();
    if (!isNetwork) {
      debugPrint('[News] No network – showing unavailable');
      newsUrl.value = '';
      return;
    }
    debugPrint('[News] Network OK, loading URL...');
    newsLoading.value = true;
    try {
      final url = '${baseUrl}getnewscontent';
      newsUrl.value = url;
      debugPrint('[News] Loading: $url');
      newsWebViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) async {
              final requestedUrl = request.url;
              if (requestedUrl == url || requestedUrl.startsWith(baseUrl)) {
                return NavigationDecision.navigate;
              }
              await openUrl(requestedUrl);
              return NavigationDecision.prevent;
            },
            onPageStarted: (url) => debugPrint('[News] WebView onPageStarted: $url'),
            onPageFinished: (url) {
              debugPrint('[News] WebView onPageFinished: $url');
              newsLoading.value = false;
            },
            onWebResourceError: (error) {
              debugPrint('[News] WebView onWebResourceError: isForMainFrame=${error.isForMainFrame}, '
                  'errorCode=${error.errorCode}, description=${error.description}');
              // Android often fires ERR_CACHE_MISS (-1) for the main frame even when the page
              // goes on to load (onPageFinished still fires). Ignore it so content can display.
              if (error.isForMainFrame != true) return;
              if (error.errorCode == -1 &&
                  error.description.toLowerCase().contains('err_cache_miss')) {
                return;
              }
              _showNewsUnavailable();
            },
            onHttpError: (error) {
              final uri = error.response?.uri;
              debugPrint('[News] WebView onHttpError: statusCode=${error.response?.statusCode}, uri=$uri');
              // Only show fallback if this is the main document (uri matches our news URL).
              // When uri is null it may be a subresource 404 – don't clear the WebView.
              if (uri != null && uri.toString() == url) {
                debugPrint('[News] WebView onHttpError is main doc – showing unavailable');
                _showNewsUnavailable();
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    } catch (e, stack) {
      debugPrint('[News] getNewsData exception: $e');
      debugPrint('[News] stack: $stack');
      _showNewsUnavailable();
    } finally {
      debugPrint('[News] getNewsData() setup finished');
    }
  }

  void _showNewsUnavailable() {
    debugPrint('[News] _showNewsUnavailable() – clearing URL and controller');
    newsLoading.value = false;
    newsUrl.value = '';
    newsWebViewController = null;
  }

  /// Reload the news WebView if it is available.
  void reloadNews() {
    if (newsWebViewController != null && newsUrl.value.isNotEmpty) {
      newsWebViewController!.reload();
    } else {
      getNewsData();
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

  void openLoyaltyProgram() {
    openUrl("https://start.mylty.co/login?id=18240"); // TODO: replace with loyalty program URL
  }

}
