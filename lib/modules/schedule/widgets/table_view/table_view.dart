import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/modules/schedule/controller/matkul_schedule_controller.dart';
import 'package:jaku/modules/schedule/widgets/jadwal_kosong.dart';
import 'package:jaku/modules/schedule/widgets/table_view/table.dart' as tbl;

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    // final jadwalKuliahC = Get.find<selectedDay>();

    // return
    // Obx(() {
    // if (jadwalKuliahC.isLoading.value) {
    //   return const Center(child: CircularProgressIndicator());
    // } else if (jadwalKuliahC.errorMsg.value.isNotEmpty) {
    //   return Center(child: Text(jadwalKuliahC.errorMsg.value));
    // } else if (jadwalKuliahC.allSchedule.isEmpty) {
    //   return const JadwalKosong();
    // } else {
    return const Flex(
      direction: Axis.vertical,
      children: [Expanded(child: tbl.Table())],
    );
  }

  // });
  // }
}
