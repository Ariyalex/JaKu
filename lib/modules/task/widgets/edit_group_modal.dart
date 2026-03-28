import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/my_snackbar.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_event.dart';

class EditGroupModal extends HookWidget {
  const EditGroupModal({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final TextEditingController textController = useTextEditingController();
    final isButtonEnabled = useState<bool>(false);
    useValueListenable(textController);

    void editTab() {
      try {
        context.read<MainTabBloc>().add(
          EditTaskTab(id: groupId, tabName: textController.text),
        );
        context.pop();
        MySnackbar.success(
          title: "Success!",
          message: "Berhasil megubah nama tab",
        );
      } catch (error) {
        MySnackbar.error(title: "Error", message: "Error: $error");
      }
    }

    // 1. Get the original name and "lock" it in memory
    final originalName = useMemoized(() {
      final tabs = context.read<MainTabBloc>().state.taskTabs;
      return tabs.where((tab) => tab.id == groupId).firstOrNull?.tabName ?? "";
    }, [groupId]); // Only re-calculate if groupId changes

    useEffect(() {
      textController.text = originalName;
      return null;
    }, [originalName]);

    useEffect(() {
      isButtonEnabled.value =
          originalName != textController.text &&
          textController.text.trim().isNotEmpty;

      return null;
    }, [textController.text]);

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
                  onPressed: !isButtonEnabled.value ? null : editTab,
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
