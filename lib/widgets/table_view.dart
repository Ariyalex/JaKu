import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/theme/theme.dart';

class TableView extends StatelessWidget {
  const TableView({
    super.key,
    required Rx<Future<void>?> futureMatkul,
  }) : _futureMatkul = futureMatkul;

  final Rx<Future<void>?> _futureMatkul;

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahController>();
    final jadwalKuliahDayProvider = Get.find<DayKuliahController>();

    //get hari saat ini untuk highlight
    final String todayDay = jadwalKuliahDayProvider.getCurrentDay();

    //color
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = AppTheme.dark.colorScheme.secondary;

    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final allJadwal = allMatkulProvider.allMatkul;
      final hari = jadwalKuliahDayProvider.jadwalHariTerurut;

      //fungsi mendapatkanJam
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
        jamPairList.sort((a, b) {
          int timeToMinutes(String timeStr) {
            final parts = timeStr.split(":");
            if (parts.length != 2) return 0;

            try {
              final hours = int.parse(parts[0]);
              final minutes = int.parse(parts[1]);
              return hours * 60 + minutes;
            } catch (e) {
              return 0;
            }
          }

          final aMinutes = timeToMinutes(a['jamAwal']!);
          final bMinutes = timeToMinutes(b['jamAwal']!);
          return aMinutes.compareTo(bMinutes);
        });

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
                              backgroundColor:
                                  Theme.of(context).dialogTheme.backgroundColor,
                              title: "Hapus Item",
                              content: const Text("Yakin hapus matkul ini?"),
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
                            style: isToday
                                ? textTheme.bodyLarge
                                    ?.copyWith(color: accentColor)
                                : textTheme.bodyMedium,
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

      //main code
      return FutureBuilder(
        future: _futureMatkul.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Table(
                    border: TableBorder.all(color: Colors.white, width: 0.5),
                    defaultColumnWidth: FixedColumnWidth(120.0),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          //header jam
                          Container(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "Jam",
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          //header hari
                          ...hari.map((h) => Container(
                                padding: const EdgeInsets.all(8),
                                color: h.day == todayDay
                                    ? primaryColor.withValues(alpha: 0.5)
                                    : null,
                                child: Text(
                                  h.day,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyLarge,
                                ),
                              ))
                        ],
                      ),
                      //list jam di column jam
                      ...jam.map(
                        (jamPair) => TableRow(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                jamPair['jamAkhir']!.isNotEmpty
                                    ? "${jamPair['jamAwal']} - ${jamPair['jamAkhir']}"
                                    : jamPair['jamAwal']!,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            //list matkul di column hari
                            ...hari.map((h) => getMatkulCell(h.day, jamPair))
                          ],
                        ),
                      )
                    ],
                  )),
            );
          }
        },
      );
    });
  }
}
