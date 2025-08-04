import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/jadwal_kuliah_c.dart';
import 'package:jaku/models/jadwal.dart';
import 'package:jaku/models/note.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/widgets/schedule_widgets/edit_matkul.dart';
import 'package:jaku/widgets/schedule_widgets/detail_matkul/informasi_matkul.dart';
import 'package:jaku/widgets/schedule_widgets/detail_matkul/note_matkul.dart';
import 'package:jaku/widgets/schedule_widgets/detail_matkul/task_matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

String formatTaskDate(DateTime dt) {
  const hari = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
  const bulan = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];
  final hariStr = hari[dt.weekday - 1];
  final tglStr = "${dt.day} ${bulan[dt.month - 1]}";
  final jamStr =
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

  return "$hariStr, $tglStr, $jamStr";
}

class DetailMatkul extends StatefulWidget {
  const DetailMatkul({super.key});

  @override
  State<DetailMatkul> createState() => _DetailMatkulState();
}

class _DetailMatkulState extends State<DetailMatkul> {
  final allMatkulProvider = Get.find<JadwalkuliahC>();

  late Matkul selectedMatkul;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final matkulId = Get.arguments;
    selectedMatkul = allMatkulProvider.selectById(matkulId)!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dummy data untuk notes dan tasks (ganti dengan data asli nanti)
    final List<Note> notes = [
      Note(
          id: "1",
          title: "Catatan Pertemuan 1",
          desc: "Bahas pengenalan mata kuliah dan kontrak kuliah.",
          matkul: "IMK"),
      Note(
          id: "2",
          title: "Catatan Pertemuan 2",
          desc: "Diskusi tentang user interface dan user experience.",
          matkul: "IMK"),
      Note(
          id: "3",
          title: "Reminder Quiz",
          desc: "Akan ada quiz minggu depan, materi bab 1-2.",
          matkul: "IMK"),
    ];
    final List<Task> tasks = [
      Task(
          id: "1",
          task: "Tugas ERD",
          status: false,
          dateTime: DateTime(2025, 8, 4, 10, 0),
          isStared: false,
          matkul: "IMK"),
      Task(
          id: "2",
          task: "Presentasi UI/UX",
          status: true,
          dateTime: DateTime(2025, 8, 11, 13, 30),
          isStared: false,
          matkul: "IMK"),
      Task(
          id: "3",
          task: "Kuis Bab 1-2",
          status: false,
          dateTime: DateTime(2025, 8, 18, 9, 0),
          isStared: false,
          matkul: "IMK"),
      Task(
          id: "4",
          task: "Tugas Makalah",
          status: false,
          dateTime: DateTime(2025, 8, 25, 23, 59),
          isStared: false,
          matkul: "IMK"),
      Task(
          id: "5",
          task: "Ujian Tengah Semester",
          status: false,
          dateTime: DateTime(2025, 9, 1, 8, 0),
          isStared: false,
          matkul: "IMK"),
    ];

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        actions: [
          IconButton(
            onPressed: () async {
              await showBarModalBottomSheet<Map<String, dynamic>>(
                barrierColor: Colors.black.withValues(alpha: 0.4),
                context: context,
                useRootNavigator: true,
                builder: (context) =>
                    EditMatkul(matkulId: selectedMatkul.matkulId!),
              );
            },
            icon: const Icon(LucideIcons.squarePen),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InformasiMatkul(matkul: selectedMatkul),
                const SizedBox(height: 5),

                // Section Notes
                NoteMatkul(theme: theme, notes: notes),
                const SizedBox(height: 10),

                // Section Tasks
                TaskMatkul(theme: theme, tasks: tasks),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
