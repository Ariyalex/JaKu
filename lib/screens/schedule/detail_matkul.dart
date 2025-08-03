import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/jadwal_kuliah_c.dart';
import 'package:jaku/screens/schedule/edit_matkul.dart';
import 'package:jaku/widgets/schedule_widget/detail_matkul/informasi_matkul.dart';
import 'package:jaku/widgets/schedule_widget/detail_matkul/note_matkul.dart';
import 'package:jaku/widgets/schedule_widget/detail_matkul/task_matkul.dart';
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

class DetailMatkul extends StatelessWidget {
  const DetailMatkul({super.key});

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahC>();

    final theme = Theme.of(context);

    final matkulId = Get.arguments as String;
    final selectedMatkul = allMatkulProvider.selectById(matkulId)!;

    // Dummy data untuk notes dan tasks (ganti dengan data asli nanti)
    final notes = [
      {"title": "ERD", "desc": "Materi minggu ini tentang ERD."},
      {"title": "Quiz", "desc": "Quiz minggu depan, belajar bab 2."},
      {"title": "UTS", "desc": "Persiapan UTS, review soal tahun lalu."},
      {"title": "Tugas", "desc": "Kumpulkan tugas sebelum Jumat."},
    ];
    final tasks = [
      {
        "title": "Tugas ERD",
        "done": false,
        "datetime": DateTime(2025, 8, 4, 10, 0), // Senin, 4 Agustus 2025, 10:00
      },
      {
        "title": "Upload tugas ke LMS",
        "done": true,
        "datetime": DateTime(2025, 8, 5, 0, 0), // Selasa, 5 Agustus 2025, 00:00
      },
      {
        "title": "Upload tugas ke LMS",
        "done": true,
        "datetime": DateTime(2025, 8, 5, 0, 0), // Selasa, 5 Agustus 2025, 00:00
      },
      {
        "title": "Upload tugas ke LMS",
        "done": true,
        "datetime": DateTime(2025, 8, 5, 0, 0), // Selasa, 5 Agustus 2025, 00:00
      },
      {
        "title": "Upload tugas ke LMS fasdfbbg fasdfbkj fasbdf",
        "done": true,
        "datetime": DateTime(2025, 8, 5, 0, 0), // Selasa, 5 Agustus 2025, 00:00
      },
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
                builder: (context) => EditMatkul(matkulId: matkulId),
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
