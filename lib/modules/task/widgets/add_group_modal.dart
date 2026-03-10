import 'package:flutter/material.dart';

class AddGroupModal extends StatefulWidget {
  const AddGroupModal({super.key, this.onUpdateTabs});
  final void Function(String tabName)? onUpdateTabs;

  @override
  State<AddGroupModal> createState() => _AddGroupModalState();
}

class _AddGroupModalState extends State<AddGroupModal> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                            if (widget.onUpdateTabs != null) {
                              widget.onUpdateTabs!(textController.text);
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
