import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jaku/domain/models/task_tab.dart';
import 'package:jaku/services/task_tab_service.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class MainTabController extends GetxController {
  RxList<TaskTab> taskTabs = <TaskTab>[].obs; //alltabs

  late TextEditingController taskTabC;

  late PersistentTabController mainTabController;

  TaskTab? selectTabById(String id) {
    return taskTabs.firstWhere(
      (element) => element.id == id,
      orElse: () => throw Exception("tab dengan ID $id tidak ditemaukan"),
    );
  }

  Future<void> addTaskTab() async {
    try {
      if (taskTabC.text != "") {
        TaskTab newTab = TaskTab(
          id: "tab-${uuid.v4()}",
          tabName: taskTabC.text,
        );
        taskTabs.add(newTab);
        await TaskTabService.saveTaskTabService(newTab);
      }
    } catch (error) {
      print("error adding tab: $error");
      rethrow;
    }
  }

  Future<void> editTaskTab(String id) async {
    try {
      int index = taskTabs.indexWhere((tab) => tab.id == id);
      if (index == -1) return;

      if (taskTabC.text != "") {
        TaskTab newTab = TaskTab(id: id, tabName: taskTabC.text);

        taskTabs[index] = newTab;
        await TaskTabService.saveTaskTabService(newTab);
      }
    } catch (error) {
      print("error adding tab: $error");
      rethrow;
    }
  }

  void deleteTaskTab(String id) {
    try {
      taskTabs.removeWhere((tab) => tab.id == id);
      TaskTabService.deleteTaskTabService(id);
    } catch (error) {
      print("error deleting task tab: $error");
      rethrow;
    }
  }

  void loadAllTaskTabs() {
    try {
      taskTabs.clear();

      final tasks = TaskTabService.getAllTaskTabService();

      taskTabs.value = tasks;
    } catch (error) {
      print("error load all notes: $error");
      rethrow;
    }
  }

  void routing(int tab) {
    mainTabController.jumpToTab(tab);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    mainTabController = PersistentTabController(initialIndex: 0);
    taskTabC = TextEditingController();
    loadAllTaskTabs();
  }

  @override
  void onClose() {
    taskTabC.dispose();
    mainTabController.dispose();
    super.onClose();
  }
}
