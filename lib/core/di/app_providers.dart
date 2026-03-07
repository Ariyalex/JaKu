import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/providers/local_matkul_provider.dart';
import 'package:jaku/data/providers/local_matkul_schedule_provider.dart';
import 'package:jaku/data/providers/local_note_provider.dart';
import 'package:jaku/data/providers/local_task_provider.dart';
import 'package:jaku/data/providers/local_task_tab_provider.dart';
import 'package:jaku/data/repositories/matkul_repository.dart';
import 'package:jaku/data/repositories/matkul_schedule_repository.dart';
import 'package:jaku/data/repositories/note_repositoruy.dart';
import 'package:jaku/data/repositories/task_repository.dart';
import 'package:jaku/data/repositories/task_tab_repository.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/task/bloc/task_bloc.dart';

class AppProviders {
  static List<RepositoryProvider> get matkulRepositoryProviders => [
    RepositoryProvider<LocalMatkulProvider>(
      create: (context) => LocalMatkulProvider(),
    ),
    RepositoryProvider<MatkulRepository>(
      create:
          (context) => MatkulRepository(context.read<LocalMatkulProvider>()),
    ),
    RepositoryProvider<MatkulBloc>(
      create: (context) => MatkulBloc(context.read<MatkulRepository>()),
    ),
  ];

  static List<RepositoryProvider> get scheduleRepositoryProviders => [
    RepositoryProvider<LocalMatkulScheduleProvider>(
      create: (context) => LocalMatkulScheduleProvider(),
    ),
    RepositoryProvider<MatkulScheduleRepository>(
      create:
          (context) =>
              MatkulScheduleRepository(
                context.read<LocalMatkulScheduleProvider>(),
              ),
    ),
    RepositoryProvider<ScheduleBloc>(
      create:
          (context) => ScheduleBloc(context.read<MatkulScheduleRepository>()),
    ),
  ];

  static List<RepositoryProvider> get noteRepositoryProviders => [
    RepositoryProvider<LocalNoteProvider>(
      create: (context) => LocalNoteProvider(),
    ),
    RepositoryProvider<NoteRepository>(
      create: (context) => NoteRepository(context.read<LocalNoteProvider>()),
    ),
    RepositoryProvider<NoteBloc>(
      create: (context) => NoteBloc(context.read<NoteRepository>()),
    ),
  ];

  static List<RepositoryProvider> get taskRepositoryProviders => [
    RepositoryProvider<LocalTaskProvider>(
      create: (context) => LocalTaskProvider(),
    ),
    RepositoryProvider<TaskRepository>(
      create: (context) => TaskRepository(context.read<LocalTaskProvider>()),
    ),
    RepositoryProvider<TaskBloc>(
      create: (context) => TaskBloc(context.read<TaskRepository>()),
    ),
    RepositoryProvider<LocalTaskTabProvider>(
      create: (context) => LocalTaskTabProvider(),
    ),
    RepositoryProvider<TaskTabRepository>(
      create:
          (context) =>
              TaskTabRepository(context.read<LocalTaskTabProvider>()),
    ),
  ];
}
