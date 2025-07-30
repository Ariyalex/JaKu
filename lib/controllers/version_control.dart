import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/theme/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionControl extends GetxController {
  Future<void> checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      // atur interval fetch agar tidak terlalu sering
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      //ambil data terbaru dari firebase
      await remoteConfig.fetchAndActivate();

      //dapatkan versi aplikasi yang sedang berjalan
      final packageInfo = await PackageInfo.fromPlatform();
      //gunakan buildnumber untuk perbandingan
      int curerntVersionCode = int.parse(packageInfo.buildNumber);

      //dapatkan versi terbaru dari remote config
      int latesVersionCode = remoteConfig.getInt('latest_version_code');
      String latesVersionName = remoteConfig.getString('latest_version_name');
      String downloadUrl = remoteConfig.getString('download_url');
      bool isUpdateMandatory = remoteConfig.getBool('is_update_mandatory');

      print("Current version code: $curerntVersionCode");
      print("latest version code from firebase: $latesVersionCode");

      //membandingkan version code
      if (latesVersionCode > curerntVersionCode) {
        showUpdateDialog(latesVersionName, downloadUrl, isUpdateMandatory);
      }
    } catch (e) {
      print("gagal mengecek update: $e");
    }
  }

  void showUpdateDialog(String versionName, String url, bool isMandatory) {
    Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppTheme.dark.dialogTheme.backgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        titlePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        title: "Update tersedia!",
        content: Text(
            "Jaku versi $versionName telah dirilis. Mohon perbarui aplikasi untuk mendapatkan fitur terbaru."),
        cancel: !isMandatory
            ? TextButton(onPressed: () => Get.back(), child: Text("Nanti"))
            : null,
        confirm: FilledButton(
          onPressed: () async {
            final Uri downloadUrl = Uri.parse(url);
            if (await canLaunchUrl(downloadUrl)) {
              await launchUrl(downloadUrl,
                  mode: LaunchMode.externalApplication);
            } else {
              Get.snackbar("Error", "Tidak dapat membuka link download",
                  backgroundColor: AppTheme.dark.colorScheme.error,
                  colorText: AppTheme.dark.colorScheme.onError);
            }
          },
          child: const Text("Update Sekarang"),
        ));
  }

  @override
  void onInit() {
    super.onInit();
    checkForUpdate();
  }
}
