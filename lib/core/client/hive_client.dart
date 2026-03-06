import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/entities/note.dart';
import 'package:jaku/data/entities/task.dart';

class HiveClient {
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(MatkulAdapter());
    Hive.registerAdapter(MatkulScheduleAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TaskAdapter());

    await Hive.openBox<Matkul>("matkulBox");
    await Hive.openBox<MatkulSchedule>("scheduleBox");
    await Hive.openBox<Note>("noteBox");
    await Hive.openBox<Task>("taskBox");
  }
}
