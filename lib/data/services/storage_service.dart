import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/domain/models/matkul.dart';
import 'package:jaku/domain/models/matkul_schedule.dart';
import 'package:jaku/domain/models/note.dart';
import 'package:jaku/domain/models/task.dart';

class StorageService extends GetxService {
  late Box<Matkul> matkulBox;
  late Box<MatkulSchedule> matkulScheduleBox;

  @override
  void onInit() async {
    super.onInit();
    await Hive.initFlutter();

    Hive.registerAdapter(MatkulAdapter());
    Hive.registerAdapter(MatkulScheduleAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TaskAdapter());

    await openMatkulBox();
    await openMatkulScheduleBox();
  }

  Future<void> openMatkulBox() async {
    matkulBox = await Hive.openBox("matkulBox");
  }

  Future<void> openMatkulScheduleBox() async {
    matkulScheduleBox = await Hive.openBox("matkulBox");
  }
}
