import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/models/note.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/widgets/note_widgets/note_global.dart';
import 'package:jaku/widgets/note_widgets/search_textfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteDashboard extends StatelessWidget {
  const NoteDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Note> notes = [
      Note(
        id: "1",
        title: "Catatan Pertemuan 1",
        desc:
            "Bahas pengenalan mata kuliah dan kontrak kuliah. Dosen menjelaskan tujuan pembelajaran, metode penilaian, serta aturan selama perkuliahan berlangsung.",
        matkul: "Metode Pengembangan Perangkat Lunak",
      ),
      Note(
        id: "2",
        title: "Catatan Pertemuan 2",
        desc:
            "Diskusi tentang user interface dan user experience. Materi meliputi perbedaan UI dan UX, serta contoh implementasinya pada aplikasi sehari-hari.",
        matkul: "Basis Data",
      ),
      Note(
        id: "3",
        title: "Reminder Quiz",
        desc:
            "Akan ada quiz minggu depan, materi bab 1-2. Persiapkan diri dengan membaca ulang materi dan latihan soal.",
        matkul: "Bahasa Indonesia",
      ),
      Note(
        id: "4",
        title: "Catatan Pertemuan 3",
        desc:
            "Pembahasan prototyping dan wireframe. Dosen memberikan contoh pembuatan wireframe sederhana menggunakan kertas.",
        matkul: "IMK",
      ),
      Note(
        id: "5",
        title: "Catatan Pertemuan 4",
        desc:
            "Studi kasus aplikasi mobile. Mahasiswa diminta menganalisis aplikasi populer dari sisi UI/UX.",
        matkul: "IMK",
      ),
      Note(
        id: "6",
        title: "Reminder Tugas",
        desc:
            "Kumpulkan tugas sebelum Jumat. Tugas berupa pembuatan wireframe aplikasi sederhana.",
        matkul: "IMK",
      ),
      Note(
        id: "7",
        title: "Catatan Pertemuan 5",
        desc:
            "Diskusi usability testing. Dosen menjelaskan metode pengujian dan pentingnya feedback pengguna.",
        matkul: "IMK",
      ),
      Note(
        id: "8",
        title: "Catatan Pertemuan 6",
        desc:
            "Evaluasi hasil usability testing. Mahasiswa mempresentasikan hasil pengujian aplikasi masing-masing.",
        matkul: "IMK",
      ),
      Note(
        id: "9",
        title: "Reminder Presentasi",
        desc:
            "Presentasi kelompok minggu depan. Setiap kelompok wajib menyiapkan slide dan demo aplikasi.",
        matkul: "IMK",
      ),
      Note(
        id: "10",
        title: "Catatan Pertemuan 7",
        desc:
            "Pembahasan heuristic evaluation. Dosen memperkenalkan 10 heuristik Nielsen dan contoh penerapannya.",
        matkul: "IMK",
      ),
      Note(
        id: "11",
        title: "Catatan Pertemuan 8",
        desc:
            "Diskusi desain sistem. Materi meliputi flowchart, diagram alur, dan struktur navigasi aplikasi.",
        matkul: "IMK",
      ),
      Note(
        id: "12",
        title: "Reminder UTS",
        desc:
            "UTS akan dilaksanakan tanggal 15. Materi meliputi seluruh topik yang telah dibahas hingga pertemuan ke-8.",
        matkul: "IMK",
      ),
      Note(
        id: "13",
        title: "Catatan Pertemuan 9",
        desc:
            "Review materi sebelum UTS. Sesi tanya jawab dan pembahasan soal-soal latihan.",
        matkul: "IMK",
      ),
      Note(
        id: "14",
        title: "Catatan Pertemuan 10",
        desc:
            "Pembahasan hasil UTS. Dosen memberikan umpan balik dan membahas soal yang dianggap sulit.",
        matkul: "IMK",
      ),
      Note(
        id: "15",
        title: "Reminder Tugas Akhir",
        desc:
            "Tugas akhir dikumpulkan akhir bulan. Pastikan seluruh persyaratan dan dokumentasi sudah lengkap.",
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SearchTextfield(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 12,
                  right: 12,
                  left: 12,
                  bottom: 60,
                ),
                child: notes.isNotEmpty
                    ? NoteGlobal(notes: notes)
                    : Center(
                        child: Column(
                          children: [
                            Text(
                              "Tidak ada note",
                              style: theme.textTheme.bodyLarge,
                            ),
                            Container(
                              margin: EdgeInsets.all(12),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset("images/malas.gif"),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteNamed.addNote);
        },
        shape: const CircleBorder(),
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
