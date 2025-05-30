import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/firebase_options.dart';
import 'package:jaku/local_storage/jadwal_kuliah_local.dart';
import 'package:jaku/provider/auth.dart';
import 'package:jaku/provider/internet_check.dart';
import 'package:jaku/provider/pdf_back.dart';
import 'package:jaku/routes/page_route.dart';
import 'package:jaku/screens/home_screen.dart';
import 'package:jaku/screens/auth_screen/sign_in_screen.dart';

import '../provider/hari_kuliah.dart';
import '../provider/jadwal_kuliah.dart';
// import './screens/auth_page.dart';
import './theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //inisialisasi firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //inisialisasi hive
  await JadwalKuliahLocal.initL();

  // Inisialisasi controller tanpa menyimpan ke variabel lokal
  Get.put(AuthController(), permanent: true);
  Get.put(JadwalkuliahController(), permanent: true);
  Get.put(DayKuliahController(), permanent: true);
  Get.put(PdfBack(), permanent: true);
  Get.put(InternetCheck());

  // Pastikan data login dimuat sebelum menampilkan UI
  await Get.find<AuthController>().initializeAuth();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: Obx(
        () {
          final authController = Get.find<AuthController>();
          final internetStatus = Get.find<InternetCheck>().isOnline;

          if (internetStatus.value == true) {
            print("ternyata onlen");
            return authController.isLoggedIn
                ? const HomeScreen()
                : const SignIn();
          } else {
            print("offlen ini kontol");
            return authController.isLoggedIn
                ? const HomeScreen()
                : const SignIn();
          }
        },
      ),
      getPages: AppPage.pages,
    );
  }
}
