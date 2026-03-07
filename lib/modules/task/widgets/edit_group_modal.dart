import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_event.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';

class EditGroupModal extends HookWidget {
  const EditGroupModal({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainTabBloc = context.read<MainTabBloc>();
    
    final selectedTab = mainTabBloc.state.taskTabs.where((tab) => tab.id == groupId).firstOrNull;
    final textController = useTextEditingController(text: selectedTab?.tabName ?? "");

    void editTab() {
      try {
        mainTabBloc.add(EditTaskTab(id: groupId, tabName: textController.text));
        context.pop();
        showAppSnackbar(
          title: "Success!",
          message: "Berhasil megubah nama tab",
        );
      } catch (error) {
        showAppSnackbar(title: "Error", message: "Error: $error", isSuccess: false);
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
                  onPressed: textController.text.trim().isEmpty ? null : editTab,
                  child: const Text("save"),
                ),
              ],
            ),
            const Divider(),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Nama group",
                helperText: "group tidak termasuk ke dalam matkul",
                helperStyle: theme.textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
