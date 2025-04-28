import 'package:flutter/material.dart';
import 'package:jaku/provider/hari_kuliah.dart';
import 'package:jaku/screens/pdf_parsing.dart';
import 'package:provider/provider.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../provider/jadwal_kuliah.dart';

class AddMatkul extends StatefulWidget {
  static const routeName = "/add-matkul";

  const AddMatkul({super.key});

  @override
  State<AddMatkul> createState() => _AddMatkulState();
}

class _AddMatkulState extends State<AddMatkul> {
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

  final TextEditingController matkulController = TextEditingController();
  final TextEditingController dosen1Controller = TextEditingController();
  final TextEditingController dosen2Controller = TextEditingController();
  final TextEditingController ruanganController = TextEditingController();

  String? hariController, kelasController;

  String? formattedJamAwal;
  String? formattedJamAkhir;

  bool isFormValid() {
    return matkulController.text.isNotEmpty &&
        hariController != null &&
        formattedJamAwal != null;
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
    final allMatkulProvider = Provider.of<Jadwalkuliah>(context, listen: false);
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    void addJadwal() {
      allMatkulProvider
          .addMatkuls(
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
              content: Text("Berhasil ditambahkan"),
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
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Add Matkul"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Peringatan!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      "Fitur ini hanya untuk\nmahasiswa UIN SUKA.\nAdd matkul menggunakan file PDF yang didapat dari SIA UIN SUKA",
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ga jadi")),
                      FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, PdfParsing.routeNamed);
                          },
                          child: Text("Ok Bang"))
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf)),
          IconButton(
              onPressed: () {
                if (matkulController.text.isNotEmpty &&
                    hariController != null &&
                    formattedJamAwal != null) {
                  addJadwal();
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
                            "OK",
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save)),
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
                controller: matkulController,
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
                controller: dosen1Controller,
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
                controller: dosen2Controller,
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
                controller: ruanganController,
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownSearch<String>(
                selectedItem: hariController,
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
                    hariController = value;
                  } else {
                    hariController = "";
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownSearch<String>(
                selectedItem: kelasController,
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
                    kelasController = value;
                  } else if (value == null || value == "") {
                    kelasController = null;
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
                        : formattedJamAwal! +
                            divider(formattedJamAkhir!) +
                            formattedJamAkhir!,
                    style: const TextStyle(fontSize: 18),
                  ),
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
                          setState(() {
                            if (value.endTime != null) {
                              formattedJamAwal =
                                  "${value.startTime?.hour}:${value.startTime?.minute.toString().padLeft(2, '0')}";
                              formattedJamAkhir =
                                  "${value.endTime?.hour}:${value.endTime?.minute.toString().padLeft(2, '0')}";
                            } else if (value.startTime == null) {
                              formattedJamAwal = null;
                              formattedJamAkhir = null;
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
                    if (matkulController.text.isNotEmpty &&
                        hariController != null &&
                        formattedJamAwal != null) {
                      addJadwal();
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
