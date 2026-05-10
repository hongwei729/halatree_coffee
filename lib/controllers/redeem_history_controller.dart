import 'package:coffee/models/transaction_history_model.dart';
import 'package:coffee/utils/constants.dart';
import 'package:coffee/webservice/api.dart';
import 'package:coffee/webservice/dio_util.dart';
import 'package:get/get.dart';

class RedeemHistoryController extends GetxController {
  late final Api api;

  final loading = false.obs;
  final transactions = <TransactionHistoryModel>[].obs;

  /// Pending filter for API `redeem_type`: '' | 'earn' | 'redeem'. Applied when [fetchHistory] runs.
  final redeemTypeParam = ''.obs;

  /// Pending filter for API `source`: '' | 'bigcommerce' | 'clover'. Applied when [fetchHistory] runs.
  final sourceParam = ''.obs;

  @override
  void onInit() {
    super.onInit();
    api = Api(DioUtil(null).getDio(), baseUrl: DioUtil.mainUrl!);
    fetchHistory();
  }

  /// Calls `gettransactionhistory` with [Constants.userModel] id and current [redeemTypeParam] / [sourceParam].
  Future<void> fetchHistory() async {
    final id = Constants.userModel?.id;
    if (id == null || id.isEmpty) {
      showToastMessage('Sign in to see your history');
      transactions.clear();
      return;
    }

    final online = await Constants.checkNetwork();
    if (!online) {
      showToastMessage('No internet connection');
      return;
    }

    loading.value = true;
    try {
      final res = await api.gettransactionhistory(
        id,
        redeemTypeParam.value,
        sourceParam.value,
      );
      if (res.message != 'success') {
        showToastMessage(res.message ?? 'Could not load history');
        transactions.clear();
        return;
      }
      transactions.assignAll(res.transactions ?? []);
    } catch (_) {
      showToastMessage('Could not load history. Please try again.');
      transactions.clear();
    } finally {
      loading.value = false;
    }
  }
}
