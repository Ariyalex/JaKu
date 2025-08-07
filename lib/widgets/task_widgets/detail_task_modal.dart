import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:jaku/models/task.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailTaskModal extends StatefulWidget {
  const DetailTaskModal({super.key, required this.task});
  final Task task;

  @override
  State<DetailTaskModal> createState() => _DetailTaskModalState();
}

class _DetailTaskModalState extends State<DetailTaskModal> {
  List<String> matkulList = ["IMK", "PBO", "Basis Data"];

  late TextEditingController taskController = TextEditingController();
  late TextEditingController descController = TextEditingController();

  bool showDescField = false;
  bool isStarred = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedMatkul;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final task = widget.task;
    taskController.text = task.task;
    descController.text = task.desc ?? "";
    isStarred = task.isStared;
    selectedDate = task.taskDueDate;
    selectedTime = task.taskDueTime;
    selectedMatkul = task.matkul;
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: Row(
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
                      direction: DropdownDirection.textDirection,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(LucideIcons.trash2)),
              ],
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
            if (showDescField || descController.text.isNotEmpty)
              TextField(
                controller: descController,
                style: theme.textTheme.titleMedium,
                minLines: 1,
                maxLines: null, // expands vertically when overflow
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
