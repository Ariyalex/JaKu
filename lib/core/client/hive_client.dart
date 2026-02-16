import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/data/models/matkul.dart';
import 'package:jaku/data/models/matkul_schedule.dart';
import 'package:jaku/data/models/note.dart';
import 'package:jaku/data/models/task.dart';

class HiveClient {
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(MatkulAdapter());
    Hive.registerAdapter(MatkulScheduleAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TaskAdapter());

    await Hive.openBox<Matkul>("matkulBox");
    await Hive.openBox<MatkulSchedule>("scheduleBox");
  }
}
