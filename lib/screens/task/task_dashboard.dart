import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
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
    with SingleTickerProviderStateMixin {
  final GlobalKey<ExpandableFabState> fabKey = GlobalKey<ExpandableFabState>();
  final matkulC = Get.find<MatkulController>();
  late TabController tabController;
  late TaskController taskC;
  late String? selectedMatkul;

  @override
  void initState() {
    super.initState();
    taskC = Get.put(TaskController());
    tabController = TabController(
      length: 2 + matkulC.allMatkul.length,
      vsync: this,
    );
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

    // Buat daftar tab dan konten
    final List<Widget> tabs = [
      const Tab(icon: Icon(Icons.star)),
      const Tab(text: "Umum"),
      ...matkulList.map((m) => Tab(text: m.abbreviation)),
    ];

    final List<Widget> tabViews = [
      Obx(
        () => BuildTaskWidget(
          title: 'Starred',
          filteredTasks: taskC.allTask
              .where((task) => task.isStared == true)
              .toList(),
        ),
      ),
      Obx(
        () => BuildTaskWidget(
          title: 'Umum',
          filteredTasks: taskC.allTask
              .where((t) => t.matkulId == null)
              .toList(),
        ),
      ),
      ...matkulList.map(
        (m) => Obx(
          () => BuildTaskWidget(
            title: m.abbreviation,
            filteredTasks: taskC.allTask
                .where((t) => t.matkulId == m.id)
                .toList(),
          ),
        ),
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
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
          child: TabBarView(children: tabViews, controller: tabController),
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
                      builder: (context) => const AddGroupModal(),
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
                          AddTaskModal(matkul: selectedMatkul),
                    );
                  },
                  child: Icon(Icons.add_task),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
