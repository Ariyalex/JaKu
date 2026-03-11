import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddGroupModal extends HookWidget {
  const AddGroupModal({super.key, this.onUpdateTabs});
  final void Function(String tabName)? onUpdateTabs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final TextEditingController textController = useTextEditingController();

    useValueListenable(textController);

    return SafeArea(
      child: SingleChildScrollView(
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
                    onPressed: textController.text.trim().isEmpty
                        ? null
                        : () {
                            if (onUpdateTabs != null) {
                              onUpdateTabs!(textController.text);
                              Navigator.of(context).pop();
                            }
                          },
                    child: const Text("save"),
                  ),
                ],
              ),
              const Divider(),
              TextField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Nama group",
                  helperText: "group tidak termasuk ke dalam matkul",
                  helperStyle: theme.textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
