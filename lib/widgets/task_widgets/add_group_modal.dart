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
    // TODO: implement initState
    super.initState();
    textC = tabC.taskTabC;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textC.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void addTab() {
      try {
        if (widget.onUpdateTabs != null) widget.onUpdateTabs!();
        Get.back();
      } catch (error) {
        print("error add tab: $error");
      }
    }

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
                  onPressed: textC.text.trim().isEmpty ? null : addTab,
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
