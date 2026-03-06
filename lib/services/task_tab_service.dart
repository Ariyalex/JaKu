import 'package:hive/hive.dart';
import 'package:jaku/data/entities/task_tab.dart';

class TaskTabService {
  static const taskBoxName = "task_tab_box";

  //init hive
  static Future<void> initTaskTabService() async {
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(TaskTabAdapter());
    }
    await Hive.openBox<TaskTab>(taskBoxName);
  }

  //get reference to the box
  static Box<TaskTab> getTaskTabBox() {
    return Hive.box<TaskTab>(taskBoxName);
  }

  //save single task
  static Future<void> saveTaskTabService(TaskTab tab) async {
    final box = getTaskTabBox();
    await box.put(tab.id, tab);
  }

  //get all saved tasks
  static List<TaskTab> getAllTaskTabService() {
    final box = getTaskTabBox();
    return box.values.toList();
  }

  //delete a task by id
  static Future<void> deleteTaskTabService(String id) async {
    final box = getTaskTabBox();
    await box.delete(id);
  }
}
