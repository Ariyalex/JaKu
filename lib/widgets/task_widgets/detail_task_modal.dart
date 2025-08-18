import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
import 'package:jaku/controllers/task_controllers/task_controller.dart';
import 'package:jaku/models/matkul.dart';
import 'package:jaku/models/task.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailTaskModal extends StatefulWidget {
  const DetailTaskModal({super.key, required this.taskId});
  final String taskId;

  @override
  State<DetailTaskModal> createState() => _DetailTaskModalState();
}

class _DetailTaskModalState extends State<DetailTaskModal> {
  final matkulC = Get.find<MatkulController>();
  final taskC = Get.find<TaskController>();
  late List<Matkul> matkulList;

  late Task selectedTask;

  bool showDescField = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      selectedTask = taskC.selectById(widget.taskId)!;
    } catch (error) {
      print("error");
    }
    matkulList = matkulC.allMatkul;

    taskC.titleC.text = selectedTask.task;
    taskC.descC.text = selectedTask.desc ?? "";
    taskC.matkulC.value = selectedTask.matkulId;
    taskC.dueDateC.value = selectedTask.taskDueDate;
    taskC.isStaredC.value = selectedTask.isStared;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    taskC.titleC.clear();
    taskC.descC.clear();
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
                            taskC.matkulC.value == null ||
                                    taskC.matkulC.value == ""
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
              controller: taskC.titleC,
              style: theme.textTheme.titleLarge,
              decoration: const InputDecoration(
                hintText: 'Task',
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            if (showDescField || taskC.descC.text.isNotEmpty)
              TextField(
                controller: taskC.descC,
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
                if (taskC.dueDateC.value != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Chip(
                      label: Text(
                        // Tampilkan tanggal dan waktu jika ada
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
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: taskC.dueDateC.value ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            // Jika sebelumnya sudah ada jam/menit, pertahankan
                            if (taskC.dueDateC.value != null &&
                                pickedDate != null) {
                              pickedDate = pickedDate!.copyWith(
                                hour: taskC.dueDateC.value!.hour,
                                minute: taskC.dueDateC.value!.minute,
                              );
                            }
                            taskC.dueDateC.value = pickedDate;
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
                              // Update jam/menit pada dueDateC
                              taskC.dueDateC.value = taskC.dueDateC.value!
                                  .copyWith(
                                    hour: time.hour,
                                    minute: time.minute,
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
                  onPressed: taskC.titleC.text.trim().isEmpty
                      ? null // tombol disable
                      : () {
                          try {
                            taskC.updateTask(widget.taskId);
                            Get.back();
                          } catch (error) {
                            print(error);
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
