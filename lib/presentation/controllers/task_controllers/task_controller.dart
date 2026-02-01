import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/presentation/controllers/main_tab_controller.dart';
import 'package:jaku/presentation/controllers/matkul_controllers.dart';
import 'package:jaku/presentation/controllers/notification_controller.dart';
import 'package:jaku/domain/models/matkul.dart';
import 'package:jaku/domain/models/task.dart';
import 'package:jaku/domain/models/task_tab.dart';
import 'package:jaku/application/services/task_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class TaskController extends GetxController with GetTickerProviderStateMixin {
  late TextEditingController titleC;
  late TextEditingController descC;
  RxnString matkulIdC = RxnString(); //ini berisi matkul id
  Rxn<DateTime> dueDateC = Rxn<DateTime>();
  RxBool isStaredC = false.obs;

  RxBool isLoading = false.obs;

  //tab controller
  late TabController tabController;
  RxInt tabLength = 0.obs;

  final RxList<Task> allTask = <Task>[].obs;

  void loadAllTasks() {
    try {
      allTask.clear();

      final tasks = TaskService.getAllTaskService();

      allTask.value = tasks;

      for (var task in tasks) {
        print("starred: ${task.isStared}");
        print("dueDate: ${task.taskDueDate}");
        print("matkul: ${task.groupId}");
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
      final matkulC = Get.find<MatkulController>();
      Task newTask = Task(
        id: uuid.v4(),
        task: titleC.text,
        status: false,
        isStared: isStaredC.value,
        desc: descC.text,
        groupId: matkulIdC.value,
        taskDueDate: dueDateC.value,
      );

      allTask.add(newTask);

      TaskService.saveTaskService(newTask);

      Matkul? matkul;
      TaskTab? taskTab;

      bool isCustomTab =
          matkulIdC.value != null && matkulIdC.value!.startsWith("tab");
      //get matkul
      if (matkulIdC.value != null) {
        if (isCustomTab) {
          final tabC = Get.find<MainTabController>();
          taskTab = tabC.selectTabById(matkulIdC.value!);
        } else {
          matkul = matkulC.selectMatkulById(matkulIdC.value!)!;
        }
      }

      if (dueDateC.value != null) {
        if (dueDateC.value!.isAfter(DateTime.now())) {
          final notifC = Get.find<NotificationController>();
          notifC.scheduleNotification(
            titleC.text,
            matkul == null
                ? (taskTab != null ? "${taskTab.tabName} Task" : "General Task")
                : "${matkul.name} Task",
            dueDateC.value!,
            newTask.id.hashCode,
            newTask.id,
          );
        }
      }

      print("starred: ${newTask.isStared}");
      print("dueDate: ${newTask.taskDueDate}");
      print("matkul: ${newTask.groupId}");
    } catch (error) {
      print("error add task: $error");
    }
  }

  void updateTask(String id) {
    try {
      final matkulC = Get.find<MatkulController>();
      int index = allTask.indexWhere((task) => task.id == id);

      // for (var task in allTask) {
      //   print("task id:${task.id}");
      //   print("task group:${task.groupId}");
      // }

      if (index == -1) return;

      final oldTask = allTask[index];

      final updatedTask = oldTask.copyWith(
        task: titleC.text,
        desc: descC.text,
        isStared: isStaredC.value,
        groupId: matkulIdC.value,
        taskDueDate: dueDateC.value,
      );

      allTask[index] = updatedTask;
      TaskService.saveTaskService(updatedTask);

      Matkul? matkul;
      TaskTab? taskTab;

      bool isCustomTab =
          matkulIdC.value != null && matkulIdC.value!.startsWith("tab");
      //get matkul
      if (matkulIdC.value != null) {
        if (isCustomTab) {
          final tabC = Get.find<MainTabController>();
          taskTab = tabC.selectTabById(matkulIdC.value!);
        } else {
          matkul = matkulC.selectMatkulById(matkulIdC.value!)!;
        }
      }

      if (dueDateC.value != null) {
        if (dueDateC.value!.isAfter(DateTime.now())) {
          final notifC = Get.find<NotificationController>();
          notifC.scheduleNotification(
            titleC.text,
            matkul == null
                ? (taskTab != null ? "${taskTab.tabName} Task" : "General Task")
                : "${matkul.name} Task",
            dueDateC.value!,
            updatedTask.id.hashCode,
            updatedTask.id,
          );
        }
      }
    } catch (error) {
      print("error update task: $error");
      rethrow;
    }
  }

  void deleteTask(String id) {
    try {
      final notifC = Get.find<NotificationController>();

      notifC.cancelNotification(id.hashCode);

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
        groupId: allTask[index].groupId,
      );
      TaskService.saveTaskService(allTask[index]);
    }
  }

  void updateTaskStarred(String id, bool isStared) {
    final index = allTask.indexWhere((t) => t.id == id);
    if (index != -1) {
      allTask[index] = allTask[index].copyWith(
        isStared: isStared,
        groupId: allTask[index].groupId,
      );
      TaskService.saveTaskService(allTask[index]);
    }
  }

  void updateTaskOrder(String id, int order, bool isStarredGroup) {
    final index = allTask.indexWhere((t) => t.id == id);
    if (index != -1) {
      if (isStarredGroup) {
        allTask[index] = allTask[index].copyWith(
          groupId: allTask[index].groupId,
          starredOrder: order,
        );
      } else {
        allTask[index] = allTask[index].copyWith(
          groupId: allTask[index].groupId,
          matkulOrder: order,
        );
      }
      TaskService.saveTaskService(allTask[index]);
    }
    update();
  }

  void reorderTasks(
    List<Task> tasks,
    int oldIndex,
    int newIndex,
    String? groupId,
  ) {
    final Task task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);

    for (var i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      if (groupId == "0") {
        task.starredOrder = i;
        updateTaskOrder(task.id, task.starredOrder!, true);
        print("Starred ${tasks[i].task}: ${tasks[i].starredOrder}");
      } else {
        task.matkulOrder = i;
        updateTaskOrder(task.id, task.matkulOrder!, false);
        print("${tasks[i].task}: ${tasks[i].matkulOrder}");
      }
    }
  }

  int getTabLength() {
    //get all controllers
    try {
      final matkulC = Get.find<MatkulController>();
      final tabC = Get.find<MainTabController>();

      final matkulList = matkulC.allMatkul;
      return 2 + tabC.taskTabs.length + matkulList.length;
    } catch (error) {
      print("error get tab length: $error");
      rethrow;
    }
  }

  void updateTabLength() {
    tabLength.value = getTabLength();
    print("tab length after delete: ${tabLength.value}");
    tabController = TabController(length: tabLength.value, vsync: this);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //init tab controller
    tabLength.value = getTabLength();
    tabController = TabController(
      length: tabLength.value,
      vsync: this,
      initialIndex: 1,
    );

    //init text editing controller
    titleC = TextEditingController();
    descC = TextEditingController();
    loadAllTasks();
  }

  @override
  void onClose() {
    titleC.dispose();
    descC.dispose();
    tabController.dispose();
    super.onClose();
  }
}
