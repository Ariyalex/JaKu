import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:jaku/widgets/day_card_builder.dart';

class CardView extends StatelessWidget {
  const CardView({
    super.key,
    required Rx<Future<void>?> futureMatkul,
  }) : _futureMatkul = futureMatkul;

  final Rx<Future<void>?> _futureMatkul;

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahController>();
    final jadwalKuliahDayProvider = Get.find<DayKuliahController>();

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
            return Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: DayCardBuilder(
                    jadwalKuliahDayProvider: jadwalKuliahDayProvider,
                    allMatkulProvider: allMatkulProvider,
                  ),
                )
              ],
            );
          }
        },
      );
    });
  }
}
