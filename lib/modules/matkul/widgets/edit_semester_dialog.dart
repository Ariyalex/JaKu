import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class EditSemesterDialog {
  static Future<void> show(
    BuildContext context,
    TextEditingController controller,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Semester"),

          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: "Semester",
              hintText: "Ubah semester matkul...",
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => context.pop(),
              child: Text("Cancle"),
            ),
            FilledButton(onPressed: () {}, child: Text("Save")),
          ],
        );
      },
    ).then((value) {
      controller.text = "";
    });
  }
}
