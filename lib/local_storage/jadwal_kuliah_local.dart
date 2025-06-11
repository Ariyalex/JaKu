import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/models/jadwal.dart';

class JadwalKuliahLocal {
  static const String matkulBoxName = "matkul_box";

  //initialize hive
  static Future<void> initL() async {
    await Hive.initFlutter();

    //register adapter jika belum tersedia
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MatkulAdapter());
    }

    //open box
    await Hive.openBox<Matkul>(matkulBoxName);
  }

  //mendapatkan reference to the box
  static Box<Matkul> getMatkulBox() {
    return Hive.box<Matkul>(matkulBoxName);
  }

  // save single matkul
  static Future<void> saveMatkulL(Matkul matkul) async {
    final box = getMatkulBox();

    if (matkul.matkulId != null) {
      await box.put(matkul.matkulId, matkul);
    } else {
      throw Exception("matkul ID harus disediakan dari firebase");
    }
  }

//save multiple matkul
  static Future<void> saveAllMatkulL(List<Matkul> matkuls) async {
    final box = getMatkulBox();

    final Map<dynamic, Matkul> matkulMap = {};

    for (var matkul in matkuls) {
      if (matkul.matkulId == null) {
        throw Exception("matkul ID harus disediakan dari firebase");
      }
      matkulMap[matkul.matkulId] = matkul;
    }
    await box.putAll(matkulMap);
  }

  //get all saved matkuls
  static List<Matkul> getAllMatkulsL() {
    final box = getMatkulBox();
    return box.values.toList();
  }

  //delete a matkul by id
  static Future<void> deleteMatkulL(String id) async {
    final box = getMatkulBox();
    await box.delete(id);
  }

//delete all matkul
  static Future<void> deleteAllMatkulL() async {
    final box = getMatkulBox();
    await box.clear();
  }
}
