import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jaku/models/jadwal.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PdfBack with ChangeNotifier {
  List<Matkul> _allMatkul = [];
  List<Matkul> get allMatkul => _allMatkul;

  final String baseUrl = 'https://pdfparsejaku-production.up.railway.app';
  File? selectedFile;
  String? responseMessage;
  bool isLoading = false;
  bool isUploading = false;
  final Dio dio = Dio();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        selectedFile = File(result.files.single.path!);
        responseMessage = "File dipilih: ${result.files.single.name}";
        _allMatkul = []; // Reset data when a new file is selected
      }
      notifyListeners();
    } catch (e) {
      responseMessage = "Error saat memilih file: $e";
      notifyListeners();
      throw "Error saat memilih file: $e";
    }
  }

  // Clear all user data in Firebase
  Future<void> clearUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    try {
      // Get all documents for the current user
      final QuerySnapshot snapshot = await _firestore
          .collection("matkuls")
          .where("userId", isEqualTo: user.uid)
          .get();

      // Create a batch write to delete all documents
      WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch
      await batch.commit();

      // Clear local data
      _allMatkul.clear();
      notifyListeners();
    } catch (e) {
      print("Error clearing user data: $e");
      throw "Error clearing user data: $e";
    }
  }

  Future<void> uploadAndProcessPdf(Jadwalkuliah jadwalProvider) async {
    if (selectedFile == null) {
      responseMessage = "Pilih file PDF terlebih dahulu";
      notifyListeners();
      return;
    }

    isLoading = true;
    responseMessage = "Menghapus data lama...";
    notifyListeners();

    try {
      // Clear existing data both in Firebase and locally first
      await clearUserData();
      jadwalProvider.clearData(); // Clear data in the JadwalKuliah provider

      responseMessage = "Mengunggah dan memproses file...";
      notifyListeners();

      String fileName = selectedFile!.path.split('/').last;

      // Buat form data
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          selectedFile!.path,
          filename: fileName,
        ),
      });

      // Kirim request
      await dio.post(
        '$baseUrl/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
        ),
      );

      // Download JSON yang dihasilkan
      final downloadResponse = await dio.get(
        '$baseUrl/download',
        options: Options(responseType: ResponseType.bytes),
      );

      if (downloadResponse.statusCode == 200) {
        // Simpan JSON ke penyimpanan lokal
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/jadwal_mahasiswa.json';
        File(filePath).writeAsBytesSync(downloadResponse.data);

        // Baca json parse
        String jsonString = await File(filePath).readAsString();
        Map<String, dynamic> jsonData = json.decode(jsonString);

        // Parse JSON ke model
        _allMatkul.clear(); // Ensure data is cleared

        List<dynamic> jadwalList = jsonData['jadwal'];
        for (var courseData in jadwalList) {
          String mataKuliah = courseData['mata_kuliah'];

          // Get dosen information
          List<dynamic> dosenList = courseData['dosen'];
          String dosen1 = dosenList.isNotEmpty ? dosenList[0]['nama'] : "";
          String dosen2 = dosenList.length > 1 ? dosenList[1]['nama'] : "";

          // Process each schedule for the course
          List<dynamic> jadwalKuliah = courseData['jadwal_kuliah'];
          for (var jadwal in jadwalKuliah) {
            String hari = jadwal['hari'];
            String waktu = jadwal['waktu'];
            String ruangan = jadwal['ruangan'];

            // Split waktu into start and end times
            List<String> waktuParts = waktu.split('-');
            String jamAwal = waktuParts[0];
            String jamAkhir = waktuParts.length > 1 ? waktuParts[1] : "";

            // Create Matkul object
            Matkul matkulObj = Matkul(
              day: hari,
              matkul: mataKuliah,
              formattedJamAwal: jamAwal,
              formattedJamAkhir: jamAkhir,
              dosen1: dosen1,
              dosen2: dosen2,
              room: ruangan,
            );

            _allMatkul.add(matkulObj);
          }
        }

        // Upload to Firebase
        isUploading = true;
        responseMessage = "Menyimpan ke Firebase...";
        notifyListeners();

        // Upload each matkul using the existing provider function
        for (var matkul in _allMatkul) {
          await jadwalProvider.addMatkuls(
            matkul.matkul ?? "",
            matkul.kelas ?? "",
            matkul.formattedJamAwal ?? "",
            matkul.formattedJamAkhir ?? "",
            matkul.dosen1 ?? "",
            matkul.dosen2 ?? "",
            matkul.room ?? "",
            matkul.day ?? "",
          );
        }

        // Refresh the jadwalProvider data
        await jadwalProvider.getOnce();

        isLoading = false;
        isUploading = false;
        responseMessage = "File berhasil diproses dan disimpan";
        notifyListeners();
      } else {
        isLoading = false;
        isUploading = false;
        responseMessage = "Error: ${downloadResponse.statusMessage}";
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      isUploading = false;
      responseMessage = "Error: $e";
      notifyListeners();
      print("Error saat mengupload dan memproses file: $e");
    }
  }
}
