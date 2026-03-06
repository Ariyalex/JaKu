import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/data/entities/task.dart';

class LocalTaskProvider {
  Box<Task> get _taskBox => Hive.box<Task>("taskBox");

  List<Task> getAllTask() {
    try {
      return _taskBox.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  List<Task> getTasksByMatkul(String matkulId) {
    try {
      final tasks = _taskBox.values.toList();
      return tasks.where((task) => task.groupId == matkulId).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveTask(Task task) async {
    try {
      await _taskBox.put(task.id, task);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      for (var task in tasks) {
        await _taskBox.put(task.id, task);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllTask() async {
    try {
      await _taskBox.clear();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  Task? getTaskById(String id) {
    try {
      return _taskBox.get(id);
    } catch (e) {
      rethrow;
    }
  }
}
