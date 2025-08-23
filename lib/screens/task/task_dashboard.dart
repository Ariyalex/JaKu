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

class _TaskDashboardState extends State<TaskDashboard>
    with TickerProviderStateMixin {
  //fabKey untuk controller floating action button
  final GlobalKey<ExpandableFabState> fabKey = GlobalKey<ExpandableFabState>();
  final matkulC = Get.find<MatkulController>();
  final notifC = Get.find<NotificationController>();
  final tabC = Get.find<MainTabController>();

  late TabController tabController;
  int _tabLength = 0;
  late TaskController taskC;
  late String? selectedMatkul;

  @override
  void initState() {
    super.initState();
    taskC = Get.put(TaskController());
    //init
    _tabLength = getTabLength();
    tabController = TabController(length: _tabLength, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    Get.delete<TaskController>();
    super.dispose();
  }

  int getTabLength() {
    final matkulList = matkulC.allMatkul;
    return 2 + tabC.taskTabs.length + matkulList.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matkulList = matkulC.allMatkul;

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
          tabController.animateTo(1 + (matkulIndex + 1));
          notifC.payload.value = ""; // reset agar tidak pindah tab terus
        });
      }
    }

    return Obx(() {
      // Buat daftar tab dan konten
      final List<Widget> tabs = [
        const Tab(icon: Icon(Icons.star)),
        const Tab(text: "Umum"),
        ...tabC.taskTabs.map((tab) => Tab(text: tab.tabName)),
        ...matkulList.map((m) => Tab(text: m.abbreviation)),
      ];

      final List<Widget> tabViews = [
        BuildTaskWidget(group: 'Starred', groupId: "0"),
        BuildTaskWidget(group: 'Umum', groupId: "1"),
        ...tabC.taskTabs.map(
          (tab) => BuildTaskWidget(group: tab.tabName, groupId: tab.id),
        ),
        ...matkulList.map(
          (m) => BuildTaskWidget(group: m.abbreviation, groupId: m.id),
        ),
      ];

      void updateTabs() async {
        try {
          await tabC.addTaskTab();

          final newLength = getTabLength();
          print("tab length after: ${newLength}");
          tabController = TabController(length: newLength, vsync: this);
          print("menjalankan update tabs");
          setState(() {});
        } catch (on) {
          print(on); // TODO: rem
        }
      }

      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: const Text("Task"),
          bottom: TabBar(
            controller: tabController,
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
          child: TabBarView(controller: tabController, children: tabViews),
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
                          AddGroupModal(onUpdateTabs: updateTabs),
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
                    final tabIndex = tabController.index;
                    String? selectedMatkul;
                    if (tabIndex >= 2) {
                      selectedMatkul = matkulList[tabIndex - 2].id;
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
