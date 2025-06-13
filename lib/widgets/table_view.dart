import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/theme/theme.dart';

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahController>();
    final jadwalKuliahDayProvider = Get.find<DayKuliahController>();

    final String todayDay = jadwalKuliahDayProvider.getCurrentDay();

    //color
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = AppTheme.dark.colorScheme.secondary;

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

        final isToday = hari == todayDay;

        if (matchingMatkul.isNotEmpty) {
          return FractionallySizedBox(
            widthFactor: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: matchingMatkul
                  .map((matkul) => InkWell(
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
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday ? accentColor : null,
                            ),
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
          padding: const EdgeInsets.all(8),
          child: const Text(""),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(color: Colors.white, width: 0.5),
          defaultColumnWidth: FixedColumnWidth(120.0),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Container(
                  child: Container(
                    child: Text(
                      "Jam",
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                ),
                ...hari.map((h) => Container(
                      padding: EdgeInsets.all(8),
                      color: h.day == todayDay
                          ? primaryColor.withOpacity(0.3)
                          : null,
                      child: Text(
                        h.day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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
                      textAlign: TextAlign.center,
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
