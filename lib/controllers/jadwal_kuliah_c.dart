import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/services/jadwal_kuliah_local.dart';
import 'package:jaku/controllers/hari_kuliah_c.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/theme/theme.dart';
import 'package:uuid/uuid.dart';

import '../models/jadwal.dart';

var uuid = const Uuid();

class JadwalkuliahC extends GetxController {
  //text controller
  final matkulC = TextEditingController();
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

  final Set<String> kelasList = {"A", "B", "C", "D"};

  final color = AppTheme.dark;

  final RxList<Matkul> allMatkul = <Matkul>[].obs;

  int get jumlahMatkul => allMatkul.length;

  Matkul? selectById(String id) {
    if (allMatkul.isEmpty) {
      debugPrint("data kosong, pastikan sudah memanggil getonce");
      return null;
    }
    return allMatkul.firstWhere(
      (element) => element.matkulId == id,
      orElse: () => throw Exception("Matkul degnan ID $id tidak ditemaukan"),
    );
  }

  // Fungsi untuk mendapatkan indeks hari dalam seminggu
  int getDayIndex(String day) {
    return hariList.indexOf(day);
  }

  void clearData() {
    allMatkul.clear();
  }

  @override
  void onInit() async {
    super.onInit();
    await JadwalKuliahLocal.initL();
    loadFromLocalStorage();
  }

  //fungsi mebandingkan dua matkul saat sorting
  int _compareMatkul(Matkul a, Matkul b) {
    // 1. urutkan berdasarkan hari
    int dayCompare = getDayIndex(a.day).compareTo(getDayIndex(b.day));
    if (dayCompare != 0) return dayCompare;

    //2. jam string ke waktu
    TimeOfDay parseTime(String? time) {
      if (time == null || time.isEmpty) {
        return const TimeOfDay(hour: 23, minute: 59);
      }
      List<String> parts = time.split(":");
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    TimeOfDay jamAwalA = parseTime(a.formattedJamAwal);
    TimeOfDay jamAwalB = parseTime(b.formattedJamAwal);

    //urutkan berdasarkan jam
    return (jamAwalA.hour * 60 + jamAwalA.minute)
        .compareTo(jamAwalB.hour * 60 + jamAwalB.minute);
  }

  //fungsi untuk memuat data dari local storage
  Future<void> loadFromLocalStorage() async {
    isLoading.value = true;
    errorMsg.value = '';
    try {
      List<Matkul> localData = JadwalKuliahLocal.getAllMatkulsL();

      if (localData.isNotEmpty) {
        localData.sort((a, b) => _compareMatkul(a, b));
        allMatkul.clear();
        allMatkul.addAll(localData);

        Get.find<HariKuliahC>().getUniqueDays(this);
      }
    } catch (e) {
      print("error loading from local storage: $e");
      errorMsg.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMatkuls() async {
    try {
      Matkul newMatkul = Matkul(
        matkulId: uuid.v4(),
        matkul: matkulC.text,
        kelas: kelas.value,
        formattedJamAwal: jamAwal.value!,
        formattedJamAkhir: jamAkhir.value,
        dosen1: dosen1C.text,
        dosen2: dosen2C.text,
        room: ruanganC.text,
        day: hari.value!,
      );

      //update list lokal
      allMatkul.add(newMatkul);

      //simpan ke local storage
      await JadwalKuliahLocal.saveMatkulL(newMatkul);

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

  Future<void> updateMatkul(String id) async {
    try {
      //buat objek matkul baru dengan data yang diudate
      Matkul updatedMatkul = Matkul(
        matkulId: id,
        matkul: matkulC.text,
        kelas: kelas.value,
        formattedJamAwal: jamAwal.value!,
        formattedJamAkhir: jamAkhir.value,
        dosen1: dosen1C.text,
        dosen2: dosen2C.text,
        room: ruanganC.text,
        day: hari.value!,
      );

      int index = allMatkul.indexWhere(
        (matkul) => matkul.matkulId == id,
      );

      if (index != -1) {
        allMatkul[index] = updatedMatkul;

        //update di local storage
        await JadwalKuliahLocal.saveMatkulL(updatedMatkul);

        // Perbarui daftar hari unik setelah memperbarui matkul
        try {
          final dayController = Get.find<HariKuliahC>();
          dayController.getUniqueDays(this);
        } catch (e) {
          print("Tidak dapat memperbarui daftar hari: $e");
          rethrow;
        }
      }
    } catch (error) {
      print("error updating product: $error");
      rethrow;
    }
  }

  Future<void> deleteMatkuls(String id, HariKuliahC dayKuliahController) async {
    try {
      //hapus dari list local
      allMatkul.removeWhere(
        (product) => product.matkulId == id,
      );

      //hapus dari local storage
      await JadwalKuliahLocal.deleteMatkulL(id);

      // Perbarui daftar hari unik setelah menghapus matkul
      dayKuliahController.getUniqueDays(this);
    } catch (error) {
      print("error deleting product: $error");

      Get.snackbar(
        'Error',
        'Gagal menghapus mata kuliah: $error',
        snackPosition: SnackPosition.TOP,
        backgroundColor: color.colorScheme.error,
        colorText: color.colorScheme.onError,
      );
    }
  }

  // Menghapus semua data jadwal kuliah dari Firestore dan controller lokal
  Future<void> clearAllData() async {
    try {
      // Tampilkan loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Dapatkan semua controller yang diperlukan
      final hariKuliahProvider = Get.find<HariKuliahC>();

      // Hapus data pada controller jadwal
      clearData();

      //hapus data dari local storage
      await JadwalKuliahLocal.deleteAllMatkulL();

      // Perbarui tampilan hari
      hariKuliahProvider.clearAllDays();

      // Tutup dialog loading
      Get.back();

      // Tampilkan notifikasi sukses
      Get.snackbar(
        'Berhasil',
        'Semua data berhasil dihapus',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Kembali ke halaman home
      Get.offNamed(RouteNamed.homePage);
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
}
