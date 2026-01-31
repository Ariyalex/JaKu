import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/presentation/controllers/main_tab_controller.dart';
import 'package:jaku/domain/models/task_tab.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';

class EditGroupModal extends StatefulWidget {
  const EditGroupModal({super.key, required this.groupId});
  final String groupId;

  @override
  State<EditGroupModal> createState() => _EditGroupModalState();
}

class _EditGroupModalState extends State<EditGroupModal> {
  final tabC = Get.find<MainTabController>();
  late TextEditingController textC;
  late TaskTab selectedTab;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textC = tabC.taskTabC;
    selectedTab = tabC.selectTabById(widget.groupId)!;
    textC.text = selectedTab.tabName;
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

    void editTab() {
      try {
        tabC.editTaskTab(widget.groupId);
        Get.back();
        showAppSnackbar(
          title: "Success!",
          message: "Berhasil megubah nama tab",
        );
      } catch (error) {
        print("error add tab: $error");
        showAppSnackbar(title: "Error", message: "Error: $error");
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
                Text("Edit group", style: theme.textTheme.bodyLarge),
                TextButton(
                  onPressed: textC.text.trim().isEmpty ? null : editTab,
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
