import 'package:get/get.dart';
import '../../models/jadwal.dart';
import 'jadwal_kuliah_c.dart';

class HariKuliahC extends GetxController {
  final RxList<HariKuliah> jadwalHari = <HariKuliah>[].obs;
  final RxList<HariKuliah> jadwalHariTerurut = <HariKuliah>[].obs;

  List<String> hariList = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jum'at",
    "Sabtu",
    "Minggu",
  ];

  int getDayIndex(String day) {
    return hariList.indexOf(day);
  }

  // Fungsi untuk mendapatkan nama hari saat ini
  String getCurrentDay() {
    int todayIndex = DateTime.now().weekday - 1; // Senin = 0, Minggu = 6
    return hariList[todayIndex];
  }

  // Mengambil hari-hari unik dari jadwal mata kuliah
  void getUniqueDays(JadwalkuliahC jadwalKuliah) {
    // Bersihkan data sebelumnya
    jadwalHari.clear();
    jadwalHariTerurut.clear();

    // Ambil hari-hari unik dari matkul
    Set<String> uniqueDays = {};

    for (var matkul in jadwalKuliah.allMatkul) {
      if (matkul.day.isNotEmpty) {
        uniqueDays.add(matkul.day);
      }
    }

    // Tambahkan hari unik ke jadwalHari
    for (var day in uniqueDays) {
      var hariData = HariKuliah(matkulId: day, day: day);
      jadwalHari.add(hariData);
      jadwalHariTerurut.add(hariData);
    }

    jadwalHariTerurut.sort(
      (a, b) => getDayIndex(
        a.day.toString(),
      ).compareTo(getDayIndex(b.day.toString())),
    );

    // Urutkan berdasarkan indeks hari
    jadwalHari.sort(
      (a, b) => getDayIndex(
        a.day.toString(),
      ).compareTo(getDayIndex(b.day.toString())),
    );

    // Geser urutan agar dimulai dari hari ini
    int todayIndex = getDayIndex(getCurrentDay());
    jadwalHari.value = [
      ...jadwalHari.where(
        (hari) => getDayIndex(hari.day.toString()) >= todayIndex,
      ),
      ...jadwalHari.where(
        (hari) => getDayIndex(hari.day.toString()) < todayIndex,
      ),
    ];
  }

  List<HariKuliah> getOrderedDays() {
    return jadwalHariTerurut;
  }

  // Membersihkan semua data hari
  void clearAllDays() {
    jadwalHari.clear();
    jadwalHariTerurut.clear();
  }
}
