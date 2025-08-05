import 'dart:math' as math;

import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/widgets/task_widgets/build_task_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
        matkul: "IMK",
        isStared: false,
        status: false,
        dateTime: DateTime(2025, 8, 4, 10, 0)),
    Task(
        task: "Upload tugas ke LMS",
        matkul: "IMK",
        isStared: false,
        status: true,
        dateTime: DateTime(2025, 8, 5)),
    Task(
        task: "Quiz Bab 1-2",
        matkul: "PBO",
        isStared: false,
        status: true,
        dateTime: DateTime(2025, 8, 18, 9, 0)),
    Task(
        task: "Tugas Makalah",
        matkul: "PBO",
        isStared: false,
        status: true,
        dateTime: DateTime(2025, 8, 25, 23, 59)),
    Task(
        task: "Ujian Tengah Semester",
        matkul: "IMK",
        isStared: true,
        status: true,
        dateTime: DateTime(2025, 9, 1, 8, 0)),
    Task(
        task: "Beli alat tulis",
        matkul: null,
        isStared: true,
        status: false,
        dateTime: DateTime(2025, 8, 10, 15, 0)),
    Task(
      task: "Isi KRS",
      matkul: null,
      isStared: false,
      status: true,
    ),
  ];

  late List<String> matkulList;

  @override
  void initState() {
    super.initState();
    matkulList = [
      ...{
        for (var t in tasks)
          if (t.matkul != null) t.matkul!
      }
    ];
    matkulList.add("Umum");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<TabData> tabs = [
      TabData(
        index: 0,
        title: const Tab(icon: Icon(Icons.star)),
        content: BuildTaskWidget(
          title: 'Starred',
          filteredTasks: tasks.where((task) => task.isStared == true).toList(),
        ),
      ),
      // Tab untuk setiap matkul
      ...matkulList.where((m) => m != "Umum").map(
            (m) => TabData(
              index: matkulList.indexOf(m) + 1,
              title: Tab(text: m),
              content: BuildTaskWidget(
                title: m,
                filteredTasks: tasks.where((t) => t.matkul == m).toList(),
              ),
            ),
          ),
      // Tab untuk Umum (tanpa matkul)
      TabData(
        index: matkulList.length + 1,
        title: const Tab(text: "Umum"),
        content: BuildTaskWidget(
          title: 'Umum',
          filteredTasks: tasks.where((t) => t.matkul == null).toList(),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text("Task"),
      ),
      body: SafeArea(
        child: DynamicTabBarWidget(
          isScrollable: true,
          showBackIcon: false,
          showNextIcon: false,
          tabAlignment: TabAlignment.start,
          dynamicTabs: tabs,
          onTabControllerUpdated: (p0) {},
          onTabChanged: (index) {},
          // isScrollable: true,
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
              Text(
                'Add Group',
                style: theme.textTheme.bodyLarge,
              ),
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
              Text(
                'Add Task',
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  fabKey.currentState?.close();
                  // await showBarModalBottomSheet<Map<String, dynamic>>(
                  //   barrierColor: Colors.black.withValues(alpha: 0.4),
                  //   context: context,
                  //   useRootNavigator: true,
                  //   builder: (context) => ,
                  // );
                },
                child: Icon(Icons.add_task),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
