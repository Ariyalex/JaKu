import 'package:jaku/data/entities/task_tab.dart';
import 'package:jaku/data/providers/local_task_tab_provider.dart';

class TaskTabRepository {
  final LocalTaskTabProvider _localProvider;
  TaskTabRepository(this._localProvider);

  List<TaskTab> getAllTaskTabs() {
    try {
      return _localProvider.getAllTaskTabs();
    } catch (e) {
      print("error get all task tabs(repo): $e");
      rethrow;
    }
  }

  Future<void> addTaskTab(TaskTab tab) async {
    try {
      await _localProvider.saveTaskTab(tab);
    } catch (e) {
      print("error save task tab(repo): $e");
      rethrow;
    }
  }

  Future<void> deleteTaskTab(String id) async {
    try {
      await _localProvider.deleteTaskTab(id);
    } catch (e) {
      print("error delete task tab(repo): $e");
      rethrow;
    }
  }
}
