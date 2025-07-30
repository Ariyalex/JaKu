import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/hari_kuliah.dart';
import 'package:jaku/controllers/jadwal_kuliah.dart';
import 'package:jaku/widgets/card_view/matkul_card.dart';
import 'package:jaku/widgets/jadwal_kosong.dart';

class CardView extends StatelessWidget {
  const CardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final allMatkulC = Get.find<JadwalkuliahController>();
    final dayKuliahController = Get.find<DayKuliahController>();

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
                padding: const EdgeInsets.all(10),
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
                    clipBehavior: Clip.hardEdge,
                    color: const Color(0xFF151515),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Color(0xFF777777)))),
                          child: Text(
                            hariKuliah.day,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
