import 'package:flutter/material.dart';
import 'package:jaku/controllers/matkul_controllers/hari_kuliah_c.dart';
import 'package:get/get.dart';

import '../../../models/jadwal.dart';
import '../../../controllers/matkul_controllers/jadwal_kuliah_c.dart';
import '../../../routes/route_named.dart';

class MatkulCard extends StatelessWidget {
  const MatkulCard({super.key, required this.matkul});

  final Matkul matkul;

  @override
  Widget build(BuildContext context) {
    final jadwalKuliahC = Get.find<JadwalkuliahC>();
    final hariKuliahC = Get.find<HariKuliahC>();

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
            Get.toNamed(RouteNamed.detailMatkul, arguments: matkul.matkulId);
          },
          onLongPress: () {
            Get.defaultDialog(
              backgroundColor: theme.dialogTheme.backgroundColor,
              title: "Hapus Item",
              content: Text("Yakin hapus ${matkul.matkul}?"),
              cancel: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("No"),
              ),
              confirm: FilledButton(
                onPressed: () async {
                  try {
                    await jadwalKuliahC.deleteMatkuls(
                      matkul.matkulId!,
                      hariKuliahC,
                    );

                    Get.back();

                    Get.snackbar(
                      "Success",
                      "Berhasil menghapus ${matkul.matkul}",
                      backgroundColor: Colors.green.shade400,
                      colorText: Colors.white,
                    );
                  } catch (error) {
                    Get.snackbar(
                      'Error',
                      'Gagal menghapus ${matkul.matkul}: $error',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: theme.colorScheme.error,
                      colorText: theme.colorScheme.onError,
                    );
                  }
                },
                child: const Text("Yes"),
              ),
            );
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
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    "${matkul.room}",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (matkul.dosen1 == "null" || matkul.dosen1!.isEmpty)
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
      ),
    );
  }
}
