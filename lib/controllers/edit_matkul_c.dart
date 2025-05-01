import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditMatkulC extends GetxController {
  final matkulC = TextEditingController();
  final dosen1C = TextEditingController();
  final dosen2C = TextEditingController();
  final ruanganC = TextEditingController();

  RxnString hari = RxnString();
  RxnString kelas = RxnString();
  RxnString jamAwal = RxnString();
  RxnString jamAkhir = RxnString();
}
