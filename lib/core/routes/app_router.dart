import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/client/dio_client.dart';
import 'package:jaku/core/di/dependency_injection.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/data/providers/remote_pdf_provider.dart';
import 'package:jaku/data/repositories/pdf_repository.dart';
import 'package:jaku/modules/note/view/add_note.dart';
import 'package:jaku/modules/note/view/detail_note.dart';
import 'package:jaku/modules/note/view/note_dashboard.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_bloc.dart';
import 'package:jaku/modules/schedule/view/schedule_detail_screen.dart';
import 'package:jaku/modules/guides/view/guide_schedule.dart';
import 'package:jaku/modules/guides/view/guide_pdf.dart';
import 'package:jaku/modules/pdf_parse/views/pdf_parsing.dart';
import 'package:jaku/modules/schedule/view/schedule_dashboard.dart';
import 'package:jaku/modules/task/view/task_dashboard.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNamed.scheduleDashboard,
    routes: [
      GoRoute(
        name: RouteNamed.scheduleDashboard,
        path: RouteNamed.scheduleDashboard,
        builder: (context, state) => const ScheduleDashboard(),
      ),
      GoRoute(
        name: RouteNamed.noteDashboard,
        path: RouteNamed.noteDashboard,
        builder: (context, state) => const NoteDashboard(),
      ),
      GoRoute(
        name: RouteNamed.taskDashboard,
        path: RouteNamed.taskDashboard,
        builder: (context, state) => const TaskDashboard(),
      ),
      GoRoute(
        name: RouteNamed.pdfParsing,
        path: RouteNamed.pdfParsing,
        builder: (context, state) => const PdfParsing(),
      ),
      GoRoute(
        name: RouteNamed.guidePdf,
        path: RouteNamed.guidePdf,
        builder: (context, state) => BlocProvider(
          create: (context) => PdfParseBloc(
            PdfRepository(RemotePdfProvider(dio: getIt<DioClient>().dio)),
          ),
          child: const GuidePdf(),
        ),
      ),
      GoRoute(
        name: RouteNamed.guideGeneral,
        path: RouteNamed.guideGeneral,
        builder: (context, state) => const GuideGeneral(),
      ),
      GoRoute(
        name: RouteNamed.detailMatkul,
        path: RouteNamed.detailMatkul,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ScheduleDetailScreen(id: id);
        },
      ),
      GoRoute(
        name: RouteNamed.addNote,
        path: RouteNamed.addNote,
        builder: (context, state) => const AddNote(),
      ),
      GoRoute(
        name: RouteNamed.detailNote,
        path: RouteNamed.detailNote,
        builder: (context, state) => const DetailNote(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri.path}')),
    ),
  );
}
