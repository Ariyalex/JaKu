import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/my_snackbar.dart';

class MatkulDialogs {
  static Future<void> showDeleteMatkuls(
    BuildContext context,
    VoidCallback confirmAction,
  ) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hapus Matkul Yang Dipilih?"),
        content: Text("Yakin menghapus matkul yang sudah tepilih?"),
        actions: [
          FilledButton(onPressed: () => context.pop(), child: Text("Tidak")),
          OutlinedButton(onPressed: confirmAction, child: Text("Iya")),
        ],
      ),
    );
  }

  static Future<void> showEditSemesterDialog(
    BuildContext context,
    TextEditingController controller,
    VoidCallback confirmAction,
    GlobalKey<FormState> formKey,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Semester"),
          content: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: controller,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Semester tidak boleh kosong";
                }
                if (int.tryParse(value!) == null) {
                  return "Semester harus berupa angka";
                }
                if (int.parse(value) < 1) return "Semester lebih dari 1";
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Semester",
                hintText: "Ubah semester matkul...",
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => context.pop(),
              child: Text("Cancle"),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  confirmAction();
                } else {
                  MySnackbar.warning(message: "Lengkapi form dengan benar!");
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    ).then((value) {
      controller.text = "";
    });
  }
}
