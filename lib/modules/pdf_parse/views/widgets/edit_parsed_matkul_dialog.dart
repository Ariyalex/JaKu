import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_bloc.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_event.dart';

class EditParsedMatkulDialog extends HookWidget {
  final Matkul matkul;

  const EditParsedMatkulDialog({super.key, required this.matkul});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameCtrl = useTextEditingController(text: matkul.name);
    final abbrevCtrl = useTextEditingController(text: matkul.nameAbbreviation);
    final lec1Ctrl = useTextEditingController(text: matkul.lecturer1 ?? '');
    final lec2Ctrl = useTextEditingController(text: matkul.lecturer2 ?? '');
    final semesterCtrl = useTextEditingController(
      text: matkul.semester < 1 ? "" : matkul.semester.toString(),
    );

    return AlertDialog(
      title: const Text('Edit Matkul'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Matkul'),
                validator: (v) => (v?.isEmpty ?? true) ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: abbrevCtrl,
                decoration: const InputDecoration(labelText: 'Singkatan'),
                validator: (v) => (v?.isEmpty ?? true) ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: lec1Ctrl,
                decoration: const InputDecoration(labelText: 'Dosen 1'),
              ),
              TextFormField(
                controller: lec2Ctrl,
                decoration: const InputDecoration(labelText: 'Dosen 2'),
              ),
              TextFormField(
                controller: semesterCtrl,
                decoration: const InputDecoration(
                  labelText: 'Semester',
                  hintText: "Contoh: 1",
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final s = int.tryParse(v ?? "");
                  if (s == null || s < 1) return "Harus >= 1";
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Batal')),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              final updated = matkul.copyWith(
                name: nameCtrl.text,
                nameAbbreviation: abbrevCtrl.text,
                lecturer1: lec1Ctrl.text.isEmpty ? null : lec1Ctrl.text,
                lecturer2: lec2Ctrl.text.isEmpty ? null : lec2Ctrl.text,
                semester: int.parse(semesterCtrl.text),
              );
              context.read<PdfParseBloc>().add(UpdateParsedMatkul(updated));
              context.pop();
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
