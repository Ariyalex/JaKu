import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/jadwal_kuliah_c.dart';
import 'package:jaku/widgets/jadwal_kosong.dart';
import 'package:jaku/widgets/table_view/table.dart' as tbl;

class TableView extends StatelessWidget {
  const TableView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahC>();

    return Obx(
      () {
        if (allMatkulProvider.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (allMatkulProvider.errorMsg.value.isNotEmpty) {
          return Center(child: Text(allMatkulProvider.errorMsg.value));
        } else if (allMatkulProvider.allMatkul.isEmpty) {
          return const JadwalKosong();
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
  }
}
