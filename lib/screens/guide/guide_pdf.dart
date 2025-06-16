import 'package:flutter/material.dart';
import 'package:jaku/models/tutorial_step.dart';

class GuidePdf extends StatelessWidget {
  static const routeNamed = '/guide-pdf';
  const GuidePdf({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample tutorial steps
    final List<TutorialStep> tutorialSteps = [
      TutorialStep(
        title: 'Kunjungi SIA UIN SUKA',
        description:
            'Buka SIA di \n"https://akademik.uin-suka.ac.id"\n lalu login',
        icon: Icons.login,
      ),
      TutorialStep(
        title: 'Cari Menu "Jadwal Kuliah"',
        description: 'Klik Perkuliahan, lalu klik Jadwal Kuliah.',
        icon: Icons.menu_open,
      ),
      TutorialStep(
        title: 'Cetak Jadwal',
        description:
            'Di bawah tabel jadwal, terdapat tombol "Cetak Jadwal Kuliah", klik lalu download pdf.',
        icon: Icons.download_for_offline_outlined,
      ),
      TutorialStep(
        title: 'Buka JaKu',
        description: 'Buka aplikasi JaKu dan pilih opsi "PDF Otomation".',
        icon: Icons.school_outlined,
      ),
      TutorialStep(
        title: 'Pilih File',
        description: 'Tekan "Pilih PDF" lalu pilih pdf yang didownload tadi',
        icon: Icons.fact_check,
      ),
      TutorialStep(
        title: 'Proses Jadwal',
        description:
            'Klik tombol "Upload, Proses & Simpan", akan muncul jumlah matkul yang berhasil ditambahkan',
        icon: Icons.done_all,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guide Otomation"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Panduan Langkah-Langkah',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Ikuti langkah-langkah untuk upload Matkul menggunakan PDF Otomation:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            tutorialSteps.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TutorialStepCard(
                step: index + 1,
                tutorialStep: tutorialSteps[index],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Catatan: Jika Anda mengalami kesulitan dalam mengikuti langkah-langkah di atas, silakan hubungi developer.',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialStepCard extends StatelessWidget {
  final int step;
  final TutorialStep tutorialStep;

  const TutorialStepCard({
    super.key,
    required this.step,
    required this.tutorialStep,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                '$step',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (tutorialStep.icon != null) ...[
                        Icon(tutorialStep.icon),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        tutorialStep.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tutorialStep.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
