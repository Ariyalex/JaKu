import 'package:hive/hive.dart';
import 'package:jaku/models/task.dart';

class TaskService {
  static const taskBoxName = "task_box";

  //init hive
  static Future<void> initTaskService() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>(taskBoxName);
  }

  //get reference to the box
  static Box<Task> getTaskBox() {
    return Hive.box<Task>(taskBoxName);
  }

  //save single task
  static Future<void> saveTaskService(Task task) async {
    final box = getTaskBox();
    await box.put(task.id, task);
  }

  //save multiple tasks
  static Future<void> saveAllTaskService(List<Task> tasks) async {
    final box = getTaskBox();
    final Map<dynamic, Task> taskMap = {};
    for (var task in tasks) {
      taskMap[task.id] = task;
    }
    await box.putAll(taskMap);
  }

  //get all saved tasks
  static List<Task> getAllTaskService() {
    final box = getTaskBox();
    return box.values.toList();
  }

  //delete a task by id
  static Future<void> deleteTaskService(String id) async {
    final box = getTaskBox();
    await box.delete(id);
  }

  //delete all tasks
  static Future<void> deleteAllTaskService() async {
    final box = getTaskBox();
    await box.clear();
  }
}
