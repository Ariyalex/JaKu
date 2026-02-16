import 'package:get/get.dart';
import 'package:jaku/modules/schedule/binding/detail_jadwal_binding.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/modules/note/view/add_note.dart';
import 'package:jaku/modules/note/view/detail_note.dart';
import 'package:jaku/modules/note/view/note_dashboard.dart';
import 'package:jaku/modules/schedule/view/detail_matkul.dart';
import 'package:jaku/modules/guides/view/guide_schedule.dart';
import 'package:jaku/modules/guides/view/guide_pdf.dart';
import 'package:jaku/modules/schedule/view/schedule_dashboard.dart';
import 'package:jaku/modules/schedule/view/pdf_parsing.dart';
import 'package:jaku/modules/task/view/task_dashboard.dart';

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
