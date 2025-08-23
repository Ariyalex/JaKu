import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jaku/models/task_tab.dart';
import 'package:jaku/services/task_tab_service.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class MainTabController extends GetxController {
  RxList<TaskTab> taskTabs = <TaskTab>[].obs;

  final taskTabC = TextEditingController();

  PersistentTabController mainTabController = PersistentTabController(
    initialIndex: 0,
  );

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
    loadAllTaskTabs();
  }
}
