import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/client/dio_client.dart';
import 'package:jaku/core/di/dependency_injection.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/data/providers/remote_pdf_provider.dart';
import 'package:jaku/data/repositories/pdf_repository.dart';
import 'package:jaku/modules/main_tab/view/main_screen.dart';
import 'package:jaku/modules/note/view/add_note.dart';
import 'package:jaku/modules/note/view/detail_note.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_bloc.dart';
import 'package:jaku/modules/schedule/view/add_schedule_screen.dart';
import 'package:jaku/modules/schedule/view/edit_schedule_screen.dart';
import 'package:jaku/modules/schedule/view/schedule_detail_screen.dart';
import 'package:jaku/modules/guides/view/guide_schedule.dart';
import 'package:jaku/modules/guides/view/guide_pdf.dart';
import 'package:jaku/modules/pdf_parse/views/pdf_parsing.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      // Rute Utama: Menampilkan MainScreen (dengan Bottom Nav Bar)
      GoRoute(
        path: '/',
        name: RouteNamed.home,
        builder: (context, state) => const MainScreen(),
      ),

      // Rute lainnya tetap ada untuk navigasi deep-link atau push page
      GoRoute(
        name: RouteNamed.pdfParsing,
        path: RouteNamed.pdfParsing,
        builder: (context, state) => BlocProvider(
          create: (context) => PdfParseBloc(
            PdfRepository(RemotePdfProvider(dio: getIt<DioClient>().dio)),
          ),
          child: const PdfParsing(),
        ),
      ),
      GoRoute(
        name: RouteNamed.guidePdf,
        path: RouteNamed.guidePdf,
        builder: (context, state) => const GuidePdf(),
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
        name: RouteNamed.addSchedule,
        path: RouteNamed.addSchedule,
        builder: (context, state) => AddScheduleScreen(),
      ),
      GoRoute(
        name: RouteNamed.editSchedule,
        path: RouteNamed.editSchedule,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditScheduleScreen(scheduleId: id);
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
