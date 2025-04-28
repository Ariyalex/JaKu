import 'package:flutter/material.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
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

  String? hariController, kelasController;

  String? formattedJamAwal, formattedJamAkhir;

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Provider.of<Jadwalkuliah>(context);
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final matkulId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedMatkul = allMatkulProvider.selectById(matkulId);

    TextEditingController matkulController =
        TextEditingController(text: selectedMatkul!.matkul);
    TextEditingController dosen1Controller =
        TextEditingController(text: selectedMatkul.dosen1);
    TextEditingController dosen2Controller =
        TextEditingController(text: selectedMatkul.dosen2);
    TextEditingController ruanganController =
        TextEditingController(text: selectedMatkul.room);

    hariController ??= selectedMatkul.day;
    kelasController ??= selectedMatkul.kelas;
    formattedJamAwal ??= selectedMatkul.formattedJamAwal;
    formattedJamAkhir ??= selectedMatkul.formattedJamAkhir;

    void editJadwal() {
      allMatkulProvider
          .updateMatkul(
              matkulId,
              matkulController.text,
              kelasController.toString(),
              formattedJamAwal!,
              formattedJamAkhir.toString(),
              dosen1Controller.text,
              dosen2Controller.text,
              ruanganController.text,
              hariController!)
          .then(
        (response) {
          Provider.of<JadwalKuliahDay>(context, listen: false)
              .groupByDay(allMatkulProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Berhasil diedit"),
              duration: Duration(seconds: 1),
            ));
          }
        },
      ).then(
        (value) {
          setState(() {
            matkulController.clear();
            dosen1Controller.clear();
            dosen2Controller.clear();
            ruanganController.clear();
            kelasController = null;
            formattedJamAkhir = null;
            formattedJamAwal = null;
            hariController = null;
          });
        },
      );
      Navigator.pop(context);
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
        actions: [
          IconButton(
              onPressed: () {
                if (matkulController.text.isNotEmpty &&
                    hariController != null &&
                    formattedJamAwal != null) {
                  editJadwal();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Form tidak lengkap"),
                      content: const Text("Harap Isi Matkul, Hari, dan Jam"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "ok",
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save))
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
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    hintText: "Ex: Basis Data",
                    labelText: "Matkul",
                    alignLabelWithHint: true),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: matkulController,
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Dosen1",
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  hintText: "Ex: Muhammad Didik Rohmad Wahyudi, S.T., MT. ",
                ),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: dosen1Controller,
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    hintText: "Ex: Muhammad Didik Rohmad Wahyudi, S.T., MT. ",
                    labelText: "Dosen2",
                    alignLabelWithHint: true),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: dosen2Controller,
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    hintText: "Ex: fst-404",
                    labelText: "Ruang kelas",
                    alignLabelWithHint: true),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
                controller: ruanganController,
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownSearch<String>(
                selectedItem:
                    (hariController == "null") ? null : hariController,
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
                      hariController = value;
                    } else {
                      hariController = null;
                    }
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownSearch<String>(
                selectedItem:
                    (kelasController == "null" || kelasController == "")
                        ? "Kelas belum dipilih"
                        : kelasController,
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
                    kelasController = value;
                  } else if (value == null) {
                    kelasController = "";
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
                    (formattedJamAwal == null)
                        ? "Jam Kuliah"
                        : "$formattedJamAwal ${divider(formattedJamAkhir!)} $formattedJamAkhir",
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
                              formattedJamAwal =
                                  "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                              formattedJamAkhir =
                                  "${value.endTime?.hour}:${value.endTime?.minute.toString().padLeft(2, '0')}";
                            } else {
                              formattedJamAwal =
                                  "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                              formattedJamAkhir = "";
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
                    if (matkulController.text.isNotEmpty &&
                        hariController != null &&
                        formattedJamAwal != null) {
                      editJadwal();
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Form tidak lengkap"),
                          content:
                              const Text("Harap Isi Matkul, Hari, dan Jam"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "ok",
                                style: TextStyle(fontSize: 17),
                              ),
                            )
                          ],
                        ),
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
