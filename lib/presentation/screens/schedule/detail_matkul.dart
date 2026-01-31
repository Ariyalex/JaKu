import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/presentation/controllers/jadwal_controllers/jadwal_kuliah_c.dart';
import 'package:jaku/presentation/controllers/matkul_controllers.dart';
import 'package:jaku/presentation/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/domain/models/matkul_schedule.dart';
import 'package:jaku/domain/models/matkul.dart';
import 'package:jaku/presentation/widgets/schedule_widgets/edit_jadwal.dart';
import 'package:jaku/presentation/widgets/schedule_widgets/detail_matkul/informasi_matkul.dart';
import 'package:jaku/presentation/widgets/schedule_widgets/detail_matkul/note_matkul.dart';
import 'package:jaku/presentation/widgets/schedule_widgets/detail_matkul/task_matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailMatkul extends StatefulWidget {
  const DetailMatkul({super.key});

  @override
  State<DetailMatkul> createState() => _DetailMatkulState();
}

class _DetailMatkulState extends State<DetailMatkul> {
  final jadwalC = Get.find<JadwalkuliahC>();
  final matkulC = Get.find<MatkulController>();
  final noteC = Get.find<NoteControllers>();

  late MatkulSchedule selectedSchedule;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final matkulId = Get.arguments;
    if (matkulId != null) {
      selectedSchedule = jadwalC.selectById(matkulId)!;
      print("ke detail matkul: $matkulId");
    } else {
      print("gagal ke detail matkul");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Matkul? selectedMatkul = matkulC.selectMatkulById(
      selectedSchedule.matkulId!,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                  matkulId: selectedMatkul!.id!,
                  matkul: selectedMatkul.name,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
