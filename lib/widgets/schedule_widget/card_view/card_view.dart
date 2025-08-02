import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/hari_kuliah_c.dart';
import 'package:jaku/controllers/jadwal_kuliah_c.dart';
import 'package:jaku/widgets/schedule_widget/card_view/matkul_card.dart';
import 'package:jaku/widgets/jadwal_kosong.dart';

class CardView extends StatelessWidget {
  const CardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final jadwalKuliahC = Get.find<JadwalkuliahC>();
    final hariKuliahC = Get.find<HariKuliahC>();

    final theme = Theme.of(context);

    return Obx(() {
      if (jadwalKuliahC.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (jadwalKuliahC.errorMsg.value.isNotEmpty) {
        return Center(child: Text(jadwalKuliahC.errorMsg.value));
      } else if (jadwalKuliahC.allMatkul.isEmpty) {
        return const JadwalKosong();
      } else {
        return Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 5, right: 5, left: 5, bottom: 60),
                itemCount: hariKuliahC.jadwalHari.length,
                itemBuilder: (context, index) {
                  final hariKuliah = hariKuliahC.jadwalHari[index];
                  final matkulList = jadwalKuliahC.allMatkul
                      .where(
                        (matkul) => matkul.day == hariKuliah.day,
                      )
                      .toList();
                  return Card(
                    elevation: 0,
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          alignment: Alignment.center,
                          decoration:
                              BoxDecoration(color: theme.colorScheme.primary),
                          child: Text(
                            hariKuliah.day,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimary),
                          ),
                        ),
                        Container(
                          color: theme.colorScheme.surfaceContainer,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: matkulList.length,
                            separatorBuilder: (context, index) => Container(
                              height: 3,
                            ),
                            itemBuilder: (context, index) {
                              final matkul = matkulList[index];
                              // var id = matkulList[index].matkulId;

                              return MatkulCard(matkul: matkul);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }
}
