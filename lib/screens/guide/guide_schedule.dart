import 'package:flutter/material.dart';
import 'package:jaku/models/tutorial_step.dart';
import 'package:jaku/widgets/guide/info_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GuideGeneral extends StatelessWidget {
  static const routeNamed = '/guide-pdf';
  const GuideGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample tutorial steps
    final List<TutorialStep> infoGuide = [
      TutorialStep(
        title: 'Add Matkul',
        description:
            'Gunakan tombol add di pojok kiri atas untuk membuka add page. Matkul harus beirisi:\nNama Matkul, Hari, dan Jam Awal',
        icon: Icons.add,
      ),
      TutorialStep(
        title: 'Add Otomatis',
        description:
            "Fitur ini hanya diperuntukkan kepada mahasiswa UIN SUKA.\nFitur ini memerlukan file pdf jadwal kuliah yang didownload di SIA UIN SUKA. Tombol ada pada di Add Matkul screen, di kanan atas layar",
        icon: Icons.picture_as_pdf,
      ),
      TutorialStep(
        title: 'Note',
        description:
            'Kamu bisa membuat catatan dan mengelompokannnya berdasarkan matkul',
        icon: LucideIcons.notebook,
      ),
      TutorialStep(
        title: 'To-do List',
        description:
            'Kamu bisa membuat to-do list dan menjadwalkannya, kamu juga bisa mengelompokkan task berdasarkan matkul atau membuat grup sendiri',
        icon: Icons.task_alt,
      ),

      TutorialStep(
        title: 'Pilih Tampilan',
        description:
            'Di atas layar terdapat tombol untuk mengganti tampilan card atau tampilan table. Pilih sesuai preferensimu',
        icon: Icons.view_comfortable,
      ),
      TutorialStep(
        title: 'Tema Gelap dan Terang',
        description:
            'Kamu bisa mengganti tema gelap atau terang sesuai preferensi kamu',
        icon: Icons.color_lens_outlined,
      ),
      TutorialStep(
        title: 'Offline',
        description:
            'Matkul yang ditambahkan akan disimpan di local storage, sehingga jika kamu tidak perlu memikirkan tentang sinyal atau kuota',
        icon: Icons.wifi_off,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Info")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Apa Itu Jaku?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Jaku adalah aplikasi asisten belajar mahasiswa yang menawarkan integrasi jadwal, note, dan tugas kuliah dalam satu aplikasi.\nBeberapa fitur yang ditawarkan jaku antara lain: ',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...List.generate(
            infoGuide.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InfoCard(tutorialStep: infoGuide[index]),
            ),
          ),
        ],
      ),
    );
  }
}
