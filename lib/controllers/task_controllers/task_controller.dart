import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/services/task_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class TaskController extends GetxController {
  final titleC = TextEditingController();
  final descC = TextEditingController();
  RxnString matkulC = RxnString(); //ini berisi matkul id
  Rxn<DateTime> dueDateC = Rxn<DateTime>();
  RxBool isStaredC = false.obs;

  RxBool isLoading = false.obs;

  final RxList<Task> allTask = <Task>[].obs;

  void loadAllTasks() {
    try {
      allTask.clear();

      final tasks = TaskService.getAllTaskService();

      allTask.value = tasks;

      for (var task in tasks) {
        print("starred: ${task.isStared}");
        print("dueDate: ${task.taskDueDate}");
        print("matkul: ${task.matkulId}");
      }
    } catch (error) {
      print("error load all notes: $error");
      rethrow;
    }
  }

  Task? selectById(String id) {
    if (allTask.isEmpty) {
      print("task kosong");
      return null;
    }
    return allTask.firstWhere(
      (element) => element.id == id,
      orElse: () => throw Exception("Task dengan ID $id tidak ditemukan"),
    );
  }

  void addTask() {
    try {
      Task newTask = Task(
        id: uuid.v4(),
        task: titleC.text,
        status: false,
        isStared: isStaredC.value,
        desc: descC.text,
        matkulId: matkulC.value,
        taskDueDate: dueDateC.value,
      );

      allTask.add(newTask);

      TaskService.saveTaskService(newTask);

      print("starred: ${newTask.isStared}");
      print("dueDate: ${newTask.taskDueDate}");
      print("matkul: ${newTask.matkulId}");
    } catch (error) {
      print("error add task: $error");
    }
  }

  void updateTask(String id) {
    try {
      int index = allTask.indexWhere((task) => task.id == id);
      if (index == -1) return;

      final oldTask = allTask[index];

      final updatedTask = oldTask.copyWith(
        task: titleC.text,
        desc: descC.text,
        isStared: isStaredC.value,
        matkulId: matkulC.value,
        taskDueDate: dueDateC.value,
      );

      allTask[index] = updatedTask;
      TaskService.saveTaskService(updatedTask);
    } catch (error) {
      print("error update task: $error");
      rethrow;
    }
  }

  void deleteNote(String id) {
    try {
      allTask.removeWhere((task) => task.id == id);
      TaskService.deleteTaskService(id);
    } catch (error) {
      print("error deleting task: $error");
      rethrow;
    }
  }

  void updateTaskStatus(String id, bool status) {
    final index = allTask.indexWhere((t) => t.id == id);
    if (index != -1) {
      allTask[index] = allTask[index].copyWith(
        status: status,
        matkulId: allTask[index].matkulId,
      );
      TaskService.saveTaskService(allTask[index]);
    }
  }

  void updateTaskStarred(String id, bool isStared) {
    final index = allTask.indexWhere((t) => t.id == id);
    if (index != -1) {
      allTask[index] = allTask[index].copyWith(
        isStared: isStared,
        matkulId: allTask[index].matkulId,
      );
      TaskService.saveTaskService(allTask[index]);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadAllTasks();
  }
}
