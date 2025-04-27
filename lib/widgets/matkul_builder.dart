import 'package:flutter/material.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:provider/provider.dart';

import '../models/jadwal.dart';
import '../provider/jadwal_kuliah.dart';
import '../screens/detail_matkul.dart';
// import '../provider/hari_kuliah.dart';

class MatkulBuilder extends StatelessWidget {
  const MatkulBuilder({
    super.key,
    required this.matkulList,
  });

  final List<Matkul> matkulList;

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Provider.of<Jadwalkuliah>(context);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matkulList.length,
      separatorBuilder: (context, index) => Container(
        height: 3,
      ),
      itemBuilder: (context, index) {
        final matkul = matkulList[index];
        var id = matkulList[index].matkulId;
        String divider(String? formattedJamAkhir) {
          if (formattedJamAkhir == null || formattedJamAkhir.isEmpty) {
            return " ";
          } else {
            return " - ";
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Card(
            elevation: 1,
            color: const Color(0xFF282828),
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, DetailMatkul.routeName,
                    arguments: id);
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Hapus Item"),
                    content: const Text("Yakin hapus matkul?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No")),
                      OutlinedButton(
                        onPressed: () {
                          allMatkulProvider.deleteMatkuls(
                            id!,
                            Provider.of<JadwalKuliahDay>(context,
                                listen: false),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text("Yes"),
                      )
                    ],
                  ),
                );
              },
              titleTextStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              subtitleTextStyle: const TextStyle(
                fontSize: 14,
              ),
              title: Text(
                (matkul.kelas == null ||
                        matkul.kelas == "" ||
                        matkul.kelas == "null")
                    ? "${matkul.matkul}"
                    : "${matkul.matkul} (${matkul.kelas})",
                textAlign: TextAlign.center,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((matkul.formattedJamAwal == null)
                      ? "Jam belum ditambahkan"
                      : "${matkul.formattedJamAwal}${divider(matkul.formattedJamAkhir)}${matkul.formattedJamAkhir}"),
                  Text("Ruang ${matkul.room}"),
                  Text(
                    (matkul.dosen1 == "null")
                        ? "dosen belum ditambahkan"
                        : "${matkul.dosen1}\n${matkul.dosen2}",
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
