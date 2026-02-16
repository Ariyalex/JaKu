import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/modules/schedule/widgets/add_jadwal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class JadwalKosong extends StatelessWidget {
  const JadwalKosong({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        width: mediaQueryWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                const Text(
                  "Jadwal Kosong??!!!",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: mediaQueryWidth * 5 / 7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset("images/bochi.jpg"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () async {
                      await showBarModalBottomSheet<Map<String, dynamic>>(
                        barrierColor: Colors.black.withValues(alpha: 0.4),
                        context: context,
                        useRootNavigator: true,
                        builder: (context) => const AddJadwal(),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Add Matkul", style: TextStyle(fontSize: 17)),
                        SizedBox(width: 5),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () {
                      Get.defaultDialog(
                        backgroundColor: theme.drawerTheme.backgroundColor,
                        title: "Peringatan!!",
                        content: const Text(
                          "Fitur ini hanya untuk\nmahasiswa UIN SUKA.\nAdd matkul menggunakan file PDF yang didapat dari SIA UIN SUKA",
                          textAlign: TextAlign.center,
                        ),
                        cancel: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Ga jadi"),
                        ),
                        confirm: FilledButton(
                          onPressed: () {
                            Get.back();
                            Get.back();
                            Get.toNamed(RouteNamed.pdfParsing);
                          },
                          child: const Text("Ok Bang"),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("PDF Otomation", style: TextStyle(fontSize: 17)),
                        SizedBox(width: 5),
                        Icon(Icons.picture_as_pdf),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
