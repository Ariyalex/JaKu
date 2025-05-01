import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMatkulC extends GetxController {
  final matkulC = TextEditingController();
  final dosen1C = TextEditingController();
  final dosen2C = TextEditingController();
  final ruanganC = TextEditingController();

  RxnString hari = RxnString();
  RxnString kelas = RxnString();
  RxnString jamAwal = RxnString();
  RxnString jamAkhir = RxnString();
}
