import 'package:flutter/material.dart';
import 'package:jaku/controllers/matkul_controllers/hari_kuliah_c.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

import '../../controllers/matkul_controllers/jadwal_kuliah_c.dart';

class AddJadwal extends StatefulWidget {
  const AddJadwal({super.key});

  @override
  State<AddJadwal> createState() => _AddJadwalState();
}

class _AddJadwalState extends State<AddJadwal> {
  final allMatkulProvider = Get.find<JadwalkuliahC>();

  String divider(String formattedJamAkhir) {
    if (formattedJamAkhir.isEmpty) {
      return " ";
    } else {
      return " - ";
    }
  }

  @override
  void initState() {
    super.initState();
    allMatkulProvider.matkulC.clear();
    allMatkulProvider.dosen1C.clear();
    allMatkulProvider.dosen2C.clear();
    allMatkulProvider.ruanganC.clear();
    allMatkulProvider.kelas.value = null;
    allMatkulProvider.jamAkhir.value = null;
    allMatkulProvider.jamAwal.value = null;
    allMatkulProvider.hari.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final theme = Theme.of(context);

    void addJadwal() async {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        await allMatkulProvider.addSchedules();

        Get.back();

        Get.find<HariKuliahC>().getUniqueDays(allMatkulProvider);
        Get.snackbar(
          "Success",
          "Jadwal berhasil ditambahkan",
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
        );

        //clear controller
        allMatkulProvider.matkulC.clear();
        allMatkulProvider.dosen1C.clear();
        allMatkulProvider.dosen2C.clear();
        allMatkulProvider.ruanganC.clear();
        allMatkulProvider.kelas.value = null;
        allMatkulProvider.jamAkhir.value = null;
        allMatkulProvider.jamAwal.value = null;
        allMatkulProvider.hari.value = null;
      } catch (error) {
        // Close loading dialog
        Get.back();

        // Show error message
        Get.snackbar(
          "Error",
          "Gagal menambahkan jadwal: ${error.toString()}",
          backgroundColor: theme.colorScheme.error,
          colorText: theme.colorScheme.onError,
        );
      }
    }

    return SafeArea(
      child: Container(
        width: mediaQueryWidth,
        padding: EdgeInsets.only(
          right: 20,
          left: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Column(
                spacing: 12,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Ex: Basis Data",
                      labelText: "Matkul*",
                      alignLabelWithHint: true,
                    ),
                    autocorrect: false,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    textInputAction: TextInputAction.next,
                    controller: allMatkulProvider.matkulC,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Dosen1",
                      hintText: "Ex: Muhammad Didik Rohmad Wahyudi, S.T., MT. ",
                    ),
                    autocorrect: false,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    textInputAction: TextInputAction.next,
                    controller: allMatkulProvider.dosen1C,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Ex: Muhammad Didik Rohmad Wahyudi, S.T., MT. ",
                      labelText: "Dosen2",
                      alignLabelWithHint: true,
                    ),
                    autocorrect: false,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    textInputAction: TextInputAction.next,
                    controller: allMatkulProvider.dosen2C,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Ex: fst-404",
                      labelText: "Ruang kelas",
                      alignLabelWithHint: true,
                    ),
                    autocorrect: false,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    textInputAction: TextInputAction.next,
                    controller: allMatkulProvider.ruanganC,
                  ),
                  Obx(
                    () => DropdownSearch<String>(
                      selectedItem: allMatkulProvider.hari.value,
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(hintText: "Pilih hari*"),
                      ),
                      popupProps: PopupProps.menu(
                        constraints: const BoxConstraints(maxHeight: 200),
                        menuProps: MenuProps(
                          align: MenuAlign.bottomStart,
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          margin: EdgeInsets.only(top: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      items: (filter, loadProps) =>
                          allMatkulProvider.hariList.toList(),
                      onChanged: (value) {
                        if (value != null) {
                          allMatkulProvider.hari.value = value;
                        } else {
                          allMatkulProvider.hari.value = "";
                        }
                      },
                    ),
                  ),
                  Obx(
                    () => DropdownSearch<String>(
                      selectedItem: allMatkulProvider.kelas.value,
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(hintText: "Pilih kelas"),
                      ),
                      popupProps: PopupProps.menu(
                        constraints: const BoxConstraints(maxHeight: 225),
                        menuProps: MenuProps(
                          align: MenuAlign.topStart,
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          margin: EdgeInsets.only(top: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      items: (filter, loadProps) =>
                          allMatkulProvider.kelasList.toList(),
                      onChanged: (value) {
                        if (value != null) {
                          allMatkulProvider.kelas.value = value;
                        } else if (value == null || value == "") {
                          allMatkulProvider.kelas.value = null;
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        String displayText = "Jam Kuliah*";

                        if (allMatkulProvider.jamAwal.value != null &&
                            allMatkulProvider.jamAwal.value != "null:null") {
                          //format jam awal
                          displayText = allMatkulProvider.jamAwal.value!;

                          //jika jam akhir ada
                          if (allMatkulProvider.jamAkhir.value != null &&
                              allMatkulProvider.jamAkhir.value!.isNotEmpty) {
                            displayText +=
                                " - ${allMatkulProvider.jamAkhir.value!}";
                          }
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: BoxBorder.all(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          child: Text(
                            displayText,
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }),
                      FilledButton.icon(
                        onPressed: () {
                          TimeRangePicker.show(
                            autoAdjust: true,
                            unSelectedEmpty: true,
                            context: context,
                            onSubmitted: (TimeRangeValue value) {
                              if (value.endTime != null) {
                                allMatkulProvider.jamAwal.value =
                                    "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                                allMatkulProvider.jamAkhir.value =
                                    "${value.endTime?.hour}:${value.endTime?.minute.toString().padLeft(2, '0')}";
                              } else if (value.startTime == null) {
                                allMatkulProvider.jamAwal.value = null;
                                allMatkulProvider.jamAkhir.value = null;
                              } else {
                                allMatkulProvider.jamAwal.value =
                                    "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                                allMatkulProvider.jamAkhir.value = "";
                              }
                            },
                          );
                        },
                        label: Text(
                          "Select",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        icon: const Icon(LucideIcons.clockFading500, size: 20),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("(*) wajib diisi", style: theme.textTheme.labelLarge),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (allMatkulProvider.matkulC.text.isNotEmpty &&
                            allMatkulProvider.hari.value != null &&
                            allMatkulProvider.jamAwal.value != null) {
                          addJadwal();
                        } else {
                          Get.defaultDialog(
                            contentPadding: EdgeInsets.all(10),
                            titlePadding: EdgeInsets.only(top: 20),
                            title: "Form tidak lengkap",
                            content: const Text(
                              "Harap Isi Matkul, Hari, dan Jam",
                            ),
                            actions: [
                              FilledButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                      label: Text(
                        "Save",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      icon: const Icon(LucideIcons.save500, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
