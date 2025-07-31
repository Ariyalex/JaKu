import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/firebase_options.dart';
import 'package:jaku/services/jadwal_kuliah_local.dart';
import 'package:jaku/controllers/pdf_back.dart';
import 'package:jaku/controllers/version_control.dart';
import 'package:jaku/routes/page_route.dart';
import 'package:jaku/screens/home_screen.dart';

import 'controllers/hari_kuliah_c.dart';
import 'controllers/jadwal_kuliah_c.dart';
import './theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //inisialisasi firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //inisialisasi hive
  await JadwalKuliahLocal.initL();

  // Inisialisasi controller tanpa menyimpan ke variabel lokal
  Get.put(JadwalkuliahC(), permanent: true);
  Get.put(HariKuliahC(), permanent: true);
  Get.put(PdfBack(), permanent: true);
  Get.put(VersionControl());

  // Pastikan data login dimuat sebelum menampilkan UI

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      getPages: AppPage.pages,
    );
  }
}
