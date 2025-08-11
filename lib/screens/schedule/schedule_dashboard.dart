import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hive/hive.dart';
import 'package:jaku/controllers/matkul_controllers/pdf_back.dart';
import 'package:jaku/controllers/theme_c.dart';
import 'package:jaku/widgets/schedule_widgets/add_matkul.dart';
import 'package:jaku/widgets/schedule_widgets/card_view/card_view.dart';
import 'package:get/get.dart';
import 'package:jaku/widgets/schedule_widgets/table_view/table_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../controllers/matkul_controllers/hari_kuliah_c.dart';
import '../../controllers/matkul_controllers/jadwal_kuliah_c.dart';
import '../../routes/route_named.dart';

import 'dart:math' as math;

class ScheduleDashboard extends StatefulWidget {
  const ScheduleDashboard({super.key});
  static const routeName = "/home";

  @override
  State<ScheduleDashboard> createState() => _ScheduleDashboardState();
}

class _ScheduleDashboardState extends State<ScheduleDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late JadwalkuliahC jadwalKuliahC;
  late HariKuliahC hariKuliahC;

  final GlobalKey<ExpandableFabState> fabKey = GlobalKey<ExpandableFabState>();

  RxBool isCardView = true.obs;

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<JadwalkuliahC>();
    Get.delete<HariKuliahC>();
    Get.delete<PdfBack>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    jadwalKuliahC = Get.put(JadwalkuliahC());
    hariKuliahC = Get.put(HariKuliahC());
    Get.put(PdfBack());
    loadViewValue();
    hariKuliahC.getOrderedDays();
  }

  Future<void> loadViewValue() async {
    // Pakai Hive untuk menyimpan setting
    final box = await Hive.openBox('settings');
    final hasil = box.get('cardView') as bool?;
    isCardView.value = hasil ?? true;
  }

  Future<void> saveViewValue(bool value) async {
    final box = await Hive.openBox('settings');
    await box.put('cardView', value);
  }

  static void clearAllData(BuildContext context) {
    Get.defaultDialog(
      title: "Hapus semua data?",
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      content: const Text(
        "Yakin ingin menghapus semua data termasuk semua note dan task yang berhubungan dengan matkul?",
        textAlign: TextAlign.center,
      ),
      cancel: FilledButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("Tidak"),
      ),
      confirm: OutlinedButton(
        onPressed: () async {
          Get.back(); // Tutup dialog konfirmasi
          final allMatkulProvider = Get.find<JadwalkuliahC>();

          allMatkulProvider.clearAllData();
        },
        child: const Text("Ya"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    final themeC = Get.find<ThemeC>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                child: ListTile(leading: Icon(Icons.info), title: Text("Info")),
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
                  ? Text(
                      "Card view",
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorTheme.primary,
                      ),
                    )
                  : Text(
                      "Table view",
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorTheme.onPrimary,
                      ),
                    ),
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
                  BorderSide(width: 1, color: colorTheme.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            onPressed: () => themeC.changeTheme(),
            icon: Icon(Icons.color_lens),
          ),
        ],
      ),
      body: Obx(() {
        return SafeArea(
          child: isCardView.value
              ? const CardView()
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TableView(),
                ),
        );
      }),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: fabKey,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(LucideIcons.plus),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
          angle: math.pi / 4,
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          child: Transform.rotate(
            angle: math.pi / 4,
            child: const Icon(LucideIcons.plus),
          ),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
        ),
        type: ExpandableFabType.up,
        duration: Duration(milliseconds: 340),
        childrenAnimation: ExpandableFabAnimation.none,
        distance: 70,
        overlayStyle: ExpandableFabOverlayStyle(
          color: colorTheme.surface.withValues(alpha: 0.7),
        ),
        children: [
          Row(
            children: [
              Text('PDF to Schedule', style: textTheme.bodyLarge),
              SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  fabKey.currentState?.close();
                  Get.defaultDialog(
                    title: "Peringatan!!",
                    backgroundColor: theme.dialogTheme.backgroundColor,
                    titlePadding: EdgeInsets.only(top: 20),
                    titleStyle: TextStyle(fontWeight: FontWeight.bold),
                    content: const Text(
                      "Fitur ini hanya untuk\nmahasiswa UIN SUKA.\nAdd matkul menggunakan file PDF yang didapat dari SIA UIN SUKA",
                      textAlign: TextAlign.center,
                    ),
                    contentPadding: EdgeInsets.all(10),
                    confirm: FilledButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(RouteNamed.pdfParsing);
                      },
                      child: const Text("Ok Bang"),
                    ),
                    cancel: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Ga jadi"),
                    ),
                  );
                },
                child: Icon(LucideIcons.filePlus2),
              ),
            ],
          ),
          Row(
            children: [
              Text('Add Schedule', style: textTheme.bodyLarge),
              SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  fabKey.currentState?.close();
                  await showBarModalBottomSheet<Map<String, dynamic>>(
                    barrierColor: Colors.black.withValues(alpha: 0.4),
                    context: context,
                    useRootNavigator: true,
                    bounce: true,
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    builder: (context) => const AddMatkul(),
                  );
                },
                child: Icon(LucideIcons.plus),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
