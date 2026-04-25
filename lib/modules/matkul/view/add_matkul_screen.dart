import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/my_snackbar.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddMatkulScreen extends HookWidget {
  final String? matkulName;
  const AddMatkulScreen({super.key, required this.matkulName});

  @override
  Widget build(BuildContext context) {
    final semester = useState<int>(0);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameTextController = useTextEditingController();
    final lecturer1TextController = useTextEditingController();
    final lecturer2TextController = useTextEditingController();
    final semesterTextController = useTextEditingController();

    final matkulBloc = context.read<MatkulBloc>();

    useEffect(() {
      semesterTextController.text = semester.value.toString();
      return null;
    }, [semester.value]);

    void saveMatkul() {
      final newMatkul = Matkul.create(
        name: nameTextController.text,
        lecturer1: lecturer1TextController.text,
        lecturer2: lecturer2TextController.text,
        semester: int.parse(semesterTextController.text),
      );

      matkulBloc.add(AddMatkul(newMatkul));

      if (matkulName != null) {
        context.pop<Matkul>(newMatkul);
      } else {
        context.pop();
      }
    }

    String? validateName(String? value) {
      if (value?.isEmpty ?? true) return "Nama tidak boleh kosong";
      if (value!.length < 3) return "Nama minimal 3 karakter";
      return null;
    }

    String? validateSemester(String? value) {
      if (value?.isEmpty ?? true) return "Semester tidak boleh kosong";
      return null;
    }

    useEffect(() {
      nameTextController.text = matkulName ?? "";
      semesterTextController.text = "";
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text("Tambahkan Matkul Baru")),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              spacing: 12,
              children: [
                TextFormField(
                  controller: nameTextController,
                  validator: validateName,
                  decoration: const InputDecoration(
                    hintText: "Ex: Basis Data",
                    labelText: "Nama Mata Kuliah",
                    alignLabelWithHint: true,
                  ),
                  autocorrect: false,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: lecturer1TextController,
                  decoration: const InputDecoration(
                    hintText: "Ex: Budi Arie",
                    labelText: "Nama Dosen 1",
                    alignLabelWithHint: true,
                  ),
                  autocorrect: false,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: lecturer2TextController,
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
                      child: TextFormField(
                        controller: semesterTextController,
                        validator: validateSemester,
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
                      onPressed: () {
                        if (semester.value > 1) semester.value--;
                      },
                      label: Icon(LucideIcons.minus),
                    ),
                    FilledButton.icon(
                      onPressed: () => semester.value++,
                      label: Icon(LucideIcons.plus),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        saveMatkul();
                      } else {
                        MySnackbar.warning(
                          message: "Lengkapi form sesuai ketentuan!",
                        );
                      }
                    },
                    label: Text("Simpan Matkul"),
                    icon: Icon(LucideIcons.save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
