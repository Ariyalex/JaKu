import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/my_snackbar.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EditMatkulScreen extends HookWidget {
  final String id;
  const EditMatkulScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final matkulBloc = context.read<MatkulBloc>();

    useEffect(() {
      matkulBloc.add(LoadMatkul(id));
      return null;
    }, [id]);

    final formKey = GlobalKey<FormState>();
    final nameTextController = useTextEditingController();
    final lecturer1TextController = useTextEditingController();
    final lecturer2TextController = useTextEditingController();
    final semesterTextController = useTextEditingController();

    final selectedMatkul = context.select(
      (MatkulBloc bloc) => bloc.state.selectedMatkul,
    );

    final semester = useState<int>(selectedMatkul?.semester ?? 0);

    useEffect(() {
      if (selectedMatkul != null && selectedMatkul.id == id) {
        nameTextController.text = selectedMatkul.name;
        lecturer1TextController.text = selectedMatkul.lecturer1 ?? "";
        lecturer2TextController.text = selectedMatkul.lecturer2 ?? "";

        semester.value = selectedMatkul.semester;

        if (selectedMatkul.semester > 0) {
          semesterTextController.text = semester.value.toString();
        } else {
          semesterTextController.text = "";
        }
      }
      print("semester sekarang: ${selectedMatkul?.semester}");
      return null;
    }, [selectedMatkul, id]);

    useEffect(() {
      if (semester.value > 0) {
        semesterTextController.text = semester.value.toString();
      } else {
        semesterTextController.text = "";
      }
      return null;
    }, [semester.value]);

    void saveMatkul() {
      if (selectedMatkul == null) {
        return;
      }
      final newMatkul = selectedMatkul.copyWith(
        name: nameTextController.text,
        lecturer1: lecturer1TextController.text,
        lecturer2: lecturer2TextController.text,
        semester: int.parse(semesterTextController.text),
        nameAbbreviation: Matkul.matkulAbbreviation(nameTextController.text),
      );

      matkulBloc.add(UpdateMatkul(newMatkul));

      context.pop();
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

    return Scaffold(
      appBar: AppBar(title: Text("Edit Mata Kuliah")),
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
                    label: Text("Update Matkul"),
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
