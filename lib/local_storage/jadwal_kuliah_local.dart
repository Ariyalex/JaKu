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

  //get spesifik matkul by id
  static Matkul? getMatkulByIdL(String id) {
    final box = getMatkulBox();
    return box.get(id);
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

  //Get matkuls by day
  static List<Matkul> getMatkulsByDayL(String day) {
    final box = getMatkulBox();
    return box.values.where((matkul) => matkul.day == day).toList();
  }

  //check if a matkul exist by id
  static bool matlulExistsL(String id) {
    final box = getMatkulBox();
    return box.containsKey(id);
  }

  //synchronize local data with firebase data
  static Future<void> syncWithFirebaseL(List<Matkul> firebaseMatkuls) async {
    final box = getMatkulBox();

    //create a map of existing matkuls for quick lookup
    final Map<String, Matkul> existingMatkuls = {};
    for (var matkul in box.values) {
      if (matkul.matkulId != null) {
        existingMatkuls[matkul.matkulId!] = matkul;
      }
    }
    final Map<String, Matkul> updatedMatkuls = {};
    final Set<String> processedIds = {};

    for (var matkul in firebaseMatkuls) {
      if (matkul.matkulId != null) {
        updatedMatkuls[matkul.matkulId!] = matkul;
        processedIds.add(matkul.matkulId!);
      }
    }

    //find local matkuls that dont exist in firebase (to be deleted)
    final List<String> toDelete = [];
    for (var id in existingMatkuls.keys) {
      if (processedIds.contains(id)) {
        toDelete.add(id);
      }
    }

    //update the box
    await box.putAll(updatedMatkuls);
    await box.deleteAll(toDelete);
  }
}
