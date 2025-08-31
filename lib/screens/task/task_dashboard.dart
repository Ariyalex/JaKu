import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/main_tab_controller.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
import 'package:jaku/controllers/notification_controller.dart';
import 'package:jaku/controllers/task_controllers/task_controller.dart';
import 'package:jaku/widgets/task_widgets/add_group_modal.dart';
import 'package:jaku/widgets/task_widgets/add_task_modal.dart';
import 'package:jaku/widgets/task_widgets/build_task_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({super.key});

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  //fabKey untuk controller floating action button
  final GlobalKey<ExpandableFabState> fabKey = GlobalKey<ExpandableFabState>();
  final matkulC = Get.find<MatkulController>();
  final notifC = Get.find<NotificationController>();
  final tabC = Get.find<MainTabController>();

  late TaskController taskC;

  @override
  void initState() {
    super.initState();
    taskC = Get.put(TaskController());
  }

  @override
  void dispose() {
    Get.delete<TaskController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matkulList = matkulC.allMatkul;

    //function for routing when click notification
    if (notifC.payload.value.isNotEmpty) {
      print("note id: ${notifC.payload.value}");
      final matkulId = taskC.selectById(notifC.payload.value)!.groupId;
      print("matkul id: $matkulId");
      final matkulIndex = matkulList.indexWhere(
        (matkul) => matkul.id == matkulId,
      );

      print("matkul index: $matkulIndex");
      if (matkulIndex != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("harusnya routing ke: ${1 + (matkulIndex + 1)}");

          //routing to designated tab
          taskC.tabController.animateTo(1 + (matkulIndex + 1));
          notifC.payload.value = ""; // reset agar tidak pindah tab terus
        });
      }
    }

    return Obx(() {
      //fungction for deleting tab
      void deleteTabs(String groupId) async {
        try {
          tabC.deleteTaskTab(groupId);

          taskC.updateTabLength();

          taskC.tabController.index =
              1 + tabC.taskTabs.length; //move to tabs before
          print("menjalankan update tabs");
        } catch (on) {
          print(on); // TODO: rem
        }
      }

      //fungction for adding tab
      void addTabs() async {
        try {
          await tabC.addTaskTab();

          taskC.updateTabLength();

          taskC.tabController.index = 1 + tabC.taskTabs.length;
        } catch (on) {
          print(on); // TODO: rem
        }
      }

      //list of tabs
      final List<Widget> tabs = [
        const Tab(icon: Icon(Icons.star)),
        const Tab(text: "Umum"),
        ...tabC.taskTabs.map((tab) => Tab(text: tab.tabName)),
        ...matkulList.map((m) => Tab(text: m.abbreviation)),
      ];

      //list of tabs content
      final List<Widget> tabViews = [
        const BuildTaskWidget(group: 'Starred', groupId: "0"),
        const BuildTaskWidget(group: 'Umum', groupId: "1"),
        ...tabC.taskTabs.map(
          (tab) => BuildTaskWidget(
            group: tab.tabName,
            groupId: tab.id,
            deleteTabFunction: (groupId) {
              deleteTabs(groupId);
            },
          ),
        ),
        ...matkulList.map(
          (m) => BuildTaskWidget(group: m.abbreviation, groupId: m.id),
        ),
      ];

      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: const Text("Task"),
          bottom: TabBar(
            controller: taskC.tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            splashFactory: InkSparkle.splashFactory,
            splashBorderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            tabs: tabs,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: taskC.tabController,
            children: tabViews,
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: fabKey,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(LucideIcons.plus),
            fabSize: ExpandableFabSize.regular,
            shape: const CircleBorder(),
            angle: math.pi / 4,
          ),
          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            child: Transform.rotate(
              angle: math.pi / 4,
              child: const Icon(LucideIcons.plus),
            ),
            fabSize: ExpandableFabSize.regular,
            shape: const CircleBorder(),
          ),
          type: ExpandableFabType.up,
          duration: Duration(milliseconds: 340),
          childrenAnimation: ExpandableFabAnimation.none,
          distance: 70,
          overlayStyle: ExpandableFabOverlayStyle(
            color: theme.colorScheme.surface.withValues(alpha: 0.7),
          ),
          children: [
            Row(
              children: [
                Text('Add Group', style: theme.textTheme.bodyLarge),
                SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    fabKey.currentState?.close();
                    showBarModalBottomSheet<Map<String, dynamic>>(
                      barrierColor: Colors.black.withValues(alpha: 0.4),
                      context: context,
                      useRootNavigator: true,
                      bounce: true,
                      backgroundColor: theme.colorScheme.surfaceContainer,
                      builder: (context) =>
                          AddGroupModal(onUpdateTabs: addTabs),
                    );
                  },
                  child: Icon(Icons.playlist_add),
                ),
              ],
            ),
            Row(
              children: [
                Text('Add Task', style: theme.textTheme.bodyLarge),
                SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () async {
                    final tabIndex = taskC.tabController.index;
                    String? selectedMatkul;
                    if (tabIndex >= 2) {
                      if (tabIndex >= (2 + tabC.taskTabs.length)) {
                        selectedMatkul =
                            matkulList[tabIndex - (2 + tabC.taskTabs.length)]
                                .id;
                      } else {
                        selectedMatkul = tabC.taskTabs[tabIndex - 2].id;
                      }
                    }
                    fabKey.currentState?.close();
                    showBarModalBottomSheet<Map<String, dynamic>>(
                      barrierColor: Colors.black.withValues(alpha: 0.4),
                      context: context,
                      useRootNavigator: true,
                      bounce: true,
                      backgroundColor: theme.colorScheme.surfaceContainer,
                      builder: (context) =>
                          AddTaskModal(matkulId: selectedMatkul),
                    );
                  },
                  child: Icon(Icons.add_task),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
