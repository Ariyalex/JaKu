import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
import 'package:jaku/models/matkul.dart';
import 'package:jaku/services/jadwal_service.dart';
import 'package:jaku/controllers/jadwal_controllers/hari_kuliah_c.dart';
import 'package:jaku/services/matkul_service.dart';
import 'package:jaku/theme/theme.dart';
import 'package:uuid/uuid.dart';

import '../../models/jadwal.dart';

var uuid = const Uuid();

String getInitials(String kalimat) {
  final words = kalimat
      .split(' ')
      .where((word) => word.isNotEmpty && word.toLowerCase() != 'dan')
      .toList();

  if (words.length <= 2) {
    // Kembalikan kalimat asli dengan kapitalisasi awal tiap kata
    return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  // Jika lebih dari 2 kata, ambil huruf awal tiap kata
  return words.map((word) => word[0].toUpperCase()).join();
}

class JadwalkuliahC extends GetxController {
  //text controller
  final matkulNameC = TextEditingController();
  final dosen1C = TextEditingController();
  final dosen2C = TextEditingController();
  final ruanganC = TextEditingController();
  RxnString hari = RxnString();
  RxnString kelas = RxnString();
  RxnString jamAwal = RxnString();
  RxnString jamAkhir = RxnString();

  //loading state
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;

  List<String> hariList = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jum'at",
    "Sabtu",
    "Minggu",
  ];

  final Set<String> kelasList = {"A", "B", "C", "D", "E", "F"};

  final color = AppTheme.dark;

  final RxList<Jadwal> allSchedule = <Jadwal>[].obs;

  int get jumlahSchedule => allSchedule.length;

  Jadwal? selectById(String id) {
    if (allSchedule.isEmpty) {
      debugPrint("data kosong, pastikan sudah memanggil getonce");
      return null;
    }
    return allSchedule.firstWhere(
      (element) => element.id == id,
      orElse: () => throw Exception("Jadwal degnan ID $id tidak ditemaukan"),
    );
  }

  // Fungsi untuk mendapatkan indeks hari dalam seminggu
  int getDayIndex(String day) {
    return hariList.indexOf(day);
  }

  void clearData() {
    allSchedule.clear();
  }

  @override
  void onInit() async {
    super.onInit();
    loadSchedule();
  }

  //fungsi mebandingkan dua matkul saat sorting
  int _compareMatkul(Jadwal a, Jadwal b) {
    // 1. urutkan berdasarkan hari
    int dayCompare = getDayIndex(a.day).compareTo(getDayIndex(b.day));
    if (dayCompare != 0) return dayCompare;

    //2. jam string ke waktu
    TimeOfDay parseTime(String? time) {
      if (time == null || time.isEmpty) {
        return const TimeOfDay(hour: 23, minute: 59);
      }
      List<String> parts = time.split(":");
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    TimeOfDay jamAwalA = parseTime(a.formattedJamAwal);
    TimeOfDay jamAwalB = parseTime(b.formattedJamAwal);

    //urutkan berdasarkan jam
    return (jamAwalA.hour * 60 + jamAwalA.minute).compareTo(
      jamAwalB.hour * 60 + jamAwalB.minute,
    );
  }

  //fungsi untuk memuat data dari local storage
  Future<void> loadSchedule() async {
    isLoading.value = true;
    errorMsg.value = '';
    try {
      // Load schedule
      List<Jadwal> localData = JadwalService.getAllScheduleService();

      if (localData.isNotEmpty) {
        localData.sort((a, b) => _compareMatkul(a, b));
        allSchedule.clear();
        allSchedule.addAll(localData);

        Get.find<HariKuliahC>().getUniqueDays(this);
      }

      //remove unused matkul
      await removeUnusedMatkul();
    } catch (e) {
      print("error loading from local storage: $e");
      errorMsg.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSchedules() async {
    try {
      final matkulC = Get.find<MatkulController>();
      //check if there is matkul in allmatkul
      String matkulName = matkulNameC.text.trim();
      Matkul? existing = matkulC.allMatkul.firstWhereOrNull(
        (item) => item.matkul == matkulName,
      );

      //if not, add matkul to allmatkul
      String matkulId;
      if (existing == null) {
        matkulId = uuid.v4();
        final newMatkul = Matkul(
          id: matkulId,
          matkul: matkulName,
          abbreviation: getInitials(matkulName),
        );
        matkulC.allMatkul.add(newMatkul);
        await MatkulService.saveMatkulService(newMatkul);
      } else {
        matkulId = existing.id!;
      }

      //new schedule
      Jadwal newSchedule = Jadwal(
        id: uuid.v4(),
        matkulId: matkulId,
        matkul: matkulName,
        kelas: kelas.value,
        formattedJamAwal: jamAwal.value!,
        formattedJamAkhir: jamAkhir.value,
        dosen1: dosen1C.text,
        dosen2: dosen2C.text,
        room: ruanganC.text,
        day: hari.value!,
      );

      //update list
      allSchedule.add(newSchedule);

      //save to hive
      await JadwalService.saveScheduleService(newSchedule);

      try {
        final dayController = Get.find<HariKuliahC>();
        dayController.getUniqueDays(this);
      } catch (e) {
        print("Tidak dapat memperbarui daftar hari: $e");
        rethrow;
      }

      print("matkul berhasil ditambah");
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateSchedule(String id) async {
    try {
      final matkulC = Get.find<MatkulController>();
      //check if there is matkul in allmatkul
      String matkulName = matkulNameC.text.trim();
      Matkul? existing = matkulC.allMatkul.firstWhereOrNull(
        (item) => item.matkul == matkulName,
      );

      //if not, add matkul to allmatkul
      String matkulId;
      if (existing == null) {
        matkulId = uuid.v4();
        final newMatkul = Matkul(
          id: matkulId,
          matkul: matkulName,
          abbreviation: getInitials(matkulName),
        );
        matkulC.allMatkul.add(newMatkul);
        await MatkulService.saveMatkulService(newMatkul);
      } else {
        matkulId = existing.id!;
      }

      //buat objek matkul baru dengan data yang diudate
      Jadwal updatedSchedule = Jadwal(
        id: id,
        matkul: matkulName,
        kelas: kelas.value,
        formattedJamAwal: jamAwal.value!,
        formattedJamAkhir: jamAkhir.value,
        dosen1: dosen1C.text,
        dosen2: dosen2C.text,
        room: ruanganC.text,
        day: hari.value!,
      );

      int index = allSchedule.indexWhere((matkul) => matkul.id == id);

      if (index != -1) {
        allSchedule[index] = updatedSchedule;

        //update di local storage
        await JadwalService.saveScheduleService(updatedSchedule);

        // Perbarui daftar hari unik setelah memperbarui matkul
        try {
          final dayController = Get.find<HariKuliahC>();
          dayController.getUniqueDays(this);
        } catch (e) {
          print("Tidak dapat memperbarui daftar hari: $e");
          rethrow;
        }
      }

      await removeUnusedMatkul();
    } catch (error) {
      print("error updating product: $error");
      rethrow;
    }
  }

  Future<void> deleteSchedule(
    String id,
    HariKuliahC dayKuliahController,
  ) async {
    try {
      //hapus dari list local
      allSchedule.removeWhere((product) => product.id == id);

      //hapus dari local storage
      await JadwalService.deleteScheduleService(id);

      // Perbarui daftar hari unik setelah menghapus matkul
      dayKuliahController.getUniqueDays(this);

      await removeUnusedMatkul();
    } catch (error) {
      print("error deleting matkul: $error");

      rethrow;
    }
  }

  // Menghapus semua data jadwal kuliah dari Firestore dan controller lokal
  Future<void> clearAllSchedule() async {
    try {
      // Tampilkan loading indicator
      final matkulC = Get.find<MatkulController>();
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Dapatkan semua controller yang diperlukan
      final hariKuliahProvider = Get.find<HariKuliahC>();

      // Hapus data pada controller jadwal
      clearData();

      //hapus data dari local storage
      await JadwalService.deleteAllScheduleService();

      // Perbarui tampilan hari
      hariKuliahProvider.clearAllDays();

      // Hapus semua data matkul dari controller dan local storage
      matkulC.allMatkul.clear();
      await MatkulService.deleteAllMatkulService();

      await removeUnusedMatkul();

      // Tutup dialog loading
      Get.back();

      // Tampilkan notifikasi sukses
      Get.snackbar(
        'Berhasil',
        'Semua data berhasil dihapus',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      // Tutup dialog loading jika terjadi error
      Get.back();

      // Tampilkan pesan error
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat menghapus data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color.colorScheme.error,
        colorText: color.colorScheme.onError,
      );
    }
  }

  Future<void> removeUnusedMatkul() async {
    try {
      final matkulC = Get.find<MatkulController>();
      // Ambil semua matkulId yang dipakai di jadwal
      final usedMatkulIds = allSchedule
          .map((jadwal) => jadwal.matkulId)
          .toSet();

      // Cari matkul yang tidak dipakai
      final unusedMatkul = matkulC.allMatkul
          .where((matkul) => !usedMatkulIds.contains(matkul.id))
          .toList();

      for (final matkul in unusedMatkul) {
        matkulC.allMatkul.remove(matkul);
        await MatkulService.deleteMatkulService(matkul.id!);
      }

      print(
        "Matkul tidak terpakai berhasil dihapus: ${unusedMatkul.map((m) => m.matkul).join(', ')}",
      );
    } catch (e) {
      print("Error menghapus matkul tidak terpakai: $e");
      rethrow;
    }
  }
}
