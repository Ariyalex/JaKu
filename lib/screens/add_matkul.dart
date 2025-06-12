import 'package:flutter/material.dart';
import 'package:jaku/controllers/add_matkul_c.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

import '../routes/route_named.dart';
import '../provider/jadwal_kuliah.dart';

class AddMatkul extends StatefulWidget {
  const AddMatkul({super.key});

  @override
  State<AddMatkul> createState() => _AddMatkulState();
}

class _AddMatkulState extends State<AddMatkul> {
  final addMatkulC = Get.put(AddMatkulC());
  final Set<String> hari = {
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jum'at",
    "Sabtu",
    "Minggu"
  };

  final Set<String> kelas = {"A", "B", "C", "D"};

  bool isFormValid() {
    return addMatkulC.matkulC.text.isNotEmpty &&
        addMatkulC.hari.value != null &&
        addMatkulC.jamAwal.value != null;
  }

  String divider(String formattedJamAkhir) {
    if (formattedJamAkhir.isEmpty) {
      return " ";
    } else {
      return " - ";
    }
  }

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Get.find<JadwalkuliahController>();
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    void addJadwal() {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        allMatkulProvider
            .addMatkuls(
                addMatkulC.matkulC.text,
                addMatkulC.kelas.value ?? "",
                addMatkulC.jamAwal.value ?? "",
                addMatkulC.jamAkhir.value ?? "",
                addMatkulC.dosen1C.text,
                addMatkulC.dosen2C.text,
                addMatkulC.ruanganC.text,
                addMatkulC.hari.value ?? "")
            .then(
          (response) {
            Get.back();
            Get.find<DayKuliahController>().getUniqueDays(allMatkulProvider);
            Get.snackbar("Success", "Jadwal berhasil ditambahkan",
                backgroundColor: Colors.green.shade400,
                snackPosition: SnackPosition.BOTTOM);
          },
        );

        addMatkulC.matkulC.clear();
        addMatkulC.dosen1C.clear();
        addMatkulC.dosen2C.clear();
        addMatkulC.ruanganC.clear();
        addMatkulC.kelas.value = null;
        addMatkulC.jamAkhir.value = null;
        addMatkulC.jamAwal.value = null;
        addMatkulC.hari.value = null;
      } catch (error) {
        // Close loading dialog
        Get.back();

        // Show error message
        Get.snackbar(
          "Error",
          "Gagal menambahkan jadwal: ${error.toString()}",
          backgroundColor: Colors.red.shade400,
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
                    labelText: "Matkul",
                    alignLabelWithHint: true),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: addMatkulC.matkulC,
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
                controller: addMatkulC.dosen1C,
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
                controller: addMatkulC.dosen2C,
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
                controller: addMatkulC.ruanganC,
              ),
              const SizedBox(
                height: 12,
              ),
              Obx(() => DropdownSearch<String>(
                    selectedItem: addMatkulC.hari.value,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17),
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
                    items: (filter, loadProps) => hari.toList(),
                    onChanged: (value) {
                      if (value != null) {
                        addMatkulC.hari.value = value;
                      } else {
                        addMatkulC.hari.value = "";
                      }
                    },
                  )),
              const SizedBox(
                height: 12,
              ),
              Obx(() => DropdownSearch<String>(
                    selectedItem: addMatkulC.kelas.value,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17),
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
                    items: (filter, loadProps) => kelas.toList(),
                    onChanged: (value) {
                      if (value != null) {
                        addMatkulC.kelas.value = value;
                      } else if (value == null || value == "") {
                        addMatkulC.kelas.value = null;
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

                    if (addMatkulC.jamAwal.value != null &&
                        addMatkulC.jamAwal.value != "null:null") {
                      //format jam awal
                      displayText = addMatkulC.jamAwal.value!;

                      //jika jam akhir ada
                      if (addMatkulC.jamAkhir.value != null &&
                          addMatkulC.jamAkhir.value!.isNotEmpty) {
                        displayText += " - ${addMatkulC.jamAkhir.value!}";
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
                            addMatkulC.jamAwal.value =
                                "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                            addMatkulC.jamAkhir.value =
                                "${value.endTime?.hour}:${value.endTime?.minute.toString().padLeft(2, '0')}";
                          } else if (value.startTime == null) {
                            addMatkulC.jamAwal.value = null;
                            addMatkulC.jamAkhir.value = null;
                          } else {
                            addMatkulC.jamAwal.value =
                                "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                            addMatkulC.jamAkhir.value = "";
                          }
                        },
                      );
                    },
                    child: const Text(
                      "Select Time",
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
                    if (addMatkulC.matkulC.text.isNotEmpty &&
                        addMatkulC.hari.value != null &&
                        addMatkulC.jamAwal.value != null) {
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
