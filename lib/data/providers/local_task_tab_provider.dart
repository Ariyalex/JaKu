import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/data/entities/task_tab.dart';

class LocalTaskTabProvider {
  Box<TaskTab> get _box => Hive.box<TaskTab>("taskTabBox");

  List<TaskTab> getAllTaskTabs() {
    try {
      return _box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveTaskTab(TaskTab tab) async {
    try {
      await _box.put(tab.id, tab);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTaskTab(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      rethrow;
    }
  }
}
