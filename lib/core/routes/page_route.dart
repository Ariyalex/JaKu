import 'package:get/get.dart';
import 'package:jaku/presentation/bindings/detail_jadwal_binding.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/presentation/screens/note/add_note.dart';
import 'package:jaku/presentation/screens/note/detail_note.dart';
import 'package:jaku/presentation/screens/note/note_dashboard.dart';
import 'package:jaku/presentation/screens/schedule/detail_matkul.dart';
import 'package:jaku/presentation/screens/guide/guide_schedule.dart';
import 'package:jaku/presentation/screens/guide/guide_pdf.dart';
import 'package:jaku/presentation/screens/schedule/schedule_dashboard.dart';
import 'package:jaku/presentation/screens/schedule/pdf_parsing.dart';
import 'package:jaku/presentation/screens/task/task_dashboard.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteNamed.scheduleDashboard,
      page: () => const ScheduleDashboard(),
    ),
    GetPage(name: RouteNamed.noteDashboard, page: () => const NoteDashboard()),
    GetPage(name: RouteNamed.taskDashboard, page: () => const TaskDashboard()),
    GetPage(name: RouteNamed.pdfParsing, page: () => const PdfParsing()),
    GetPage(name: RouteNamed.guidePdf, page: () => const GuidePdf()),
    GetPage(name: RouteNamed.guideGeneral, page: () => const GuideGeneral()),
    GetPage(
      name: RouteNamed.detailMatkul,
      binding: DetailJadwalBinding(),
      page: () => const DetailMatkul(),
    ),
    GetPage(name: RouteNamed.addNote, page: () => const AddNote()),
    GetPage(name: RouteNamed.detailNote, page: () => const DetailNote()),
  ];
}
