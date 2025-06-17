import 'package:flutter/material.dart';
import 'package:jaku/provider/auth.dart';
import 'package:jaku/provider/internet_check.dart';
import 'package:jaku/provider/version_control.dart';
import 'package:jaku/theme/theme.dart';
import 'package:jaku/widgets/card_view/card_view.dart';
import 'package:get/get.dart';
import 'package:jaku/widgets/table_view/table_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/hari_kuliah.dart';
import '../provider/jadwal_kuliah.dart';
import '../routes/route_named.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final connectionStatus = Get.find<InternetCheck>().isOnline;
  final allMatkulProvider = Get.find<JadwalkuliahController>();
  final jadwalKuliahDayProvider = Get.find<DayKuliahController>();
  final authController = Get.find<AuthController>();
  final versionControl = Get.put(VersionControl());

  final color = AppTheme.dark;

  RxBool isCardView = true.obs;

  final Rx<Future<void>?> _futureMatkul = Rx<Future<void>?>(null);

  @override
  void initState() {
    super.initState();
    loadData();
    loadViewValue();
    jadwalKuliahDayProvider.getOrderedDays();
  }

  Future<void> loadViewValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final hasil = pref.getBool("cardView");
    isCardView.value = hasil ?? true;
  }

  Future<void> saveViewValue(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("cardView", value);
  }

  void loadData() {
    _futureMatkul.value = allMatkulProvider.getOnce().then(
      (_) {
        jadwalKuliahDayProvider.getUniqueDays(allMatkulProvider);
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

  static void _logout(BuildContext context) {
    final color = AppTheme.dark;
    Get.defaultDialog(
        title: "Log Out",
        backgroundColor: AppTheme.dark.dialogTheme.backgroundColor,
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
              } catch (e) {
                // Tutup loading dialog jika terjadi error
                Get.back();

                // Tampilkan pesan error
                Get.snackbar(
                  'Gagal Logout',
                  'Terjadi kesalahan: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: color.colorScheme.error,
                  colorText: color.colorScheme.onError,
                );
              }
            },
            child: const Text("Ya")));
  }

  static void clearAllData(BuildContext context) {
    Get.defaultDialog(
        title: "Hapus semua data",
        backgroundColor: AppTheme.dark.dialogTheme.backgroundColor,
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

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppTheme.dark.colorScheme;
    final textTheme = AppTheme.dark.textTheme;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            children: [
              Obx(
                () {
                  if (connectionStatus.value == false) {
                    return const Text("Jaku Offline mode");
                  } else {
                    return const Text("Jaku");
                  }
                },
              )
            ],
          ),
          leading: Obx(() {
            if (connectionStatus.value == true) {
              return Builder(
                builder: (context) => PopupMenuButton<String>(
                  icon: const Icon(Icons.menu), // Burger Icon
                  onSelected: (value) {
                    if (value == "info") {
                      Get.toNamed(RouteNamed.guideGeneral);
                    } else if (value == "logout") {
                      _logout(context);
                    } else if (value == "clear") {
                      clearAllData(context);
                    }
                  },

                  position: PopupMenuPosition.under,
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: "info",
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text("Info"),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: "clear",
                      child: ListTile(
                        leading: Icon(Icons.delete_sweep),
                        title: Text("Clear All Data"),
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
              );
            } else {
              return Builder(
                builder: (context) => PopupMenuButton<String>(
                  icon: const Icon(Icons.menu), // Burger Icon
                  onSelected: (value) {
                    if (value == "info") {
                      Get.toNamed(RouteNamed.guideGeneral);
                    }
                  },
                  position: PopupMenuPosition.under,
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: "info",
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text("Info"),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
          actions: [
            Obx(
              () => TextButton.icon(
                onPressed: () {
                  isCardView.value = !isCardView.value;
                  saveViewValue(isCardView.value);
                },
                label: isCardView.value
                    ? Text("Card view",
                        style: textTheme.bodyMedium!
                            .copyWith(color: colorTheme.primary))
                    : Text("Table view",
                        style: textTheme.bodyMedium!
                            .copyWith(color: colorTheme.onPrimary)),
                icon: isCardView.value
                    ? Icon(Icons.view_agenda_outlined)
                    : Icon(Icons.table_chart),
                style: ButtonStyle(
                    backgroundColor: isCardView.value
                        ? null
                        : WidgetStatePropertyAll(colorTheme.primary),
                    iconColor: isCardView.value
                        ? null
                        : WidgetStatePropertyAll(colorTheme.onPrimary),
                    side: WidgetStatePropertyAll(
                        BorderSide(width: 1, color: colorTheme.primary))),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Obx(() {
              if (connectionStatus.value == true && authController.isLoggedIn) {
                return IconButton(
                  onPressed: () {
                    Get.toNamed(RouteNamed.addMatkul);
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                );
              } else if (authController.isLoggedIn &&
                  connectionStatus.value == false) {
                return const SizedBox.shrink();
              } else {
                return IconButton(
                    onPressed: () {
                      Get.offNamed(RouteNamed.signInScreen);
                    },
                    icon: const Icon(Icons.login));
              }
            }),
          ],
        ),
        body: Obx(
          () {
            return isCardView.value
                ? Container(
                    padding: const EdgeInsets.only(bottom: 40, top: 8),
                    child: CardView(futureMatkul: _futureMatkul),
                  )
                : Container(
                    padding: const EdgeInsets.only(
                        right: 8, left: 8, top: 8, bottom: 40),
                    child: TableView(
                      futureMatkul: _futureMatkul,
                    ),
                  );
          },
        ));
  }
}
