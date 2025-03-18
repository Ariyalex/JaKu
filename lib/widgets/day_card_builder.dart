import 'package:flutter/material.dart';

import '../provider/hari_kuliah.dart';
import '../provider/jadwal_kuliah.dart';
import './matkul_builder.dart';

class DayCardBuilder extends StatelessWidget {
  const DayCardBuilder({
    super.key,
    required this.jadwalKuliahDayProvider,
    required this.allMatkulProvider,
  });

  final JadwalKuliahDay jadwalKuliahDayProvider;
  final Jadwalkuliah allMatkulProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: jadwalKuliahDayProvider.jadwalHari.length,
      itemBuilder: (context, index) {
        final hariKuliah = jadwalKuliahDayProvider.jadwalHari[index];
        final matkulList = allMatkulProvider.allMatkul
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
                    border:
                        Border(bottom: BorderSide(color: Color(0xFF777777)))),
                child: Text(
                  "${hariKuliah.day}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MatkulBuilder(matkulList: matkulList),
            ],
          ),
        );
      },
    );
  }
}
