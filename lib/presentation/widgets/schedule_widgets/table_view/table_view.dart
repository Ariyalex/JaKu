import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/presentation/controllers/jadwal_controllers/jadwal_kuliah_c.dart';
import 'package:jaku/presentation/widgets/schedule_widgets/jadwal_kosong.dart';
import 'package:jaku/presentation/widgets/schedule_widgets/table_view/table.dart'
    as tbl;

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    final jadwalKuliahC = Get.find<JadwalkuliahC>();

    return Obx(() {
      if (jadwalKuliahC.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (jadwalKuliahC.errorMsg.value.isNotEmpty) {
        return Center(child: Text(jadwalKuliahC.errorMsg.value));
      } else if (jadwalKuliahC.allSchedule.isEmpty) {
        return const JadwalKosong();
      } else {
        return const Flex(
          direction: Axis.vertical,
          children: [Expanded(child: tbl.Table())],
        );
      }
    });
  }
}
