import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/widgets/task_widgets/add_task_modal.dart';
import 'package:jaku/widgets/task_widgets/build_task_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({super.key});

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  final GlobalKey<ExpandableFabState> fabKey = GlobalKey<ExpandableFabState>();

  // Dummy data
  final List<Task> tasks = [
    Task(
      task: "Tugas ERD",
      desc: "Buat ERD untuk sistem informasi akademik.",
      matkul: "IMK",
      isStared: true,
      status: false,
      taskDueDate: DateTime(2025, 8, 4),
      taskDueTime: TimeOfDay(hour: 10, minute: 0),
    ),
    Task(
      task: "Upload tugas ke LMS",
      desc: "Upload file PDF ke LMS sebelum deadline.",
      matkul: "IMK",
      isStared: false,
      status: false,
      taskDueDate: DateTime(2025, 8, 5),
      taskDueTime: TimeOfDay(hour: 23, minute: 59),
    ),
    Task(
      task: "Quiz Bab 1-2",
      desc:
          "Kerjakan quiz materi bab 1 dan 2 di kelas fas fadsf dsafdfsa fads fads f sadfads f adsf ads .",
      matkul: "PBO",
      isStared: true,
      status: true,
      taskDueDate: DateTime(2025, 8, 18),
      taskDueTime: TimeOfDay(hour: 9, minute: 0),
    ),
    Task(
      task: "Tugas Makalah",
      matkul: "PBO",
      isStared: false,
      status: true,
      taskDueDate: DateTime(2025, 8, 25),
      taskDueTime: TimeOfDay(hour: 23, minute: 59),
    ),
    Task(
      task: "Ujian Tengah Semester",
      matkul: "IMK",
      isStared: true,
      status: true,
      taskDueDate: DateTime(2025, 9, 1),
      taskDueTime: TimeOfDay(hour: 8, minute: 0),
    ),
    Task(
      task: "Beli alat tulis",
      matkul: null,
      isStared: true,
      status: false,
      taskDueDate: DateTime(2025, 8, 10),
      taskDueTime: TimeOfDay(hour: 15, minute: 0),
    ),
    Task(task: "Isi KRS", matkul: null, isStared: false, status: true),
  ];

  late List<String> matkulList;

  @override
  void initState() {
    super.initState();
    matkulList = [
      ...{
        for (var t in tasks)
          if (t.matkul != null) t.matkul!,
      },
    ];
    matkulList.add("Umum");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Buat daftar tab dan konten
    final List<Widget> tabs = [
      const Tab(icon: Icon(Icons.star)),
      ...matkulList.where((m) => m != "Umum").map((m) => Tab(text: m)),
      const Tab(text: "Umum"),
    ];

    final List<Widget> tabViews = [
      BuildTaskWidget(
        title: 'Starred',
        filteredTasks: tasks.where((task) => task.isStared == true).toList(),
      ),
      ...matkulList
          .where((m) => m != "Umum")
          .map(
            (m) => BuildTaskWidget(
              title: m,
              filteredTasks: tasks.where((t) => t.matkul == m).toList(),
            ),
          ),
      BuildTaskWidget(
        title: 'Umum',
        filteredTasks: tasks.where((t) => t.matkul == null).toList(),
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: const Text("Task"),
          bottom: TabBar(
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
        body: SafeArea(child: TabBarView(children: tabViews)),
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
                    fabKey.currentState?.close();
                    showBarModalBottomSheet<Map<String, dynamic>>(
                      barrierColor: Colors.black.withValues(alpha: 0.4),
                      context: context,
                      useRootNavigator: true,
                      bounce: true,
                      backgroundColor: theme.colorScheme.surfaceContainer,
                      builder: (context) => const AddTaskModal(),
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
