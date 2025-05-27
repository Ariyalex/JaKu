import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:jaku/provider/pdf_back.dart';
import 'package:jaku/routes/route_named.dart';

import '../models/jadwal.dart';

class JadwalkuliahController extends GetxController {
  final CollectionReference _matkulCollection =
      FirebaseFirestore.instance.collection('matkuls');

  final RxList<Matkul> allMatkul = <Matkul>[].obs;

  StreamSubscription? _matkulSubscription;

  final DayKuliahController _jadwalKuliahDay = DayKuliahController();

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

  void cleanupDays() {
    _jadwalKuliahDay.cleanupEmptyDays(this);
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
  void onClose() {
    cancelSubscription();
    super.onClose();
  }

  Future<void> getOnce() async {
    try {
      if (_userid == null) {
        return;
      }

      QuerySnapshot snapshot =
          await _matkulCollection.where("userId", isEqualTo: _userid).get();

      List<Matkul> data = snapshot.docs
          .map(
            (doc) =>
                Matkul.fromJson(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();

      data.sort(
        (a, b) {
          //1. urutkan berdasarkan hari
          int dayCompare = getDayIndex(a.day).compareTo(getDayIndex(b.day));
          if (dayCompare != 0) return dayCompare;

          //2. jam string ke waktu
          TimeOfDay parseTime(String? time) {
            if (time == null || time.isEmpty) {
              return const TimeOfDay(hour: 23, minute: 59); //default jika null
            }
            List<String> parts = time.split(":");
            return TimeOfDay(
                hour: int.parse(parts[0]), minute: int.parse(parts[1]));
          }

          TimeOfDay jamAwalA = parseTime(a.formattedJamAwal);
          TimeOfDay jamAwalB = parseTime(b.formattedJamAwal);

          //3. urutkan berdasarkan jam
          return (jamAwalA.hour * 60 + jamAwalA.minute)
              .compareTo(jamAwalB.hour * 60 + jamAwalB.minute);
        },
      );

      // Update the observable list with data from Firestore
      allMatkul.clear();
      allMatkul.addAll(data);

      Get.find<DayKuliahController>().groupByDay(this);
    } catch (error) {
      print("Error fetching products once: $error");
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

      allMatkul.add(Matkul(
        matkulId: docRef.id,
        matkul: matkul,
        kelas: kelas,
        formattedJamAwal: formattedJamAwal,
        formattedJamAkhir: formattedJamAkhir,
        dosen1: dosen1,
        dosen2: dosen2,
        room: room,
        day: day,
      ));
      print(allMatkul);
      print("matkul berhasil ditambah");
    } catch (error) {
      print("error adding product: $error");
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

      int index = allMatkul.indexWhere(
        (matkul) => matkul.matkulId == id,
      );
      if (index != -1) {
        allMatkul[index] = Matkul(
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
      }
    } catch (error) {
      print("error updating product: $error");
    }
  }

  Future<void> deleteMatkuls(
      String id, DayKuliahController JadwalKuliahDay) async {
    try {
      if (_userid == null) {
        return;
      }

      await _matkulCollection.doc(id).delete();

      allMatkul.removeWhere(
        (product) => product.matkulId == id,
      );

      JadwalKuliahDay.cleanupEmptyDays(this);
    } catch (error) {
      print("error deleting product: $error");
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
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
