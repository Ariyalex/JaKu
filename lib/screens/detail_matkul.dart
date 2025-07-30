import 'package:flutter/material.dart';
import 'package:jaku/controllers/hari_kuliah_c.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/theme/theme.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:get/get.dart';

import '../controllers/jadwal_kuliah_c.dart';

class DetailMatkul extends StatefulWidget {
  static const routeName = "/detail-matkul";

  const DetailMatkul({super.key});

  @override
  State<DetailMatkul> createState() => _AddMatkulState();
}

class _AddMatkulState extends State<DetailMatkul> {
  final color = AppTheme.dark;

  final allMatkulProvider = Get.find<JadwalkuliahC>();
  final dayKuliahController = Get.find<HariKuliahC>();

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
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final matkulId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedMatkul = allMatkulProvider.selectById(matkulId)!;

    if (allMatkulProvider.matkulC.text.isEmpty) {
      allMatkulProvider.matkulC.text = selectedMatkul.matkul;
      allMatkulProvider.dosen1C.text = selectedMatkul.dosen1 ?? "";
      allMatkulProvider.dosen2C.text = selectedMatkul.dosen2 ?? "";
      allMatkulProvider.ruanganC.text = selectedMatkul.room ?? "";
      allMatkulProvider.kelas.value = selectedMatkul.kelas ?? "";
      allMatkulProvider.hari.value = selectedMatkul.day;
      allMatkulProvider.jamAwal.value = selectedMatkul.formattedJamAwal;
      allMatkulProvider.jamAkhir.value = selectedMatkul.formattedJamAkhir ?? "";
    }

    void editJadwal() async {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        // Wait for the update to complete
        await allMatkulProvider.updateMatkul(matkulId);

        // Close loading dialog
        Get.back();

        // Update grouped data
        dayKuliahController.getUniqueDays(allMatkulProvider);

        // Show success message
        Get.snackbar(
          "Success",
          "Jadwal berhasil diedit",
          backgroundColor: Colors.green.shade400,
        );

        // Clear form fields
        allMatkulProvider.matkulC.clear();
        allMatkulProvider.dosen1C.clear();
        allMatkulProvider.dosen2C.clear();
        allMatkulProvider.ruanganC.clear();
        allMatkulProvider.kelas.value = null;
        allMatkulProvider.jamAkhir.value = null;
        allMatkulProvider.jamAwal.value = null;
        allMatkulProvider.hari.value = null;

        // Return to previous screen
        Get.toNamed(RouteNamed.homePage);
      } catch (e) {
        // Close loading dialog
        Get.back();

        // Show error message
        Get.snackbar(
          "Error",
          "Gagal mengedit jadwal: ${e.toString()}",
          backgroundColor: color.colorScheme.error,
          colorText: color.colorScheme.onError,
        );
      }
    }

    String divider(String formattedJamAkhir) {
      if (formattedJamAkhir.isEmpty) {
        return " ";
      } else {
        return " - ";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Matkul"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: mediaQueryWidth,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                    hintText: "Ex: Basis Data",
                    labelText: "Matkul",
                    alignLabelWithHint: true),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: allMatkulProvider.matkulC,
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Dosen1",
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                  hintText: "Ex: Muhammad Didik Rohmad Wahyudi, S.T., MT. ",
                ),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: allMatkulProvider.dosen1C,
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                    hintText: "Ex: Muhammad Didik Rohmad Wahyudi, S.T., MT. ",
                    labelText: "Dosen2",
                    alignLabelWithHint: true),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: allMatkulProvider.dosen2C,
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
                    hintText: "Ex: fst-404",
                    labelText: "Ruang kelas",
                    alignLabelWithHint: true),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: allMatkulProvider.ruanganC,
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownSearch<String>(
                selectedItem: (allMatkulProvider.hari.value == "null")
                    ? null
                    : allMatkulProvider.hari.value,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                      hintText: "Pilih hari..."),
                ),
                suffixProps: const DropdownSuffixProps(
                  dropdownButtonProps: DropdownButtonProps(
                    iconOpened: Icon(Icons.keyboard_arrow_up),
                    iconClosed: Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isDisabled, isSelected) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        item,
                      ),
                    );
                  },
                  constraints: const BoxConstraints(maxHeight: 200),
                  menuProps: const MenuProps(
                    backgroundColor: Color(0xFF151515),
                    margin: EdgeInsets.only(top: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                items: (filter, loadProps) =>
                    allMatkulProvider.hariList.toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      allMatkulProvider.hari.value = value;
                    } else {
                      allMatkulProvider.hari.value = null;
                    }
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownSearch<String>(
                selectedItem: (allMatkulProvider.kelas.value == "null" ||
                        allMatkulProvider.kelas.value == "")
                    ? "Kelas belum dipilih"
                    : allMatkulProvider.kelas.value,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                      hintText: "Pilih kelas..."),
                ),
                suffixProps: const DropdownSuffixProps(
                  dropdownButtonProps: DropdownButtonProps(
                    iconOpened: Icon(Icons.keyboard_arrow_up),
                    iconClosed: Icon(Icons.keyboard_arrow_down),
                  ),
                ),
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isDisabled, isSelected) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(item),
                    );
                  },
                  constraints: const BoxConstraints(maxHeight: 200),
                  menuProps: const MenuProps(
                    backgroundColor: Color(0xFF151515),
                    margin: EdgeInsets.only(top: 12),
                    shape: RoundedRectangleBorder(
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
                  } else if (value == null) {
                    allMatkulProvider.kelas.value = "";
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (allMatkulProvider.jamAwal.value == null ||
                            allMatkulProvider.jamAwal.value == "null:null")
                        ? "Jam Kuliah"
                        : "${allMatkulProvider.jamAwal.value} ${divider(allMatkulProvider.jamAkhir.value!)} ${allMatkulProvider.jamAkhir.value}",
                    style: const TextStyle(fontSize: 19),
                  ),
                  FilledButton(
                    style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8))),
                    onPressed: () {
                      TimeRangePicker.show(
                        autoAdjust: true,
                        unSelectedEmpty: true,
                        context: context,
                        onSubmitted: (TimeRangeValue value) {
                          setState(() {
                            if (value.endTime != null) {
                              allMatkulProvider.jamAwal.value =
                                  "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                              allMatkulProvider.jamAkhir.value =
                                  "${value.endTime?.hour}:${value.endTime?.minute.toString().padLeft(2, '0')}";
                            } else {
                              allMatkulProvider.jamAwal.value =
                                  "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                              allMatkulProvider.jamAkhir.value = "";
                            }
                          });
                        },
                      );
                    },
                    child: const Text(
                      "Pilih Jam Matkul",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              OutlinedButton(
                  style: ButtonStyle(
                      alignment: Alignment.center,
                      fixedSize: WidgetStatePropertyAll(
                          Size.fromWidth(mediaQueryWidth * 1 / 3))),
                  onPressed: () {
                    if (allMatkulProvider.matkulC.text.isNotEmpty &&
                        allMatkulProvider.hari.value != null &&
                        allMatkulProvider.jamAwal.value != "null:null") {
                      editJadwal();
                    } else {
                      Get.defaultDialog(
                        contentPadding: EdgeInsets.all(10),
                        titlePadding: EdgeInsets.only(top: 20),
                        title: "Form tidak lengkap",
                        content: const Text("Harap Isi Matkul, Hari, dan Jam"),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        ],
                      );
                    }
                  },
                  // onPressed: addJadwal,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text("Simpan"), Icon(Icons.save)],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
