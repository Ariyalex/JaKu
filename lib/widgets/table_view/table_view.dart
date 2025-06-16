import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:jaku/widgets/table_view/table.dart' as tbl;

class TableView extends StatelessWidget {
  const TableView({
    super.key,
    required Rx<Future<void>?> futureMatkul,
  }) : _futureMatkul = futureMatkul;

  final Rx<Future<void>?> _futureMatkul;

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahController>();

    return Obx(() {
      final _ = allMatkulProvider.allMatkul;

      return FutureBuilder(
        future: _futureMatkul.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return const Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: tbl.Table(),
                )
              ],
            );
          }
        },
      );
    });
  }
}
