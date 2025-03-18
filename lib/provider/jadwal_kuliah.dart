import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jaku/provider/hari_kuliah.dart';

import '../models/jadwal.dart';

class Jadwalkuliah with ChangeNotifier {
  StreamSubscription? _matkulSubscription;

  List<Matkul> _allMatkul = [];

  List<Matkul> get allMatkul => _allMatkul;

  final JadwalKuliahDay _jadwalKuliahDay = JadwalKuliahDay();

  final CollectionReference _matkulCollection =
      FirebaseFirestore.instance.collection("matkuls");

  String? _userid;

  Matkul? selectById(String id) {
    if (_allMatkul.isEmpty) {
      print("data kosong, pastikan sudah memanggil getonce");
      return null;
    }
    return _allMatkul.firstWhere(
      (element) => element.matkulId == id,
      orElse: () => throw Exception("Matkul degnan ID $id tidak ditemaukan"),
    );
  }

  int get jumlahMatkul => _allMatkul.length;

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
    notifyListeners();
  }

  //gunakan firebase
  void clearData() {
    _allMatkul = [];
    notifyListeners();
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
    notifyListeners();
  }

  @override
  void dispose() {
    cancelSubscription();
    super.dispose();
  }

  // Future<void> fetchMatkuls() async {
  //   try {
  //     if (_userid == null) {
  //       return;
  //     }

  //     _matkulSubscription?.cancel();

  //     _matkulSubscription = _matkulCollection
  //         .where("userId", isEqualTo: _userid)
  //         .snapshots()
  //         .listen(
  //       (snapshot) {
  //         _allMatkul = snapshot.docs
  //             .map(
  //               (doc) =>
  //                   Matkul.fromJson(doc.id, doc.data() as Map<String, dynamic>),
  //             )
  //             .toList();
  //         notifyListeners();
  //       },
  //     );
  //   } catch (error) {}
  // }

  Future<void> getOnce() async {
    try {
      if (_userid == null) {
        return;
      }

      QuerySnapshot snapshot =
          await _matkulCollection.where("userId", isEqualTo: _userid).get();

      _allMatkul = snapshot.docs
          .map(
            (doc) =>
                Matkul.fromJson(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();

      _allMatkul.sort(
        (a, b) {
          //1. urutkan berdasarkan hari
          int dayCompare = getDayIndex(a.day!).compareTo(getDayIndex(b.day!));
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
      notifyListeners();
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

      _allMatkul.add(Matkul(
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
      notifyListeners();
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

      int index = _allMatkul.indexWhere(
        (matkul) => matkul.matkulId == id,
      );
      if (index != -1) {
        _allMatkul[index] = Matkul(
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
      notifyListeners();
    } catch (error) {
      print("error updating product: $error");
    }
  }

  Future<void> deleteMatkuls(String id, JadwalKuliahDay JadwalKuliahDay) async {
    try {
      if (_userid == null) {
        return;
      }

      await _matkulCollection.doc(id).delete();

      _allMatkul.removeWhere(
        (product) => product.matkulId == id,
      );

      JadwalKuliahDay.cleanupEmptyDays(this);

      notifyListeners();
    } catch (error) {
      print("error deleting product: $error");
    }
  }
}
