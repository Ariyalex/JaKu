import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/auth.dart';
import 'package:jaku/provider/internet_check.dart';
import 'package:jaku/routes/route_named.dart';

import '../provider/hari_kuliah.dart';
import '../provider/jadwal_kuliah.dart';
import './matkul_builder.dart';

class DayCardBuilder extends StatelessWidget {
  const DayCardBuilder({
    super.key,
    required this.jadwalKuliahDayProvider,
    required this.allMatkulProvider,
  });

  final DayKuliahController jadwalKuliahDayProvider;
  final JadwalkuliahController allMatkulProvider;

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final connectionStatus = Get.find<InternetCheck>().isOnline;
    final authController = Get.find<AuthController>();

    return Obx(() {
      // Jika tidak ada jadwal hari, kembalikan widget kosong
      if (jadwalKuliahDayProvider.jadwalHari.isEmpty) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Obx(() {
                    if (connectionStatus.value == true &&
                        authController.isLoggedIn == true) {
                      print("onlen dan login");
                      return Column(
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
                      );
                    } else if (connectionStatus.value == false &&
                        authController.isLoggedIn == false) {
                      print("offline dan tdk login");
                      return const Text(
                        "Anda hanya bisa menambahkan matkul jika terkoneksi internet dan sudah login!",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      );
                    } else if (connectionStatus.value == true &&
                        authController.isLoggedIn == false) {
                      return Column(
                        children: [
                          const Text(
                            "Anda sudah online tapi belum login, pastikan login dulu agar bisa menggunakan fitur lainnya",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FilledButton(
                            onPressed: () {
                              Get.offNamed(RouteNamed.signInScreen);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.login),
                              ],
                            ),
                          )
                        ],
                      );
                    } else if (connectionStatus.value == false &&
                        authController.isLoggedIn == true) {
                      return const Text(
                        "Dalam mode offline, anda hanya dapat melihat matkul saja, anda harus online dulu untuk bisa menggunakan fungsi lainnya",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                )
              ],
            ),
          ),
        );
      }

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
                    hariKuliah.day,
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
    });
  }
}
