import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/domain/models/matkul_schedule.dart';

class JadwalService {
  static const String scheduleBoxName = "schedule_box";

  //initialize hive
  static Future<void> initScheduleService() async {
    //register adapter jika belum tersedia
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(JadwalAdapter());
    }

    //open box
    await Hive.openBox<MatkulSchedule>(scheduleBoxName);
  }

  //mendapatkan reference to the box
  static Box<MatkulSchedule> getScheduleBox() {
    return Hive.box<MatkulSchedule>(scheduleBoxName);
  }

  // save single matkul
  static Future<void> saveScheduleService(MatkulSchedule schedule) async {
    final box = getScheduleBox();

    if (schedule.id != null) {
      await box.put(schedule.id, schedule);
    } else {
      throw Exception("schedule ID kosong");
    }
  }

  //save multiple matkul
  static Future<void> saveAllScheduleService(
    List<MatkulSchedule> schedules,
  ) async {
    final box = getScheduleBox();

    final Map<dynamic, MatkulSchedule> matkulMap = {};

    for (var matkul in schedules) {
      if (matkul.id == null) {
        throw Exception("schedule id harus ada");
      }
      matkulMap[matkul.id] = matkul;
    }
    await box.putAll(matkulMap);
  }

  //get all saved matkuls
  static List<MatkulSchedule> getAllScheduleService() {
    final box = getScheduleBox();
    return box.values.toList();
  }

  //delete a matkul by id
  static Future<void> deleteScheduleService(String id) async {
    final box = getScheduleBox();
    await box.delete(id);
  }

  //delete all matkul
  static Future<void> deleteAllScheduleService() async {
    final box = getScheduleBox();
    await box.clear();
  }
}
