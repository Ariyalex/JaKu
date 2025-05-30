import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetCheck extends GetxController {
  RxBool isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    isConnectedToInternet();
  }

  Future<void> isConnectedToInternet() async {
    //cek apakah terhubung ke jaringan
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      isOnline.value = true;
    } else {
      isOnline.value = false;
    }
  }
}
