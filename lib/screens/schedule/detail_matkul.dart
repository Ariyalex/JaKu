import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers/jadwal_kuliah_c.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/models/jadwal.dart';
import 'package:jaku/models/matkul.dart';
import 'package:jaku/models/task.dart';
import 'package:jaku/widgets/schedule_widgets/edit_jadwal.dart';
import 'package:jaku/widgets/schedule_widgets/detail_matkul/informasi_matkul.dart';
import 'package:jaku/widgets/schedule_widgets/detail_matkul/note_matkul.dart';
import 'package:jaku/widgets/schedule_widgets/detail_matkul/task_matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailMatkul extends StatefulWidget {
  const DetailMatkul({super.key});

  @override
  State<DetailMatkul> createState() => _DetailMatkulState();
}

class _DetailMatkulState extends State<DetailMatkul> {
  final jadwalC = Get.find<JadwalkuliahC>();
  final noteC = Get.find<NoteControllers>();

  late Jadwal selectedSchedule;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final matkulId = Get.arguments;
    selectedSchedule = jadwalC.selectById(matkulId)!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Matkul? selectedMatkul = jadwalC.selectMatkulById(
      selectedSchedule.matkulId!,
    );

    final List<Task> tasks = [
      Task(
        id: "1",
        task: "Tugas ERD",
        status: false,
        taskDueDate: DateTime(2025, 8, 4, 10, 0),
        isStared: false,
        matkul: "IMK",
      ),
      Task(
        id: "2",
        task: "Presentasi UI/UX",
        status: true,
        taskDueDate: DateTime(2025, 8, 11, 13, 30),
        isStared: false,
        matkul: "IMK",
      ),
      Task(
        id: "3",
        task: "Kuis Bab 1-2",
        status: false,
        taskDueDate: DateTime(2025, 8, 18, 9, 0),
        isStared: false,
        matkul: "IMK",
      ),
      Task(
        id: "4",
        task: "Tugas Makalah",
        status: false,
        taskDueDate: DateTime(2025, 8, 25, 23, 59),
        isStared: false,
        matkul: "IMK",
      ),
      Task(
        id: "5",
        task: "Ujian Tengah Semester",
        status: false,
        taskDueDate: DateTime(2025, 9, 1, 8, 0),
        isStared: false,
        matkul: "IMK",
      ),
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
                backgroundColor: theme.colorScheme.surfaceContainer,
                builder: (context) =>
                    EditJadwal(jadwalId: selectedSchedule.id!),
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
                InformasiMatkul(schedule: selectedSchedule),
                const SizedBox(height: 5),

                // Section Notes
                Obx(() {
                  final notes = noteC.allNote
                      .where((note) => note.matkulId == selectedMatkul?.id)
                      .toList();

                  return NoteMatkul(
                    theme: theme,
                    notes: notes,
                    matkul: selectedMatkul!,
                  );
                }),

                const SizedBox(height: 10),

                // Section Tasks
                TaskMatkul(
                  theme: theme,
                  tasks: tasks,
                  matkul: selectedMatkul!.matkul,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
