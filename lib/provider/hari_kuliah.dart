import 'package:get/get.dart';
import '../models/jadwal.dart';
import './jadwal_kuliah.dart';

class DayKuliahController extends GetxController {
  final RxList<HariKuliah> jadwalHari = <HariKuliah>[].obs;

  int getDayIndex(String day) {
    List<String> hariList = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jum'at",
      "Sabtu",
      "Minggu",
    ];
    return hariList.indexOf(day);
  }

  // Fungsi untuk mendapatkan nama hari saat ini
  String getCurrentDay() {
    List<String> hariList = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jum'at",
      "Sabtu",
      "Minggu"
    ];
    int todayIndex = DateTime.now().weekday - 1; // Senin = 0, Minggu = 6
    return hariList[todayIndex];
  }

  //mengelompokkan mata kuliah berdasarkan hari
  void groupByDay(JadwalkuliahController jadwalKuliah) {
    //bershikan data sebelumnya
    jadwalHari.clear();

    //buat map untuk mengelompokkan berdasarkan hari
    Map<String, List<Matkul>> groupedMatkul = {};

    for (var matkul in jadwalKuliah.allMatkul) {
      if (matkul.day != null) {
        groupedMatkul.putIfAbsent(matkul.day!, () => []).add(matkul);
      }
    }

    //masukkan hasil ke dalam _jadwalHari
    groupedMatkul.forEach(
      (day, matkulList) {
        jadwalHari.add(HariKuliah(
          matkulId: day, //gunakan nama hari sebagai ID unik
          day: day,
        ));
      },
    );

    //urutkan berdasar index hari
    jadwalHari.sort(
      (a, b) => getDayIndex(a.day.toString())
          .compareTo(getDayIndex(b.day.toString())),
    );

    // Geser urutan agar dimulai dari hari ini
    int todayIndex = getDayIndex(getCurrentDay());
    jadwalHari.value = [
      ...jadwalHari
          .where((hari) => getDayIndex(hari.day.toString()) >= todayIndex),
      ...jadwalHari
          .where((hari) => getDayIndex(hari.day.toString()) < todayIndex),
    ];
  }

  void cleanupEmptyDays(JadwalkuliahController jadwalKuliah) {
    Set<String> reminingDays =
        jadwalKuliah.allMatkul.map((matkul) => matkul.day!).toSet();
    print(reminingDays);

    //hapus hari yg tidak ada di reminingDays
    jadwalHari.removeWhere(
      (hari) => !reminingDays.contains(hari.day),
    );
  }

  // Membersihkan semua data hari
  void clearAllDays() {
    jadwalHari.clear();
  }
}
