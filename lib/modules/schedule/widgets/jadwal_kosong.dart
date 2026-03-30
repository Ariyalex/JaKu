import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';

class JadwalKosong extends StatelessWidget {
  const JadwalKosong({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
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
                      context.pushNamed(RouteNamed.addSchedule);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Tambah Schedule", style: TextStyle(fontSize: 17)),
                        SizedBox(width: 5),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: theme.dialogTheme.backgroundColor,
                          title: const Text("Peringatan!!"),
                          content: const Text(
                            "Fitur ini hanya untuk\nmahasiswa UIN SUKA.\nAdd matkul menggunakan file PDF yang didapat dari SIA UIN SUKA",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Ga jadi"),
                            ),
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.pushNamed(RouteNamed.pdfParsing);
                              },
                              child: const Text("Ok Bang"),
                            ),
                          ],
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
