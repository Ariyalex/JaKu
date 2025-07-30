import 'package:flutter/material.dart';
import 'package:jaku/theme/theme.dart';
import 'package:jaku/widgets/card_view/card_view.dart';
import 'package:get/get.dart';
import 'package:jaku/widgets/table_view/table_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/hari_kuliah_c.dart';
import '../controllers/jadwal_kuliah_c.dart';
import '../routes/route_named.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final allMatkulProvider = Get.find<JadwalkuliahC>();
  final jadwalKuliahDayProvider = Get.find<HariKuliahC>();

  final color = AppTheme.dark;

  RxBool isCardView = true.obs;

  @override
  void initState() {
    super.initState();
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

  static void clearAllData(BuildContext context) {
    Get.defaultDialog(
        title: "Hapus semua data",
        backgroundColor: AppTheme.dark.dialogTheme.backgroundColor,
        content: const Text("Yakin ingin menghapus semua data?"),
        cancel: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Tidak")),
        confirm: FilledButton(
            onPressed: () async {
              Get.back(); // Tutup dialog konfirmasi
              final allMatkulProvider = Get.find<JadwalkuliahC>();

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
          title: const Text("Jaku"),
          leading: Builder(
            builder: (context) => PopupMenuButton<String>(
              icon: const Icon(Icons.menu), // Burger Icon
              onSelected: (value) {
                if (value == "info") {
                  Get.toNamed(RouteNamed.guideGeneral);
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
              ],
            ),
          ),
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
            IconButton(
              onPressed: () {
                Get.toNamed(RouteNamed.addMatkul);
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        body: Obx(
          () {
            return isCardView.value
                ? Container(
                    padding: const EdgeInsets.only(bottom: 40, top: 8),
                    child: const CardView(),
                  )
                : Container(
                    padding: const EdgeInsets.only(
                        right: 8, left: 8, top: 8, bottom: 40),
                    child: TableView(),
                  );
          },
        ));
  }
}
