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
  // --- Repository Providers ---
  static List<RepositoryProvider> get repositoryProviders => [
    RepositoryProvider<LocalMatkulProvider>(
      create: (context) => LocalMatkulProvider(),
    ),
    RepositoryProvider<MatkulRepository>(
      create: (context) =>
          MatkulRepository(context.read<LocalMatkulProvider>()),
    ),
    RepositoryProvider<LocalMatkulScheduleProvider>(
      create: (context) => LocalMatkulScheduleProvider(),
    ),
    RepositoryProvider<MatkulScheduleRepository>(
      create: (context) =>
          MatkulScheduleRepository(context.read<LocalMatkulScheduleProvider>()),
    ),
    RepositoryProvider<LocalNoteProvider>(
      create: (context) => LocalNoteProvider(),
    ),
    RepositoryProvider<NoteRepository>(
      create: (context) => NoteRepository(context.read<LocalNoteProvider>()),
    ),
    RepositoryProvider<LocalTaskProvider>(
      create: (context) => LocalTaskProvider(),
    ),
    RepositoryProvider<TaskRepository>(
      create: (context) => TaskRepository(context.read<LocalTaskProvider>()),
    ),
    RepositoryProvider<LocalTaskTabProvider>(
      create: (context) => LocalTaskTabProvider(),
    ),
    RepositoryProvider<TaskTabRepository>(
      create: (context) =>
          TaskTabRepository(context.read<LocalTaskTabProvider>()),
    ),
  ];

  // --- Bloc Providers ---
  static List<BlocProvider> get blocProviders => [
    BlocProvider<MatkulBloc>(
      create: (context) => MatkulBloc(
        context.read<MatkulRepository>(),
        context.read<MatkulScheduleRepository>(),
        context.read<NoteRepository>(),
        context.read<TaskRepository>(),
      ),
    ),
    BlocProvider<ScheduleBloc>(
      create: (context) =>
          ScheduleBloc(context.read<MatkulScheduleRepository>()),
    ),
    BlocProvider<NoteBloc>(
      create: (context) => NoteBloc(context.read<NoteRepository>()),
    ),
    BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(context.read<TaskRepository>()),
    ),
  ];
}
