import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

class AddJadwal extends HookWidget {
  const AddJadwal({super.key});

  String divider(String formattedJamAkhir) {
    if (formattedJamAkhir.isEmpty) {
      return " ";
    } else {
      return " - ";
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final theme = Theme.of(context);

    //   allMatkulProvider.matkulNameC.clear();
    //   allMatkulProvider.dosen1C.clear();
    //   allMatkulProvider.dosen2C.clear();
    //   allMatkulProvider.ruanganC.clear();
    //   allMatkulProvider.kelas.value = null;
    //   allMatkulProvider.jamAkhir.value = null;
    //   allMatkulProvider.jamAwal.value = null;
    //   allMatkulProvider.hari.value = null;

    final scheduleRoomTextC = useTextEditingController();
    final selectedDay = useState<Day?>(null);
    final selectedStartTime = useState<TimeOfDay?>(null);
    final selectedEndTime = useState<TimeOfDay?>(null);

    // void addJadwal() async {
    //   Get.dialog(
    //     const Center(child: CircularProgressIndicator()),
    //     barrierDismissible: false,
    //   );

    //   try {
    //     await allMatkulProvider.addSchedules();

    //     Get.back();

    //     Get.find<HariKuliahC>().getUniqueDays(allMatkulProvider);

    //     showAppSnackbar(
    //       title: "Success",
    //       message: "Jadwal berhasil ditambahkan",
    //     );

    //     //clear controller
    //     allMatkulProvider.matkulNameC.clear();
    //     allMatkulProvider.dosen1C.clear();
    //     allMatkulProvider.dosen2C.clear();
    //     allMatkulProvider.ruanganC.clear();
    //     allMatkulProvider.kelas.value = null;
    //     allMatkulProvider.jamAkhir.value = null;
    //     allMatkulProvider.jamAwal.value = null;
    //     allMatkulProvider.hari.value = null;
    //   } catch (error) {
    //     // Close loading dialog
    //     Get.back();

    //     // Show error message
    //     showAppSnackbar(
    //       title: "Error",
    //       message: "Gagal menambahkan jadwal: ${error.toString()}",
    //       isSuccess: false,
    //     );
    //   }
    // }

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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Column(
                spacing: 12,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Ex: fst-404",
                      labelText: "Ruang kelas",
                      alignLabelWithHint: true,
                    ),
                    autocorrect: false,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    textInputAction: TextInputAction.next,
                    controller: scheduleRoomTextC,
                  ),
                  DropdownSearch<Day>(
                    selectedItem: selectedDay.value,
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
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    items: (filter, loadProps) => Day.getAllDay(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedDay.value = value;
                      } else {
                        selectedDay.value = null;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        String displayText = "Jam Kuliah*";

                        // if (allMatkulProvider.jamAwal.value != null &&
                        //     allMatkulProvider.jamAwal.value != "null:null") {
                        //   //format jam awal
                        //   displayText = allMatkulProvider.jamAwal.value!;

                        //   //jika jam akhir ada
                        //   if (allMatkulProvider.jamAkhir.value != null &&
                        //       allMatkulProvider.jamAkhir.value!.isNotEmpty) {
                        //     displayText +=
                        //         " - ${allMatkulProvider.jamAkhir.value!}";
                        //   }
                        // }
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
                              selectedStartTime.value = value.startTime;
                              selectedEndTime.value = value.endTime;
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
                        // if (allMatkulProvider.matkulNameC.text.isNotEmpty &&
                        //     allMatkulProvider.hari.value != null &&
                        //     allMatkulProvider.jamAwal.value != null) {
                        //   addJadwal();
                        // } else {
                        //   Get.defaultDialog(
                        //     contentPadding: const EdgeInsets.all(10),
                        //     titlePadding: const EdgeInsets.only(top: 20),
                        //     title: "Form tidak lengkap",
                        //     content: const Text(
                        //       "Harap Isi Matkul, Hari, dan Jam",
                        //     ),
                        //     actions: [
                        //       FilledButton(
                        //         onPressed: () {
                        //           Get.back();
                        //         },
                        //         child: const Text(
                        //           "OK",
                        //           style: TextStyle(fontSize: 17),
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // }
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
