import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetCheck extends GetxController {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  RxBool isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    //cek koneksi awal
    _checkConnectivity();

    subscription = Connectivity().onConnectivityChanged.listen((result) async {
      checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      isOnline.value = connectivityResults.contains(ConnectivityResult.wifi) ||
          connectivityResults.contains(ConnectivityResult.mobile) ||
          connectivityResults.contains(ConnectivityResult.ethernet);
    } catch (e) {
      print("error checking connection: $e");
    }
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }

  //cek konektifitas manual
  Future<void> checkConnectivity() async {
    //cek apakah terhubung ke jaringan
    await _checkConnectivity();
  }
}
