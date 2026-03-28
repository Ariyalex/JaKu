import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/core/utils/my_snackbar.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/notification/bloc/notification_bloc.dart';
import 'package:jaku/modules/notification/bloc/notification_state.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_state.dart';
import 'package:jaku/modules/task/widgets/add_group_modal.dart';
import 'package:jaku/modules/task/widgets/add_task_modal.dart';
import 'package:jaku/modules/task/widgets/build_task_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskDashboard extends HookWidget {
  const TaskDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabKey = useMemoized(() => GlobalKey<ExpandableFabState>());

    final taskBloc = context.read<TaskBloc>();
    final mainTabBloc = context.read<MainTabBloc>();
    final matkulBloc = context.read<MatkulBloc>();

    useEffect(() {
      if (mainTabBloc.state.taskTabs.isEmpty) {
        mainTabBloc.add(LoadAllTaskTabs());
      }
      if (matkulBloc.state.status == MatkulStatus.initial) {
        matkulBloc.add(LoadAllMatkul());
      }
      return null;
    }, []);

    final mainTabState = context.watch<MainTabBloc>().state;
    final matkulState = context.watch<MatkulBloc>().state;

    List<dynamic> matkulList = matkulState.matkuls;

    final taskTabs = mainTabState.taskTabs;
    final tabLength = 3 + taskTabs.length + matkulList.length;

    final currentIndex = useState<int>(0);

    final tabController = useTabController(
      initialLength: tabLength,
      initialIndex: currentIndex.value < tabLength ? currentIndex.value : 0,
      keys: [tabLength], // Re-create if length changes
    );

    // Notification routing logic
    final notificationState = context.watch<NotificationBloc>().state;
    if (notificationState is NotificationLoaded &&
        notificationState.payload.isNotEmpty) {
      final payload = notificationState.payload;
      final taskState = taskBloc.state;
      if (taskState.status == TaskStatus.success) {
        final task = taskState.tasks.where((t) => t.id == payload).firstOrNull;
        if (task != null) {
          final matkulId = task.groupId;
          final matkulIndex = matkulList.indexWhere((m) => m.id == matkulId);
          if (matkulIndex != -1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              tabController.animateTo(3 + taskTabs.length + matkulIndex);
            });
          }
        }
      }
    }

    void deleteTabs(String groupId) async {
      try {
        mainTabBloc.add(DeleteTaskTab(groupId));
        MySnackbar.success(
          title: "Success!",
          message: "Berhasil menghapus tab",
        );
      } catch (error) {
        MySnackbar.error(title: "Error!", message: "Error: $error");
      }
    }

    void addTabs(String tabName) {
      try {
        final newTabIndex = 3 + taskTabs.length;
        currentIndex.value = newTabIndex;

        mainTabBloc.add(AddTaskTab(tabName));
        MySnackbar.success(
          title: "Success!",
          message: "Berhasil menambahkan tab baru",
        );
      } catch (error) {
        MySnackbar.error(title: "Error!", message: "Error: $error");
      }
    }

    final List<Widget> tabs = [
      const Tab(text: "Semua"),
      const Tab(icon: Icon(Icons.star)),
      const Tab(text: "Umum"),
      ...taskTabs.map((tab) => Tab(text: tab.tabName)),
      ...matkulList.map((m) => Tab(text: m.nameAbbreviation)),
    ];

    final List<Widget> tabViews = [
      const BuildTaskWidget(tabName: "Semua", tabIndex: "0"),
      const BuildTaskWidget(tabName: 'Starred', tabIndex: "1"),
      const BuildTaskWidget(tabName: 'Umum', tabIndex: "2"),
      ...taskTabs.map(
        (tab) => BuildTaskWidget(
          tabName: tab.tabName,
          tabIndex: tab.id,
          deleteTabFunction: (groupId) => deleteTabs(groupId),
        ),
      ),
      ...matkulList.map(
        (m) => BuildTaskWidget(tabName: m.nameAbbreviation, tabIndex: m.id),
      ),
    ];

    useEffect(() {
      void listener() {
        if (!tabController.indexIsChanging) {
          currentIndex.value = tabController.index;
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text("Task"),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          splashFactory: InkSparkle.splashFactory,
          splashBorderRadius: const BorderRadius.only(
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
        duration: const Duration(milliseconds: 340),
        childrenAnimation: ExpandableFabAnimation.none,
        distance: 70,
        overlayStyle: ExpandableFabOverlayStyle(
          color: theme.colorScheme.surface.withValues(alpha: 0.7),
        ),
        children: [
          Row(
            children: [
              Text('Add Group', style: theme.textTheme.bodyLarge),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  fabKey.currentState?.close();
                  showBarModalBottomSheet<void>(
                    barrierColor: Colors.black.withValues(alpha: 0.4),
                    context: context,
                    useRootNavigator: true,
                    bounce: true,
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    builder: (context) => AddGroupModal(onUpdateTabs: addTabs),
                  );
                },
                child: const Icon(Icons.playlist_add),
              ),
            ],
          ),
          Row(
            children: [
              Text('Add Task', style: theme.textTheme.bodyLarge),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  final tabIndex = tabController.index;
                  String? selectedMatkul;
                  if (tabIndex >= 3) {
                    if (tabIndex >= (3 + taskTabs.length)) {
                      selectedMatkul =
                          matkulList[tabIndex - (3 + taskTabs.length)].id;
                    } else {
                      selectedMatkul = taskTabs[tabIndex - 3].id;
                    }
                  }
                  fabKey.currentState?.close();
                  showBarModalBottomSheet<void>(
                    barrierColor: Colors.black.withValues(alpha: 0.4),
                    context: context,
                    useRootNavigator: true,
                    bounce: true,
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    builder: (context) => AddTaskModal(
                      matkulId: selectedMatkul,
                      starred: tabIndex == 0,
                    ),
                  );
                },
                child: const Icon(Icons.add_task),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
