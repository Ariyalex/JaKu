import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
import 'package:jaku/controllers/task_controllers/task_controller.dart';
import 'package:jaku/models/matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({super.key, this.matkulId});
  final String? matkulId;

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final taskC = Get.find<TaskController>();
  final matkulC = Get.find<MatkulController>();
  late List<Matkul> matkulList;

  bool showDescField = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init controller
    taskC.matkulIdC.value = widget.matkulId;

    matkulList = matkulC.allMatkul;
  }

  @override
  void dispose() {
    taskC.titleC.clear();
    taskC.descC.clear();
    taskC.isStaredC.value = false;
    taskC.dueDateC.value = null;
    taskC.matkulIdC.value = null;
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
              child: Obx(
                () => DropdownButton2(
                  customButton: Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          taskC.matkulIdC.value == null ||
                                  taskC.matkulIdC.value == ""
                              ? "Select group"
                              : matkulC
                                    .selectMatkulById(taskC.matkulIdC.value!)!
                                    .abbreviation,
                        ),
                        taskC.matkulIdC.value == null ||
                                taskC.matkulIdC.value == ""
                            ? SizedBox.shrink()
                            : IconButton(
                                onPressed: () {
                                  taskC.matkulIdC.value = null;
                                },
                                icon: Icon(LucideIcons.x),
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
                  value: taskC.matkulIdC.value,

                  items: matkulList
                      .map(
                        (item) => DropdownMenuItem<Object>(
                          value: item.id,
                          child: Text(item.abbreviation),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    taskC.matkulIdC.value = value as String?;
                    print("selected matkul: ${taskC.matkulIdC.value}");
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
            ),
            TextField(
              controller: taskC.titleC,
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
                controller: taskC.descC,
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
            Obx(
              () => Row(
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
                          taskC.dueDateC.value = null;
                        },
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(
                  () => Row(
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
                              final date = taskC.dueDateC.value!;
                              taskC.dueDateC.value = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            }
                          },
                          icon: Icon(LucideIcons.clock),
                        ),
                      IconButton(
                        onPressed: () {
                          taskC.isStaredC.value = !taskC.isStaredC.value;
                        },
                        icon: taskC.isStaredC.value
                            ? Icon(Icons.star, color: Colors.amberAccent)
                            : Icon(Icons.star_border),
                      ),
                    ],
                  ),
                ),

                TextButton(
                  onPressed: taskC.titleC.text.trim().isEmpty
                      ? null // tombol disable
                      : () {
                          // aksi simpan
                          taskC.addTask();
                          Get.back();
                          for (var task in taskC.allTask) {
                            print(task.task);
                          }
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
