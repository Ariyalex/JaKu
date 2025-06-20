import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/local_storage/jadwal_kuliah_local.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:jaku/provider/pdf_back.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/theme/theme.dart';
// import 'package:uuid/uuid.dart';

import '../models/jadwal.dart';

// var uuid = const Uuid();

class JadwalkuliahController extends GetxController {
  final color = AppTheme.dark;

  final CollectionReference _matkulCollection =
      FirebaseFirestore.instance.collection('matkuls');

  final RxList<Matkul> allMatkul = <Matkul>[].obs;

  StreamSubscription? _matkulSubscription;

  String? _userid;

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

  //gunakan firebase
  void clearData() {
    allMatkul.clear();
  }

  Future<void> cancelSubscription() async {
    await _matkulSubscription?.cancel();
    _matkulSubscription = null;
  }

  void updateAuthData(User? user) async {
    if (user != null) {
      _userid = user.uid;
    } else {
      _userid = null;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    JadwalKuliahLocal.initL();
  }

  @override
  void onClose() {
    cancelSubscription();
    super.onClose();
  }

  Future<void> getOnce() async {
    try {
      if (_userid == null) {
        _loadFromLocalStorage();
        return;
      }

      try {
        QuerySnapshot snapshot =
            await _matkulCollection.where("userId", isEqualTo: _userid).get();

        List<Matkul> data = snapshot.docs
            .map(
              (doc) =>
                  Matkul.fromJson(doc.id, doc.data() as Map<String, dynamic>),
            )
            .toList();

        data.sort((a, b) => _compareMatkul(a, b));

        // Update the observable list with data from Firestore
        allMatkul.clear();
        allMatkul.addAll(data);

        //simpan data ke local storage
        await JadwalKuliahLocal.saveAllMatkulL(data);

        Get.find<DayKuliahController>().getUniqueDays(this);
      } catch (e) {
        print("errror fetching from firebase: $e");
        _loadFromLocalStorage();
      }
    } catch (error) {
      print("Error fetching products once: $error");
      _loadFromLocalStorage();
    }
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

  //fungsi untuk memuad data dari local storage
  void _loadFromLocalStorage() {
    try {
      List<Matkul> localData = JadwalKuliahLocal.getAllMatkulsL();

      if (localData.isNotEmpty) {
        localData.sort((a, b) => _compareMatkul(a, b));
        allMatkul.clear();
        allMatkul.addAll(localData);

        Get.find<DayKuliahController>().getUniqueDays(this);
      }
    } catch (e) {
      print("error loading from local storage: $e");
    }
  }

  Future<void> addMatkuls(
      String matkul,
      String kelas,
      String formattedJamAwal,
      String formattedJamAkhir,
      String dosen1,
      String dosen2,
      String room,
      String day) async {
    try {
      //menambahkan ke firebase
      if (_userid == null) {
        return;
      }

      DocumentReference docRef = await _matkulCollection.add({
        "matkul": matkul,
        "kelas": kelas,
        "formattedJamAwal": formattedJamAwal,
        "formattedJamAkhir": formattedJamAkhir,
        "dosen1": dosen1,
        "dosen2": dosen2,
        "room": room,
        "day": day,
        "userId": _userid,
      });

      Matkul newMatkul = Matkul(
        matkulId: docRef.id,
        matkul: matkul,
        kelas: kelas,
        formattedJamAwal: formattedJamAwal,
        formattedJamAkhir: formattedJamAkhir,
        dosen1: dosen1,
        dosen2: dosen2,
        room: room,
        day: day,
      );

      //update list lokal
      allMatkul.add(newMatkul);

      //simpan ke local storage
      await JadwalKuliahLocal.saveMatkulL(newMatkul);

      try {
        final dayController = Get.find<DayKuliahController>();
        dayController.getUniqueDays(this);
      } catch (e) {
        print("Tidak dapat memperbarui daftar hari: $e");
      }

      print("matkul berhasil ditambah");
    } catch (error) {
      print("error adding product: $error");

      Get.snackbar(
        'Error',
        'Gagal menambahkan mata kuliah: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color.colorScheme.error,
        colorText: color.colorScheme.onError,
      );
    }
  }

  Future<void> updateMatkul(
      String id,
      String matkul,
      String kelas,
      String formattedJamAwal,
      String formattedJamAkhir,
      String dosen1,
      String dosen2,
      String room,
      String day) async {
    try {
      if (_userid == null) {
        return;
      }

      await _matkulCollection.doc(id).update({
        "matkul": matkul,
        "kelas": kelas,
        "formattedJamAwal": formattedJamAwal,
        "formattedJamAkhir": formattedJamAkhir,
        "dosen1": dosen1,
        "dosen2": dosen2,
        "room": room,
        "day": day,
      });

      //buat objek matkul baru dengan data yang diudate
      Matkul updatedMatkul = Matkul(
        matkulId: id,
        matkul: matkul,
        kelas: kelas,
        formattedJamAwal: formattedJamAwal,
        formattedJamAkhir: formattedJamAkhir,
        dosen1: dosen1,
        dosen2: dosen2,
        room: room,
        day: day,
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
          final dayController = Get.find<DayKuliahController>();
          dayController.getUniqueDays(this);
        } catch (e) {
          print("Tidak dapat memperbarui daftar hari: $e");
        }
      }
    } catch (error) {
      print("error updating product: $error");

      Get.snackbar(
        'Error',
        'Gagal memperbarui mata kuliah: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color.colorScheme.error,
        colorText: color.colorScheme.onError,
      );
    }
  }

  Future<void> deleteMatkuls(
      String id, DayKuliahController dayKuliahController) async {
    try {
      if (_userid == null) {
        return;
      }

      //hapus matkul dari firebase
      await _matkulCollection.doc(id).delete();

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
        snackPosition: SnackPosition.BOTTOM,
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
      final pdfBack = Get.find<PdfBack>();
      final hariKuliahProvider = Get.find<DayKuliahController>();

      // Hapus data dari Firebase
      await pdfBack.clearUserData();

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
        snackPosition: SnackPosition.BOTTOM,
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
