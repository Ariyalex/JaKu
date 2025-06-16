import 'package:flutter/material.dart';
import 'package:jaku/models/tutorial_step.dart';
import 'package:jaku/widgets/guide/info_card.dart';

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
        title: 'Edit Matkul',
        description:
            'Di bawah tabel jadwal, terdapat tombol "Cetak Jadwal Kuliah", klik lalu download pdf.',
        icon: Icons.edit,
      ),
      TutorialStep(
        title: 'Delete Matkul',
        description:
            'Tekan matkul untuk memasuki Edit page, Matkul yang diedit harus berisi:\nNama Matkul, Hari, Jam awal.',
        icon: Icons.delete,
      ),
      TutorialStep(
        title: 'Add Otomatis',
        description:
            "Fitur ini hanya diperuntukkan kepada mahasiswa UIN SUKA.\nFitur ini memerlukan file pdf jadwal kuliah yang didownload di SIA UIN SUKA. Tombol ada pada di Add Matkul screen, di kanan atas layar",
        icon: Icons.picture_as_pdf,
      ),
      TutorialStep(
        title: 'Pilih Tampilan',
        description:
            'Di atas layar terdapat tombol untuk mengganti tampilan card atau tampilan table. Pilih sesuai preferensimu',
        icon: Icons.view_comfortable,
      ),
      TutorialStep(
        title: 'Offline Mode',
        description:
            'Matkul yang ditambahkan akan disimpan di firebase dan juga local storage, sehingga jika kamu sedang offline, maka Jaku akan mengambil matkul dari local storage. Jika sedang online maka Jaku akan mengambil matkul dari firebase',
        icon: Icons.wifi_off,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Apa Itu Jaku?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Jaku adalah aplikasi jadwal kuliah yang menawarkan tampilan jadwal yang bersih dan rapi serta memudahkan dalam melihat jadwal.\nBeberapa fitur yang ditawarkan jaku antara lain: ',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...List.generate(
            infoGuide.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InfoCard(
                tutorialStep: infoGuide[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
