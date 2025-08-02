import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/jadwal_kuliah_c.dart';
import 'package:jaku/screens/schedule/edit_matkul.dart';
import 'package:jaku/widgets/schedule_widget/informasi_matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailMatkul extends StatelessWidget {
  const DetailMatkul({super.key});

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahC>();

    final deviceWidth = Get.width;
    final deviceHeight = Get.height;

    final theme = Theme.of(context);

    final matkulId = Get.arguments as String;
    final selectedMatkul = allMatkulProvider.selectById(matkulId)!;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        // title: Text(
        //   "",
        //   textAlign: TextAlign.left,
        // ),
        actions: [
          IconButton(
            onPressed: () async {
              await showBarModalBottomSheet<Map<String, dynamic>>(
                barrierColor: Colors.black.withValues(alpha: 0.4),
                context: context,
                useRootNavigator: true,
                builder: (context) => EditMatkul(matkulId: matkulId),
              );
            },
            icon: const Icon(LucideIcons.squarePen),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InformasiMatkul(matkul: selectedMatkul),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
