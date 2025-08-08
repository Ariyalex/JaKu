import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({super.key, this.matkul});
  final String? matkul;

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  List<String> matkulList = ["IMK", "PBO", "Basis Data"];

  final TextEditingController taskController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  bool showDescField = false;
  bool isStarred = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedMatkul;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.matkul != null && widget.matkul!.isNotEmpty) {
      selectedMatkul = widget.matkul;
      if (!matkulList.contains(widget.matkul)) {
        matkulList.add(widget.matkul!);
      }
    }
  }

  @override
  void dispose() {
    taskController.dispose();
    descController.dispose();
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
          bottom: MediaQuery.of(context).viewInsets.bottom + 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        selectedMatkul == null || selectedMatkul == ""
                            ? "Select matkul"
                            : selectedMatkul!,
                      ),
                      Icon(LucideIcons.chevronDown),
                    ],
                  ),
                ),
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: selectedMatkul,
                items: matkulList
                    .map(
                      (item) => DropdownMenuItem<Object>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMatkul = value as String?;
                  });
                },
                alignment: AlignmentDirectional.centerStart,
                dropdownStyleData: DropdownStyleData(
                  width: 200,
                  direction: DropdownDirection.textDirection,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            TextField(
              controller: taskController,
              style: theme.textTheme.titleLarge,
              decoration: const InputDecoration(
                hintText: 'Task',
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            if (showDescField)
              TextField(
                controller: descController,
                minLines: 1,
                maxLines: null, // expands vertically when overflow
                style: theme.textTheme.titleMedium,
                decoration: const InputDecoration(
                  hintText: 'Details',
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Chip(
                      label: Text(
                        "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: theme.textTheme.bodySmall,
                      ),
                      onDeleted: () {
                        setState(() {
                          selectedDate = null;
                          selectedTime = null;
                        });
                      },
                    ),
                  ),
                if (selectedTime != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Chip(
                      label: Text(
                        selectedTime!.format(context),
                        style: theme.textTheme.bodySmall,
                      ),
                      onDeleted: () {
                        setState(() {
                          selectedTime = null;
                        });
                      },
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showDescField = true;
                        });
                      },
                      icon: Icon(LucideIcons.alignLeft),
                    ),
                    IconButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                            selectedTime = null;
                          });
                        }
                      },
                      icon: Icon(LucideIcons.calendar),
                    ),
                    if (selectedDate != null)
                      IconButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime ?? TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              selectedTime = time;
                            });
                          }
                        },
                        icon: Icon(LucideIcons.clock),
                      ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isStarred = !isStarred;
                        });
                      },
                      icon: isStarred
                          ? Icon(Icons.star, color: Colors.amberAccent)
                          : Icon(Icons.star_border),
                    ),
                  ],
                ),

                TextButton(
                  onPressed: taskController.text.trim().isEmpty
                      ? null // tombol disable
                      : () {
                          // aksi simpan
                        },
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
