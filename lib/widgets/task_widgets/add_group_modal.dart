import 'package:flutter/material.dart';

class AddGroupModal extends StatefulWidget {
  const AddGroupModal({super.key});

  @override
  State<AddGroupModal> createState() => _AddGroupModalState();
}

class _AddGroupModalState extends State<AddGroupModal> {
  final TextEditingController textC = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    textC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          right: 20,
          left: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("New group", style: theme.textTheme.bodyLarge),
                TextButton(
                  onPressed: textC.text.trim().isEmpty ? null : () {},
                  child: Text("save"),
                ),
              ],
            ),
            const Divider(),
            TextField(
              controller: textC,
              decoration: InputDecoration(
                hint: Text("Nama group"),
                helper: Text(
                  "grup tidak termasuk matkul",
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
