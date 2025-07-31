import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/hari_kuliah_c.dart';
import 'package:jaku/controllers/jadwal_kuliah_c.dart';
import 'package:jaku/widgets/card_view/matkul_card.dart';
import 'package:jaku/widgets/jadwal_kosong.dart';

class CardView extends StatelessWidget {
  const CardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final allMatkulC = Get.find<JadwalkuliahC>();
    final dayKuliahController = Get.find<HariKuliahC>();

    final theme = Theme.of(context);

    return Obx(() {
      if (allMatkulC.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (allMatkulC.errorMsg.value.isNotEmpty) {
        return Center(child: Text(allMatkulC.errorMsg.value));
      } else if (allMatkulC.allMatkul.isEmpty) {
        return const JadwalKosong();
      } else {
        return Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: dayKuliahController.jadwalHari.length,
                itemBuilder: (context, index) {
                  final hariKuliah = dayKuliahController.jadwalHari[index];
                  final matkulList = allMatkulC.allMatkul
                      .where(
                        (matkul) => matkul.day == hariKuliah.day,
                      )
                      .toList();
                  return Card(
                    elevation: 0,
                    borderOnForeground: false,
                    // shadowColor: theme.shadowColor,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(16),
                    //   side: BorderSide(
                    //     color: theme.colorScheme.primary,
                    //     width: 2,
                    //   ),
                    // ),
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
                        ListView.separated(
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
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        );
      }
    });
  }
}
