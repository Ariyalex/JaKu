import 'package:flutter/material.dart';
import 'package:jaku/controllers/hari_kuliah_c.dart';
import 'package:get/get.dart';
import 'package:jaku/theme/theme.dart';

import '../../models/jadwal.dart';
import '../../controllers/jadwal_kuliah_c.dart';
import '../../routes/route_named.dart';

class MatkulCard extends StatelessWidget {
  const MatkulCard({
    super.key,
    required this.matkul,
  });

  final Matkul matkul;

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahC>();
    final dayKuliahController = Get.find<HariKuliahC>();

    final theme = Theme.of(context);

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
          elevation: 0,
          color: theme.highlightColor,
          child: ListTile(
            onTap: () {
              Get.toNamed(RouteNamed.editMatkul, arguments: matkul.matkulId);
            },
            onLongPress: () {
              Get.defaultDialog(
                  backgroundColor: theme.dialogTheme.backgroundColor,
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
                          matkul.matkulId!, dayKuliahController);
                      Get.back();
                    },
                    child: const Text("Yes"),
                  ));
            },
            title: Text(
              (matkul.kelas == null ||
                      matkul.kelas == "" ||
                      matkul.kelas == "null")
                  ? matkul.matkul
                  : "${matkul.matkul} (${matkul.kelas})",
              textAlign: TextAlign.center,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                        (matkul.formattedJamAwal.isEmpty)
                            ? "Jam belum ditambahkan"
                            : "${matkul.formattedJamAwal}${divider(matkul.formattedJamAkhir)}${matkul.formattedJamAkhir}",
                        style: theme.textTheme.bodyLarge!
                            .copyWith(color: theme.colorScheme.primary)),
                    Text(
                      "${matkul.room}",
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (matkul.dosen1 == "null")
                          ? "dosen belum ditambahkan"
                          : "${matkul.dosen1}",
                      overflow: TextOverflow.ellipsis,
                    ),
                    matkul.dosen2 == "null" || matkul.dosen2!.isEmpty
                        ? const SizedBox.shrink()
                        : Text(
                            "${matkul.dosen2}",
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
