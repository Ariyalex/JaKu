import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
import 'package:jaku/controllers/task_controllers/task_controller.dart';
import 'package:jaku/models/matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({super.key, this.matkul});
  final String? matkul;

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final taskC = Get.find<TaskController>();
  final matkulC = Get.find<MatkulController>();
  late List<Matkul> matkulList;

  late TextEditingController taskController;
  late TextEditingController descController;

  bool showDescField = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init controller
    taskController = taskC.titleC;
    descController = taskC.descC;
    taskC.matkulC.value = widget.matkul;

    matkulList = matkulC.allMatkul;
  }

  @override
  void dispose() {
    taskController.clear();
    descController.clear();
    taskC.isStaredC.value = false;
    taskC.dueDateC.value = null;
    taskC.matkulC.value = null;
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
                        taskC.matkulC.value == null || taskC.matkulC.value == ""
                            ? "Select matkul"
                            : matkulC
                                  .selectMatkulById(taskC.matkulC.value!)!
                                  .abbreviation,
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
                value: taskC.matkulC.value,

                items: matkulList
                    .map(
                      (item) => DropdownMenuItem<Object>(
                        value: item.id,
                        child: Text(item.abbreviation),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    taskC.matkulC.value = value as String?;
                    print("selected matkul: ${taskC.matkulC.value}");
                  });
                },
                alignment: AlignmentDirectional.centerStart,
                dropdownStyleData: DropdownStyleData(
                  width: 200,
                  maxHeight: 200,
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
                if (taskC.dueDateC.value != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Chip(
                      label: Text(
                        // Tampilkan tanggal dan jam jika ada
                        taskC.dueDateC.value!.hour == 0 &&
                                taskC.dueDateC.value!.minute == 0
                            ? "${taskC.dueDateC.value!.day}/${taskC.dueDateC.value!.month}/${taskC.dueDateC.value!.year}"
                            : "${taskC.dueDateC.value!.day}/${taskC.dueDateC.value!.month}/${taskC.dueDateC.value!.year} ${taskC.dueDateC.value!.hour.toString().padLeft(2, '0')}:${taskC.dueDateC.value!.minute.toString().padLeft(2, '0')}",
                        style: theme.textTheme.bodySmall,
                      ),
                      onDeleted: () {
                        setState(() {
                          taskC.dueDateC.value = null;
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
                          initialDate: taskC.dueDateC.value ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            // Jika sebelumnya sudah ada jam, pertahankan jam
                            if (taskC.dueDateC.value != null) {
                              final old = taskC.dueDateC.value!;
                              taskC.dueDateC.value = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                old.hour,
                                old.minute,
                              );
                            } else {
                              taskC.dueDateC.value = date;
                            }
                          });
                        }
                      },
                      icon: Icon(LucideIcons.calendar),
                    ),
                    if (taskC.dueDateC.value != null)
                      IconButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: taskC.dueDateC.value!.hour,
                              minute: taskC.dueDateC.value!.minute,
                            ),
                          );
                          if (time != null) {
                            setState(() {
                              final date = taskC.dueDateC.value!;
                              taskC.dueDateC.value = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        icon: Icon(LucideIcons.clock),
                      ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          taskC.isStaredC.value = !taskC.isStaredC.value;
                        });
                      },
                      icon: taskC.isStaredC.value
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
                          taskC.addTask();
                          Get.back();
                          for (var task in taskC.allTask) {
                            print(task.task);
                          }

                          // print("is Starred: $taskC.isStaredC.value");
                          // print("date: $taskC.dueDateC.value");
                          // print("time: $taskC.dueTimeC.value");
                          // print("slected matkul: $taskC.matkulC.value");
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
