import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/theme/theme.dart';

class TableView1 extends StatefulWidget {
  const TableView1({super.key, required Rx<Future<void>?> futureMatkul})
      : _futureMatkul = futureMatkul;

  final Rx<Future<void>?> _futureMatkul;

  @override
  State<TableView1> createState() => _TableView1State();
}

class _TableView1State extends State<TableView1> {
  final ScrollController _horizontalScrollController = ScrollController();
  final allMatkulProvider = Get.find<JadwalkuliahController>();
  final jadwalKuliahDayProvider = Get.find<DayKuliahController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Tunggu sampai daftar hari diisi
      _waitForDataAndScrollToToday();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  // Method untuk scroll ke kolom hari ini (dimodifikasi untuk testing)
  void scrollToTodayColumn() {
    debugPrint("==== _scrollToTodayColumn dipanggil ====");

    final jadwalKuliahDayProvider = Get.find<DayKuliahController>();

    final dayNow = jadwalKuliahDayProvider.getCurrentDay();
    // final dayNow = "Kamis";

    debugPrint("Target hari: $dayNow");

    final hariList = jadwalKuliahDayProvider.jadwalHariTerurut;
    debugPrint("Daftar hari: $hariList");

    if (hariList.isEmpty) {
      debugPrint("PERINGATAN: Daftar hari masih kosong!");
      return;
    }

    // Cari indeks hari dengan nama "Kamis"
    int targetIndex = -1;
    for (int i = 0; i < hariList.length; i++) {
      // Asumsikan HariKuliah memiliki properti 'nama' atau 'namaHari'
      // Sesuaikan dengan struktur objek HariKuliah sebenarnya
      final namaHari =
          hariList[i].day; // atau hariList[i].namaHari atau properti lainnya
      debugPrint("Hari ke-$i: $namaHari");

      if (namaHari == dayNow) {
        targetIndex = i;
        debugPrint("Ketemu! $dayNow ada di indeks $i");
        break;
      }
    }

    if (targetIndex == -1) {
      debugPrint(
          "'$dayNow' tidak ditemukan dalam daftar hari, menggunakan indeks 0 sebagai fallback");
      targetIndex = 0; // Fallback ke indeks pertama jika tidak ditemukan
    }

    // Lebar setiap kolom
    final double columnWidth = 225.0;
    final double scrollPosition = targetIndex * columnWidth;

    debugPrint("Posisi scroll target: $scrollPosition");

    if (!mounted) return;

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (_horizontalScrollController.hasClients) {
        debugPrint(
            "Controller memiliki clients, melakukan scroll ke $scrollPosition");
        _horizontalScrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        debugPrint("Controller TIDAK memiliki clients");
      }
    });
  }

  Future<void> _waitForDataAndScrollToToday() async {
    final dayController = Get.find<DayKuliahController>();

    // Check if data is already available
    if (dayController.jadwalHariTerurut.isNotEmpty) {
      debugPrint("Data hari tersedia segera");
      scrollToTodayColumn();
      return;
    }

    // Wait for data to become available
    int attempts = 0;
    while (attempts < 10) {
      debugPrint("Menunggu data hari tersedia... (${attempts + 1}/10)");

      // Wait a short time
      await Future.delayed(const Duration(milliseconds: 400));

      // Check again after waiting
      if (dayController.jadwalHariTerurut.isNotEmpty) {
        debugPrint("Data hari tersedia setelah ${attempts + 1} kali coba");
        scrollToTodayColumn();
        return;
      }
      attempts++;
    }

    debugPrint("Data hari tidak tersedia setelah menunggu 5 detik");
  }

  @override
  Widget build(BuildContext context) {
    //get hari saat ini untuk highlight
    final String todayDay = jadwalKuliahDayProvider.getCurrentDay();

    //color
    final primaryColor = Theme.of(context).primaryColor;
    final colorTheme = AppTheme.dark.colorScheme;

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

      DataCell getMatkulCell(String hari, Map<String, String> jamPair) {
        //filter jadwal sesuai dengan hari dan jam
        final matchingMatkul = allJadwal.where((jadwal) =>
            jadwal.day == hari &&
            jadwal.formattedJamAwal == jamPair['jamAwal'] &&
            jadwal.formattedJamAkhir == jamPair['jamAkhir']);

        final isToday = hari == todayDay;

        if (matchingMatkul.isEmpty) {
          // Sel kosong jika tidak ada mata kuliah
          return const DataCell(Text(""));
        } // Membuat konten DataCell dengan mata kuliah
        return DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isToday ? primaryColor.withValues(alpha: 0.35) : null,
            ),
            alignment: AlignmentDirectional.center,
            child: Text(
              matchingMatkul.first.matkul,
              style: isToday ? textTheme.bodyLarge : textTheme.bodyMedium,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ),
          onTap: () {
            Get.toNamed(RouteNamed.editMatkul,
                arguments: matchingMatkul.first.matkulId);
          },
          onLongPress: () {
            Get.defaultDialog(
                backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
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
                        matchingMatkul.first.matkulId!,
                        jadwalKuliahDayProvider);
                    Get.back();
                  },
                  child: const Text("Yes"),
                ));
          },
          // Opsi DataCell tambahan
        );
      }

      return FutureBuilder(
          future: widget._futureMatkul.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return DataTable2(
                  horizontalMargin: 0,
                  columnSpacing: 0,
                  bottomMargin: 20,
                  dataRowHeight: 100,
                  fixedLeftColumns: 1,
                  headingRowColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      return primaryColor.withValues(alpha: 0.4);
                    },
                  ),
                  isHorizontalScrollBarVisible: false,
                  isVerticalScrollBarVisible: false,
                  horizontalScrollController: _horizontalScrollController,
                  border:
                      TableBorder.all(width: 1, color: colorTheme.onPrimary),
                  minWidth: 1800,
                  columns: [
                    DataColumn2(
                      headingRowAlignment: MainAxisAlignment.center,
                      fixedWidth: 75,
                      label: Text(
                        "Jam",
                        style: textTheme.bodyLarge,
                      ),
                      size: ColumnSize.S,
                    ),
                    ...List<DataColumn2>.generate(
                      hari.length,
                      (index) => DataColumn2(
                        fixedWidth: 225.0,
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          hari[index].day,
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    ...List<DataRow2>.generate(
                      jam.length,
                      (index) => DataRow2(
                        cells: [
                          DataCell(
                            Container(
                              decoration: BoxDecoration(
                                  color: colorTheme.primary
                                      .withValues(alpha: 0.4)),
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                jam[index]['jamAkhir']!.isNotEmpty
                                    ? '${jam[index]['jamAwal']}\n - \n${jam[index]['jamAkhir']}'
                                    : '${jam[index]['jamAwal']}',
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          ...List<DataCell>.generate(
                            hari.length,
                            (hariIndex) => getMatkulCell(
                              hari[hariIndex].day,
                              jam[index],
                            ), // DataCell langsung dari getMatkulCell
                          ),
                        ],
                      ),
                    ),
                  ]);
            }
          });
    });
  }
}
