import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/schedule/widgets/detail_schedule/schedule_information.dart';
import 'package:jaku/modules/schedule/widgets/detail_schedule/note_matkul.dart';
import 'package:jaku/modules/schedule/widgets/detail_schedule/task_matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScheduleDetailScreen extends HookWidget {
  final String id;
  const ScheduleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheduleBloc = context.read<ScheduleBloc>();
    final scheduleState = context.watch<ScheduleBloc>().state;

    useEffect(() {
      scheduleBloc.add(LoadSchedule(id));
      return null;
    }, [id]);

    final selectedSchedule = useMemoized(() {
      if (scheduleState.selectedSchedule?.id == id) {
        return scheduleState.selectedSchedule;
      }
      return scheduleState.schedules.where((e) => e.id == id).firstOrNull;
    }, [scheduleState.selectedSchedule, id]);

    useEffect(() {
      if (selectedSchedule != null) {
        final matkulId = selectedSchedule.matkulId;
        context.read<NoteBloc>().add(LoadListNoteByMatkul(matkulId));
        context.read<TaskBloc>().add(LoadListTaskByMatkul(matkulId));
      }
      return null;
    }, [selectedSchedule?.id, selectedSchedule?.matkulId]);

    if (selectedSchedule == null) {
      if (scheduleState.status == ScheduleStatus.error) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(scheduleState.message ?? "Error")),
        );
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leadingWidth: 50,
        actions: [
          IconButton(
            onPressed: () async {
              context.pushNamed(
                RouteNamed.editSchedule,
                pathParameters: {"id": id},
              );
            },
            icon: const Icon(LucideIcons.squarePen),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScheduleInformation(schedule: selectedSchedule),
                const SizedBox(height: 5),
                NoteMatkul(matkulId: selectedSchedule.matkulId),
                const SizedBox(height: 10),
                TaskMatkul(matkulId: selectedSchedule.matkulId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
