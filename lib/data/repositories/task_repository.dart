import 'package:jaku/data/models/task.dart';
import 'package:jaku/data/providers/local_task_provider.dart';

class TaskRepository {
  final LocalTaskProvider _localProvider;
  TaskRepository(this._localProvider);

  List<Task> getAllTask() {
    try {
      return _localProvider.getAllTask();
    } catch (e) {
      print("error get all task(repo): $e");
      rethrow;
    }
  }

  List<Task> getTasksByMatkul(String matkulId) {
    try {
      return _localProvider.getTasksByMatkul(matkulId);
    } catch (e) {
      print("error get all task(repo): $e");
      rethrow;
    }
  }

  Task getTaskById(String id) {
    try {
      final result = _localProvider.getTaskById(id);
      if (result == null) throw Exception("Task tidak ditemukan");
      return result;
    } catch (e) {
      print("error get task(repo): $e");
      rethrow;
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _localProvider.saveTask(task);
    } catch (e) {
      print("error save task(repo): $e");
      rethrow;
    }
  }

  Future<void> addTasks(List<Task> tasks) async {
    try {
      await _localProvider.saveTasks(tasks);
    } catch (e) {
      print("error save tasks: $e");
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final getTask = _localProvider.getTaskById(task.id);
      if (getTask == null) throw Exception("Task tidak ditemukan");
      await _localProvider.saveTask(task);
    } catch (e) {
      print("error update task: $e");
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final getTask = _localProvider.getTaskById(id);
      if (getTask == null) throw Exception("Task tidak ditemukan");
      await _localProvider.deleteTask(id);
    } catch (e) {
      print("error delete task: $e");
      rethrow;
    }
  }

  Future<void> deleteAllTask() async {
    try {
      await _localProvider.deleteAllTask();
    } catch (e) {
      print("error delete all task: $e");
      rethrow;
    }
  }
}
