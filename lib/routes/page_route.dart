import 'package:get/get.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/screens/note/add_note.dart';
import 'package:jaku/screens/note/detail_note.dart';
import 'package:jaku/screens/note/note_dashboard.dart';
import 'package:jaku/screens/schedule/detail_matkul.dart';
import 'package:jaku/screens/guide/guide_schedule.dart';
import 'package:jaku/screens/guide/guide_pdf.dart';
import 'package:jaku/screens/schedule/schedule_dashboard.dart';
import 'package:jaku/screens/schedule/pdf_parsing.dart';
import 'package:jaku/screens/tesk/task_dashboard.dart';

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
    GetPage(name: RouteNamed.detailMatkul, page: () => const DetailMatkul()),
    GetPage(name: RouteNamed.addNote, page: () => const AddNote()),
    GetPage(name: RouteNamed.detailNote, page: () => const DetailNote()),
  ];
}
