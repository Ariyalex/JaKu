import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddMatkulScreen extends HookWidget {
  const AddMatkulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambahkan Matkul Baru")),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 12,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "Ex: Basis Data",
                  labelText: "Nama Mata Kuliah",
                  alignLabelWithHint: true,
                ),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Ex: Budi Arie",
                  labelText: "Nama Dosen 1",
                  alignLabelWithHint: true,
                ),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Ex: Joko Anwar",
                  labelText: "Nama Dosen 2",
                  alignLabelWithHint: true,
                ),
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                textInputAction: TextInputAction.next,
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Semester...",
                        labelText: "Semester",
                        alignLabelWithHint: true,
                      ),
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      autocorrect: false,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                      textInputAction: TextInputAction.next,
                    ),
                  ),

                  FilledButton.icon(
                    onPressed: () {},
                    label: Icon(LucideIcons.plus),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    label: Icon(LucideIcons.minus),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  label: Text("Simpan Matkul"),
                  icon: Icon(LucideIcons.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
