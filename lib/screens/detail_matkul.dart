import 'package:flutter/material.dart';
import 'package:jaku/controllers/edit_matkul_c.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:get/get.dart';

import '../provider/jadwal_kuliah.dart';

class DetailMatkul extends StatefulWidget {
  static const routeName = "/detail-matkul";

  const DetailMatkul({super.key});

  @override
  State<DetailMatkul> createState() => _AddMatkulState();
}

class _AddMatkulState extends State<DetailMatkul> {
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

  @override
  Widget build(BuildContext context) {
    final editC = Get.put(EditMatkulC());
    final allMatkulProvider = Get.find<JadwalkuliahController>();
    final dayKuliahController = Get.find<DayKuliahController>();

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final matkulId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedMatkul = allMatkulProvider.selectById(matkulId)!;

    if (editC.matkulC.text.isEmpty) {
      editC.matkulC.text = selectedMatkul.matkul;
      editC.dosen1C.text = selectedMatkul.dosen1 ?? "";
      editC.dosen2C.text = selectedMatkul.dosen2 ?? "";
      editC.ruanganC.text = selectedMatkul.room ?? "";
      editC.kelas.value = selectedMatkul.kelas;
      editC.hari.value = selectedMatkul.day;
      editC.jamAwal.value = selectedMatkul.formattedJamAwal;
      editC.jamAkhir.value = selectedMatkul.formattedJamAkhir!;
    }
    void editJadwal() async {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        // Wait for the update to complete
        await allMatkulProvider.updateMatkul(
          matkulId,
          editC.matkulC.text,
          editC.kelas.value ?? "",
          editC.jamAwal.value ?? "",
          editC.jamAkhir.value ?? "",
          editC.dosen1C.text,
          editC.dosen2C.text,
          editC.ruanganC.text,
          editC.hari.value ?? "",
        );

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
        editC.matkulC.clear();
        editC.dosen1C.clear();
        editC.dosen2C.clear();
        editC.ruanganC.clear();
        editC.kelas.value = null;
        editC.jamAkhir.value = null;
        editC.jamAwal.value = null;
        editC.hari.value = null;

        // Return to previous screen
        Get.toNamed(RouteNamed.homePage);
      } catch (e) {
        // Close loading dialog
        Get.back();

        // Show error message
        Get.snackbar(
          "Error",
          "Gagal mengedit jadwal: ${e.toString()}",
          backgroundColor: Colors.red.shade400,
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
                controller: editC.matkulC,
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
                controller: editC.dosen1C,
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
                controller: editC.dosen2C,
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
                controller: editC.ruanganC,
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownSearch<String>(
                selectedItem:
                    (editC.hari.value == "null") ? null : editC.hari.value,
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
                items: (filter, loadProps) => hari.toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      editC.hari.value = value;
                    } else {
                      editC.hari.value = null;
                    }
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownSearch<String>(
                selectedItem:
                    (editC.kelas.value == "null" || editC.kelas.value == "")
                        ? "Kelas belum dipilih"
                        : editC.kelas.value,
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
                items: (filter, loadProps) => kelas.toList(),
                onChanged: (value) {
                  if (value != null) {
                    editC.kelas.value = value;
                  } else if (value == null) {
                    editC.kelas.value = "";
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
                    (editC.jamAwal.value == null ||
                            editC.jamAwal.value == "null:null")
                        ? "Jam Kuliah"
                        : "${editC.jamAwal.value} ${divider(editC.jamAkhir.value!)} ${editC.jamAkhir.value}",
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
                              editC.jamAwal.value =
                                  "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                              editC.jamAkhir.value =
                                  "${value.endTime?.hour}:${value.endTime?.minute.toString().padLeft(2, '0')}";
                            } else {
                              editC.jamAwal.value =
                                  "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                              editC.jamAkhir.value = "";
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
                    if (editC.matkulC.text.isNotEmpty &&
                        editC.hari.value != null &&
                        editC.jamAwal.value != "null:null") {
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
