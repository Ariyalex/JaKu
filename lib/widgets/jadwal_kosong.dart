import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/provider/auth.dart';
import 'package:jaku/provider/internet_check.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/theme/theme.dart';

class jadwalKosong extends StatelessWidget {
  const jadwalKosong({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final connectionStatus = Get.find<InternetCheck>().isOnline;
    final authController = Get.find<AuthController>();
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
}
