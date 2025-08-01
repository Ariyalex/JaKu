import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/jadwal_kuliah_c.dart';

class DetailMatkul extends StatelessWidget {
  const DetailMatkul({super.key});

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahC>();

    final matkulId = Get.arguments as String;
    final selectedMatkul = allMatkulProvider.selectById(matkulId)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMatkul.matkul),
      ),
      body: Center(
        child: Text("data"),
      ),
    );
  }
}
