import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/data/models/matkul_schedule.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';
import 'package:jaku/modules/schedule/widgets/edit_jadwal.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/schedule/widgets/detail_matkul/informasi_matkul.dart';
import 'package:jaku/modules/schedule/widgets/detail_matkul/note_matkul.dart';
import 'package:jaku/modules/schedule/widgets/detail_matkul/task_matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ScheduleDetailScreen extends HookWidget {
  final String id;
  const ScheduleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheduleState = context.watch<ScheduleBloc>().state;

    // 2. useEffect untuk fetch data
    useEffect(() {
      // Selalu panggil load schedule untuk memastikan data terbaru/ada
      context.read<ScheduleBloc>().add(LoadSchedule(id));
      return null;
    }, [id]);

    MatkulSchedule? selectedSchedule;
    if (scheduleState is ScheduleLoaded && scheduleState.schedule.id == id) {
      selectedSchedule = scheduleState.schedule;
    }

    // 3. useEffect kedua: fetch Note & Task setelah selectedSchedule tersedia
    useEffect(() {
      if (selectedSchedule != null) {
        final matkulId = selectedSchedule.matkulId;
        context.read<NoteBloc>().add(LoadListNoteByMatkul(matkulId));
        context.read<TaskBloc>().add(LoadListTaskByMatkul(matkulId));
      }
      return null;
    }, [selectedSchedule?.id, selectedSchedule?.matkulId]);

    // 4. Tampilkan Loading jika sedang fetch
    if (selectedSchedule == null) {
      if (scheduleState is ScheduleError) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(scheduleState.message)),
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
              await showBarModalBottomSheet<Map<String, dynamic>>(
                barrierColor: Colors.black.withValues(alpha: 0.4),
                context: context,
                useRootNavigator: true,
                backgroundColor: theme.colorScheme.surfaceContainer,
                builder: (context) => EditScheduleWidget(scheduleId: id),
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
                InformasiMatkul(matkulId: selectedSchedule.matkulId),
                const SizedBox(height: 5),

                // Section Notes
                NoteMatkul(matkulId: selectedSchedule.matkulId),

                const SizedBox(height: 10),

                // Section Tasks
                TaskMatkul(matkulId: selectedSchedule.matkulId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
