import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/main_tab_controller.dart';

class AddGroupModal extends StatefulWidget {
  const AddGroupModal({super.key, this.onUpdateTabs});
  final VoidCallback? onUpdateTabs;

  @override
  State<AddGroupModal> createState() => _AddGroupModalState();
}

class _AddGroupModalState extends State<AddGroupModal> {
  final tabC = Get.find<MainTabController>();
  late TextEditingController textC;

  @override
  void initState() {
    super.initState();
    textC = tabC.taskTabC;
  }

  @override
  void dispose() {
    textC.clear();
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
                  onPressed: textC.text.trim().isEmpty
                      ? null
                      : widget.onUpdateTabs != null
                      ? () => widget.onUpdateTabs!()
                      : null,
                  child: const Text("save"),
                ),
              ],
            ),
            const Divider(),
            TextField(
              controller: textC,
              decoration: InputDecoration(
                hint: const Text("Nama group"),
                helper: Text(
                  "group tidak termasuk ke dalam matkul",
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
