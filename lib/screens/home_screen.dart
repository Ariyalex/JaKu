import 'package:flutter/material.dart';
import 'package:jaku/provider/auth.dart';
import 'package:jaku/widgets/drawer_guide.dart';
import 'package:get/get.dart';

import '../provider/hari_kuliah.dart';
import '../provider/jadwal_kuliah.dart';
import '../widgets/day_card_builder.dart';
import '../routes/route_named.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Rx<Future<void>?> _futureMatkul = Rx<Future<void>?>(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    final jadwalProvider = Get.find<JadwalkuliahController>();
    final jadwalHariProvider = Get.find<DayKuliahController>();

    _futureMatkul.value = jadwalProvider.getOnce().then(
      (_) {
        jadwalHariProvider.getUniqueDays(jadwalProvider);
      },
    ).catchError(
      (err) {
        Get.defaultDialog(
          title: "Error Occured",
          content: Text(err.toString()),
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Okay"),
          ),
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  static void _logout(BuildContext context) {
    Get.defaultDialog(
        title: "Log Out",
        content: Text("Yakin Log Out dari account"),
        cancel: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Tidak"),
        ),
        confirm: FilledButton(
            onPressed: () async {
              // Tutup dialog konfirmasi
              Get.back();

              // Tampilkan indikator loading
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              try {
                // Dapatkan controller yang diperlukan
                var matkuls = Get.find<JadwalkuliahController>();
                var auth = Get.find<AuthController>();

                // Lakukan proses logout
                await auth.signOut(matkuls);

                // Tutup loading dialog
                Get.back();

                // Navigasi ke halaman login dengan menghapus semua halaman sebelumnya
                Get.offAllNamed(RouteNamed.signInScreen);
              } catch (e) {
                // Tutup loading dialog jika terjadi error
                Get.back();

                // Tampilkan pesan error
                Get.snackbar(
                  'Gagal Logout',
                  'Terjadi kesalahan: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text("Ya")));
  }

  static void clearAllData(BuildContext context) {
    Get.defaultDialog(
        title: "Hapus semua data",
        content: Text("Yakin ingin menghapus semua data?"),
        cancel: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Tidak")),
        confirm: FilledButton(
            onPressed: () async {
              Get.back(); // Tutup dialog konfirmasi
              final allMatkulProvider = Get.find<JadwalkuliahController>();

              allMatkulProvider.clearAllData();
            },
            child: const Text("Ya")));
  }

  Drawer howTo = const Drawer(
    child: DrawerGuide(),
  );

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahController>();
    final jadwalKuliahDayProvider = Get.find<DayKuliahController>();

    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Jaku"),
        leading: Builder(
          builder: (context) => PopupMenuButton<String>(
            icon: const Icon(Icons.menu), // Burger Icon
            onSelected: (value) {
              if (value == "info") {
                _showInfoDialog(context);
              } else if (value == "logout") {
                _logout(context);
              } else if (value == "clear") {
                clearAllData(context);
              }
            },
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: "clear",
                child: ListTile(
                  leading: Icon(Icons.delete_sweep),
                  title: Text("Clear All Data"),
                ),
              ),
              const PopupMenuItem<String>(
                value: "info",
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text("Info"),
                ),
              ),
              const PopupMenuItem<String>(
                value: "logout",
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteNamed.addMatkul);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: howTo,
      body: Obx(() {
        final _ = allMatkulProvider.allMatkul;

        return FutureBuilder(
          future: _futureMatkul.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (allMatkulProvider.allMatkul.isEmpty) {
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
                          )),
                    ],
                  ),
                ),
              );
            } else {
              return Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: DayCardBuilder(
                      jadwalKuliahDayProvider: jadwalKuliahDayProvider,
                      allMatkulProvider: allMatkulProvider,
                    ),
                  )
                ],
              );
            }
          },
        );
      }),
    );
  }
}
