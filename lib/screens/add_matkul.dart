import 'package:flutter/material.dart';
import 'package:jaku/controllers/hari_kuliah.dart';
import 'package:jaku/theme/theme.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

import '../routes/route_named.dart';
import '../controllers/jadwal_kuliah.dart';

class AddMatkul extends StatefulWidget {
  const AddMatkul({super.key});

  @override
  State<AddMatkul> createState() => _AddMatkulState();
}

class _AddMatkulState extends State<AddMatkul> {
  final allMatkulProvider = Get.find<JadwalkuliahController>();
  final color = AppTheme.dark;

  String divider(String formattedJamAkhir) {
    if (formattedJamAkhir.isEmpty) {
      return " ";
    } else {
      return " - ";
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    void addJadwal() async {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        await allMatkulProvider.addMatkuls();

        Get.back();

        Get.find<DayKuliahController>().getUniqueDays(allMatkulProvider);
        Get.snackbar(
          "Success",
          "Jadwal berhasil ditambahkan",
          backgroundColor: Colors.green.shade400,
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
          backgroundColor: color.colorScheme.error,
          colorText: color.colorScheme.onError,
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Add Matkul"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Peringatan!!",
                  backgroundColor: AppTheme.dark.dialogTheme.backgroundColor,
                  titlePadding: EdgeInsets.only(top: 20),
                  titleStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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
                      child: const Text("Ok Bang")),
                  cancel: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Ga jadi")),
                );
              },
              icon: const Icon(Icons.picture_as_pdf)),
        ],
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
                    labelText: "Matkul*",
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
              Obx(() => DropdownSearch<String>(
                    selectedItem: allMatkulProvider.hari.value,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17),
                          hintText: "Pilih hari*"),
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
                      if (value != null) {
                        allMatkulProvider.hari.value = value;
                      } else {
                        allMatkulProvider.hari.value = "";
                      }
                    },
                  )),
              const SizedBox(
                height: 12,
              ),
              Obx(() => DropdownSearch<String>(
                    selectedItem: allMatkulProvider.kelas.value,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17),
                          hintText: "Pilih kelas"),
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
                      } else if (value == null || value == "") {
                        allMatkulProvider.kelas.value = null;
                      }
                    },
                  )),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    String displayText = "Jam Kuliah";

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
                    return Text(
                      displayText,
                      style: const TextStyle(fontSize: 18),
                    );
                  }),
                  TextButton(
                    style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8))),
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
                    child: const Text(
                      "Select Time*",
                      style: TextStyle(fontSize: 20),
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
                        allMatkulProvider.jamAwal.value != null) {
                      addJadwal();
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
                    children: [
                      Text("Simpan"),
                      Icon(Icons.save),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
