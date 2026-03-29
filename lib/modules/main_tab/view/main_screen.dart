import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_state.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/view/matkul_dashboard.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/modules/note/view/note_dashboard.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/view/schedule_dashboard.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/task/bloc/task_state.dart';
import 'package:jaku/modules/task/view/task_dashboard.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainTabBloc = context.read<MainTabBloc>();
    final currentMatkul = context.watch<MatkulBloc>().state.activeMatkuls;

    return Scaffold(
      // PersistentTabView sudah mengelola Scaffold internal,
      // tapi membungkusnya di sini memastikan area aman dan layout yang benar.
      body: BlocBuilder<MainTabBloc, MainTabState>(
        buildWhen: (previous, current) => false,
        builder: (context, state) {
          return MultiBlocListener(
            listeners: [
              BlocListener<NoteBloc, NoteState>(
                listenWhen: (previous, current) =>
                    current.status == NoteStatus.actionSuccess,
                listener: (context, noteState) {
                  context.read<NoteBloc>().add(LoadListNote(currentMatkul));
                },
              ),
              // BlocListener<MatkulBloc, MatkulState>(
              //   listenWhen: (previous, current) => current.status == MatkulStatus.success,
              //   listener: (context, state) {
              //     // TODO: implement listener
              //   },
              // ),
              BlocListener<TaskBloc, TaskState>(
                listenWhen: (previous, current) =>
                    current.status == TaskStatus.actionSuccess,
                listener: (context, taskState) {
                  context.read<TaskBloc>().add(LoadListTask(currentMatkul));
                },
              ),
            ],
            child: PersistentTabView(
              controller: mainTabBloc.mainTabController,
              onTabChanged: (value) {
                if (value == 0) {
                  context.read<ScheduleBloc>().add(
                    LoadListSchedule(currentMatkul),
                  );
                } else if (value == 1) {
                  context.read<MatkulBloc>().add(LoadListMatkulSemester());
                } else if (value == 2) {
                  context.read<NoteBloc>().add(LoadListNote(currentMatkul));
                } else if (value == 3) {
                  context.read<TaskBloc>().add(LoadListTask(currentMatkul));
                }
              },
              tabs: [
                PersistentTabConfig(
                  screen: const ScheduleDashboard(),
                  item: ItemConfig(
                    icon: const Icon(Icons.event_note),
                    title: "Schedule",
                  ),
                ),
                PersistentTabConfig(
                  screen: const MatkulDashboard(),
                  item: ItemConfig(
                    icon: const Icon(LucideIcons.library),
                    title: "Matkul",
                  ),
                ),
                PersistentTabConfig(
                  screen: const NoteDashboard(),
                  item: ItemConfig(
                    icon: const Icon(LucideIcons.notebook),
                    title: "Note",
                  ),
                ),
                PersistentTabConfig(
                  screen: const TaskDashboard(),
                  item: ItemConfig(
                    icon: const Icon(LucideIcons.listTodo),
                    title: "Task",
                  ),
                ),
              ],

              navBarBuilder: (navBarConfig) {
                return Style8BottomNavBar(
                  navBarConfig: navBarConfig,
                  navBarDecoration: NavBarDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
