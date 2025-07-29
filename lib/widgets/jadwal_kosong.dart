import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/theme/theme.dart';

class jadwalKosong extends StatelessWidget {
  const jadwalKosong({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;

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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: mediaQueryWidth * 5 / 7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "images/bochi.jpg",
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      Get.toNamed(RouteNamed.addMatkul);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Add Matkul",
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                    onPressed: () {
                      Get.defaultDialog(
                        backgroundColor:
                            AppTheme.dark.drawerTheme.backgroundColor,
                        title: "Peringatan!!",
                        content: const Text(
                          "Fitur ini hanya untuk\nmahasiswa UIN SUKA.\nAdd matkul menggunakan file PDF yang didapat dari SIA UIN SUKA",
                          textAlign: TextAlign.center,
                        ),
                        cancel: OutlinedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("Ga jadi")),
                        confirm: FilledButton(
                          onPressed: () {
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
                        Text(
                          "PDF Otomation",
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.picture_as_pdf),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
