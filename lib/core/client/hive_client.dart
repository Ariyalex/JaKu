import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/data/entities/application_setting.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/entities/note.dart';
import 'package:jaku/data/entities/task.dart';
import 'package:jaku/data/entities/task_tab.dart';
import 'package:jaku/data/entities/time_of_day_adapter.dart';
import 'package:jaku/data/value_objects/day.dart';

class HiveClient {
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ApplicationSettingAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(MatkulAdapter());
    Hive.registerAdapter(MatkulScheduleAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskTabAdapter());
    Hive.registerAdapter(DayAdapter());

    await Hive.openBox<ApplicationSetting>("settingBox");
    await Hive.openBox<Matkul>("matkulBox");
    await Hive.openBox<MatkulSchedule>("scheduleBox");
    await Hive.openBox<Note>("noteBox");
    await Hive.openBox<Task>("taskBox");
    await Hive.openBox<TaskTab>("taskTabBox");
  }
}
