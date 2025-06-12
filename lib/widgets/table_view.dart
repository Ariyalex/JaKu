import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:jaku/routes/route_named.dart';

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahController>();
    final jadwalKuliahDayProvider = Get.find<DayKuliahController>();

    return Obx(() {
      final allJadwal = allMatkulProvider.allMatkul;
      final hari = jadwalKuliahDayProvider.jadwalHariTerurut;

      List<Map<String, String>> getJam() {
        final jamPairSet = <String>{};

        //membuat set dari string unik berdasarkan kombinasi jam awal dan akhir
        for (var jadwal in allJadwal) {
          jamPairSet
              .add("${jadwal.formattedJamAwal}#${jadwal.formattedJamAkhir}");
        }

        //membuat list dari pasangan jam dalam bentuk map
        final jamPairList = jamPairSet.map((pair) {
          final parts = pair.split('#');
          return {
            'jamAwal': parts[0],
            'jamAkhir': parts[1],
          };
        }).toList();

        //mengurutkan berdasarkan jam awal
        jamPairList.sort((a, b) => a['jamAwal']!.compareTo(b['jamAwal']!));

        return jamPairList;
      }

      final jam = getJam();

      //fungsi untuk mendapatkan matkul pada hari dan jam tertentu
      Widget getMatkulCell(String hari, Map<String, String> jamPair) {
        //filter jadwal sesuai dengan hari dan jam
        final matchingMatkul = allJadwal
            .where((jadwal) =>
                jadwal.day == hari &&
                jadwal.formattedJamAwal == jamPair['jamAwal'] &&
                jadwal.formattedJamAkhir == jamPair['jamAkhir'])
            .toList();

        if (matchingMatkul.isNotEmpty) {
          return Container(
            padding: EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: matchingMatkul
                  .map((matkul) => GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNamed.editMatkul,
                              arguments: matkul.matkulId);
                        },
                        onLongPress: () {
                          Get.defaultDialog(
                              title: "Hapus Item",
                              content: Text("Yakin hapus matkul ini?"),
                              cancel: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("No")),
                              confirm: OutlinedButton(
                                onPressed: () {
                                  allMatkulProvider.deleteMatkuls(
                                      matkul.matkulId!,
                                      jadwalKuliahDayProvider);
                                  Get.back();
                                },
                                child: const Text("Yes"),
                              ));
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            matkul.matkul,
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(8),
          child: Text(""),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: Colors.white, width: 0.5),
          defaultColumnWidth: FixedColumnWidth(120.0),
          children: [
            TableRow(
              children: [
                Container(
                  child: Container(
                    child: Text("Jam"),
                    padding: EdgeInsets.all(8),
                  ),
                ),
                ...hari.map((h) => Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        h.day,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
            ...jam.map(
              (jamPair) => TableRow(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "${jamPair['jamAwal']} - ${jamPair['jamAkhir']}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ...hari.map((h) => getMatkulCell(h.day, jamPair))
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
