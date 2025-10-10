import 'package:flutter/material.dart';
import 'package:jaku/controllers/jadwal_controllers/hari_kuliah_c.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/utils/snackbar_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:get/get.dart';

import '../../controllers/jadwal_controllers/jadwal_kuliah_c.dart';

class EditJadwal extends StatefulWidget {
  const EditJadwal({super.key, required this.jadwalId});

  final String jadwalId;

  @override
  State<EditJadwal> createState() => _AddMatkulState();
}

class _AddMatkulState extends State<EditJadwal> {
  final allMatkulProvider = Get.find<JadwalkuliahC>();
  final dayKuliahController = Get.find<HariKuliahC>();

  @override
  void initState() {
    super.initState();
    allMatkulProvider.matkulNameC.clear();
    allMatkulProvider.dosen1C.clear();
    allMatkulProvider.dosen2C.clear();
    allMatkulProvider.ruanganC.clear();
    allMatkulProvider.kelas.value = null;
    allMatkulProvider.jamAkhir.value = null;
    allMatkulProvider.jamAwal.value = null;
    allMatkulProvider.hari.value = null;

    final selectedMatkul = allMatkulProvider.selectById(widget.jadwalId)!;

    if (allMatkulProvider.matkulNameC.text.isEmpty) {
      allMatkulProvider.matkulNameC.text = selectedMatkul.matkul;
      allMatkulProvider.dosen1C.text = selectedMatkul.dosen1 ?? "";
      allMatkulProvider.dosen2C.text = selectedMatkul.dosen2 ?? "";
      allMatkulProvider.ruanganC.text = selectedMatkul.room ?? "";
      allMatkulProvider.kelas.value = selectedMatkul.kelas ?? "";
      allMatkulProvider.hari.value = selectedMatkul.day;
      allMatkulProvider.jamAwal.value = selectedMatkul.formattedJamAwal;
      allMatkulProvider.jamAkhir.value = selectedMatkul.formattedJamAkhir ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final theme = Theme.of(context);

    void editJadwal() async {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        // Wait for the update to complete
        await allMatkulProvider.updateSchedule(widget.jadwalId);

        // Close loading dialog
        Get.back();

        // Update grouped data
        dayKuliahController.getUniqueDays(allMatkulProvider);

        // Show success message
        showAppSnackbar(title: "Success", message: "Jadwal berhasil diedit");

        // Clear form fields
        allMatkulProvider.matkulNameC.clear();
        allMatkulProvider.dosen1C.clear();
        allMatkulProvider.dosen2C.clear();
        allMatkulProvider.ruanganC.clear();
        allMatkulProvider.kelas.value = null;
        allMatkulProvider.jamAkhir.value = null;
        allMatkulProvider.jamAwal.value = null;
        allMatkulProvider.hari.value = null;

        // Return to previous screen
        Get.toNamed(RouteNamed.scheduleDashboard);
      } catch (e) {
        // Close loading dialog
        Get.back();

        showAppSnackbar(
          title: "Error!",
          message: "Gagal mengedit jadwal: $e",
          isSuccess: false,
        );
      }
    }

    return Material(
      child: SafeArea(
        child: Container(
          width: mediaQueryWidth,
          padding: EdgeInsets.only(
            right: 20,
            left: 20,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                Column(
                  spacing: 12,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Ex: Basis Data",
                        labelText: "Matkul*",
                        alignLabelWithHint: true,
                      ),
                      autocorrect: false,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                      textInputAction: TextInputAction.next,
                      controller: allMatkulProvider.matkulNameC,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Dosen1",
                        hintText:
                            "Ex: Muhammad Didik Rohmad Wahyudi, S.T., MT. ",
                      ),
                      autocorrect: false,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                      textInputAction: TextInputAction.next,
                      controller: allMatkulProvider.dosen1C,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText:
                            "Ex: Muhammad Didik Rohmad Wahyudi, S.T., MT. ",
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
                        decoratorProps: const DropDownDecoratorProps(
                          decoration: InputDecoration(hintText: "Pilih hari*"),
                        ),
                        popupProps: PopupProps.menu(
                          constraints: const BoxConstraints(maxHeight: 200),
                          menuProps: MenuProps(
                            align: MenuAlign.bottomStart,
                            backgroundColor: theme.colorScheme.surfaceContainer,
                            margin: const EdgeInsets.only(top: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
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
                        decoratorProps: const DropDownDecoratorProps(
                          decoration: InputDecoration(hintText: "Pilih kelas"),
                        ),
                        popupProps: PopupProps.menu(
                          constraints: const BoxConstraints(maxHeight: 225),
                          menuProps: MenuProps(
                            align: MenuAlign.topStart,
                            backgroundColor: theme.colorScheme.surfaceContainer,
                            margin: const EdgeInsets.only(top: 12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
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
                          icon: const Icon(
                            LucideIcons.clockFading500,
                            size: 20,
                          ),
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
                          if (allMatkulProvider.matkulNameC.text.isNotEmpty &&
                              allMatkulProvider.hari.value != null &&
                              allMatkulProvider.jamAwal.value != null) {
                            editJadwal();
                          } else {
                            Get.defaultDialog(
                              contentPadding: const EdgeInsets.all(10),
                              titlePadding: const EdgeInsets.only(top: 20),
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
      ),
    );
  }
}
