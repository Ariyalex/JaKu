import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jaku/presentation/controllers/jadwal_controllers/hari_kuliah_c.dart';
import 'package:get/get.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';

import '../../../../domain/models/matkul_schedule.dart';
import '../../../controllers/jadwal_controllers/jadwal_kuliah_c.dart';
import '../../../../core/routes/route_named.dart';

class MatkulCard extends StatelessWidget {
  const MatkulCard({super.key, required this.matkul});

  final MatkulSchedule matkul;

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
            Get.toNamed(RouteNamed.detailMatkul, arguments: matkul.id);
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
                    await jadwalKuliahC.deleteSchedule(matkul.id!, hariKuliahC);

                    Get.back();

                    showAppSnackbar(
                      title: "Success",
                      message: "Berhasil menghapus ${matkul.matkul}",
                    );
                  } catch (error) {
                    showAppSnackbar(
                      title: "Error!",
                      message: "Gagal menghapus: $e",
                      isSuccess: false,
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
                    (matkul.startTime.isEmpty)
                        ? "Jam belum ditambahkan"
                        : "${matkul.startTime}${divider(matkul.endTime)}${matkul.endTime}",
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
