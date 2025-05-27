import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class JadwalKuliahLocal {
  static const String matkulBoxName = "matkul_box";
  static const String hariKuliahBox = "hari_kuliah_box";

  //initialize hive
  static Future<void> init() async {
    await Hive.initFlutter();
  }
}
