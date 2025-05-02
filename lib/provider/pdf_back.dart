import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:jaku/models/jadwal.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PdfBack extends GetxController {
  final RxList<Matkul> _allMatkul = <Matkul>[].obs;
  List<Matkul> get allMatkul => _allMatkul;

  final String baseUrl = 'https://pdfparsejaku-production.up.railway.app';
  Rx<File?> selectedFile = Rx<File?>(null);
  RxString responseMessage = RxString('');
  RxBool isLoading = false.obs;
  RxBool isUploading = false.obs;
  final dio_package.Dio dio = dio_package.Dio();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        selectedFile.value = File(result.files.single.path!);
        responseMessage.value = "File dipilih: ${result.files.single.name}";
        _allMatkul.clear(); // Reset data when a new file is selected
      }
    } catch (e) {
      responseMessage.value = "Error saat memilih file: $e";
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
    } catch (e) {
      print("Error clearing user data: $e");
      throw "Error clearing user data: $e";
    }
  }

  Future<void> uploadAndProcessPdf(
      JadwalkuliahController jadwalProvider) async {
    if (selectedFile.value == null) {
      responseMessage.value = "Pilih file PDF terlebih dahulu";
      return;
    }

    isLoading.value = true;
    responseMessage.value = "Menghapus data lama...";

    try {
      // Clear existing data both in Firebase and locally first
      await clearUserData();
      jadwalProvider.clearData(); // Clear data in the JadwalKuliah provider

      responseMessage.value = "Mengunggah dan memproses file...";

      String fileName = selectedFile.value!.path.split('/').last;

      // Buat form data
      dio_package.FormData formData = dio_package.FormData.fromMap({
        "file": await dio_package.MultipartFile.fromFile(
          selectedFile.value!.path,
          filename: fileName,
        ),
      });

      // Kirim request
      await dio.post(
        '$baseUrl/upload',
        data: formData,
        options: dio_package.Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
        ),
      );

      // Download JSON yang dihasilkan
      final downloadResponse = await dio.get(
        '$baseUrl/download',
        options:
            dio_package.Options(responseType: dio_package.ResponseType.bytes),
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
        isUploading.value = true;
        responseMessage.value = "Menyimpan ke Firebase...";

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

        isLoading.value = false;
        isUploading.value = false;
        responseMessage.value = "File berhasil diproses dan disimpan";
      } else {
        isLoading.value = false;
        isUploading.value = false;
        responseMessage.value = "Error: ${downloadResponse.statusMessage}";
      }
    } catch (e) {
      isLoading.value = false;
      isUploading.value = false;
      responseMessage.value = "Error: $e";
      print("Error saat mengupload dan memproses file: $e");
    }
  }
}
