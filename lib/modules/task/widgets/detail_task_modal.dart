import 'package:date_time_format/date_time_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/main_tab_controller.dart';
import 'package:jaku/controllers/matkul_controller.dart';
import 'package:jaku/modules/task/controller/task_controller.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/task.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailTaskModal extends StatefulWidget {
  const DetailTaskModal({super.key, required this.taskId});
  final String taskId;

  @override
  State<DetailTaskModal> createState() => _DetailTaskModalState();
}

class _DetailTaskModalState extends State<DetailTaskModal> {
  // final matkulC = Get.find<MatkulController>();
  // final taskC = Get.find<TaskController>();
  // final tabC = Get.find<MainTabController>();
  // late List<Matkul> matkulList;

  // late Task selectedTask;

  bool showDescField = false;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   try {
  //     selectedTask = taskC.selectById(widget.taskId)!;
  //   } catch (error) {
  //     print("error");
  //     Get.back();
  //   }
  //   matkulList = matkulC.allMatkul;

  //   taskC.titleC.text = selectedTask.task;
  //   taskC.descC.text = selectedTask.desc ?? "";
  //   taskC.matkulIdC.value = selectedTask.groupId;
  //   taskC.dueDateC.value = selectedTask.taskDueDate;
  //   taskC.isStaredC.value = selectedTask.isStared;
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   taskC.titleC.clear();
  //   taskC.descC.clear();
  //   taskC.isStaredC.value = false;
  //   taskC.dueDateC.value = null;
  //   taskC.matkulIdC.value = null;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // String showGroup() {
    //   try {
    //     if (taskC.matkulIdC.value == null || taskC.matkulIdC.value == "") {
    //       return "Select group";
    //     } else {
    //       if (taskC.matkulIdC.value!.startsWith("tab")) {
    //         return tabC.selectTabById(taskC.matkulIdC.value!)!.tabName;
    //       } else {
    //         return matkulC
    //             .selectMatkulById(taskC.matkulIdC.value!)!
    //             .nameAbbreviation;
    //       }
    //     }
    //   } catch (e) {
    //     return "Error showing group";
    //   }
    // }

    // void deleteTask(String id) {
    //   try {
    //     Get.back(closeOverlays: true);
    //     taskC.deleteTask(id);
    //     Get.back(closeOverlays: true);

    //     showAppSnackbar(title: "Success!", message: "Berhasil menghapus task");
    //   } catch (e) {
    //     showAppSnackbar(
    //       title: "Error!",
    //       message: "Error ketika menghapus task: $e",
    //       isSuccess: false,
    //     );
    //   }
    // }

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
                  child: Obx(
                    () => DropdownButton2(
                      customButton: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 6,
                          children: [
                            // Text(showGroup()),
                            Text("group"),
                            // taskC.matkulIdC.value == null ||
                            //         taskC.matkulIdC.value == ""
                            //     ? const SizedBox.shrink()
                            //     : IconButton(
                            //         onPressed: () {
                            //           taskC.matkulIdC.value = null;
                            //         },
                            //         icon: const Icon(LucideIcons.x),
                            //       ),
                            const Icon(LucideIcons.chevronDown),
                          ],
                        ),
                      ),
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      // value: taskC.matkulIdC.value,
                      items: [
                        // ...matkulList.map(
                        //   (item) => DropdownMenuItem<Object>(
                        //     value: item.id,
                        //     child: Text(item.nameAbbreviation),
                        //   ),
                        // ),
                        // ...tabC.taskTabs.map(
                        //   (item) => DropdownMenuItem<Object>(
                        //     value: item.id,
                        //     child: Text(item.tabName),
                        //   ),
                        // ),
                      ],
                      onChanged: (value) {
                        // taskC.matkulIdC.value = value as String?;
                        // print("selected matkul: ${taskC.matkulIdC.value}");
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
                IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Hapus task?",
                      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      backgroundColor: Theme.of(
                        context,
                      ).dialogTheme.backgroundColor,
                      content: Text(
                        // "Yakin ingin menghapus task ${taskC.titleC.text}?",
                        "Yakin ingin menghapus task",
                        textAlign: TextAlign.center,
                      ),
                      cancel: FilledButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Tidak"),
                      ),
                      confirm: OutlinedButton(
                        // onPressed: () => deleteTask(widget.taskId),
                        onPressed: () {},
                        child: const Text("Ya"),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.trash2),
                ),
              ],
            ),
            TextField(
              // controller: taskC.titleC,
              style: theme.textTheme.titleLarge,
              decoration: const InputDecoration(
                hintText: 'Task',
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            // if (showDescField || taskC.descC.text.isNotEmpty)
            TextField(
              // controller: taskC.descC,
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
            Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // if (taskC.dueDateC.value != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Chip(
                      label: Text(
                        // Tampilkan tanggal dan waktu jika ada
                        // DateTimeFormat.format(
                        //   DateTime(
                        //     taskC.dueDateC.value!.year,
                        //     taskC.dueDateC.value!.month,
                        //     taskC.dueDateC.value!.day,
                        //     taskC.dueDateC.value?.hour ?? 0,
                        //     taskC.dueDateC.value?.minute ?? 0,
                        //   ),
                        //   format:
                        //       taskC.dueDateC.value?.hour == null ||
                        //           (taskC.dueDateC.value?.hour == 0 &&
                        //               taskC.dueDateC.value?.minute == 0)
                        //       ? "d F Y"
                        //       : "d F Y, H:i",
                        // ),
                        "testing",
                        style: theme.textTheme.bodySmall,
                      ),
                      onDeleted: () {
                        // taskC.dueDateC.value = null;
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // setState(() {
                        //   showDescField = true;
                        // });
                      },
                      icon: const Icon(LucideIcons.textAlignStart),
                    ),
                    IconButton(
                      onPressed: () async {
                        // DateTime? pickedDate = await showDatePicker(
                        //   context: context,
                        //   initialDate: taskC.dueDateC.value ?? DateTime.now(),
                        //   firstDate: DateTime(2000),
                        //   lastDate: DateTime(2100),
                        // );
                        // if (pickedDate != null) {
                        //   // Jika sebelumnya sudah ada jam/menit, pertahankan
                        //   if (taskC.dueDateC.value != null) {
                        //     pickedDate = pickedDate.copyWith(
                        //       hour: taskC.dueDateC.value!.hour,
                        //       minute: taskC.dueDateC.value!.minute,
                        //     );
                        //   }
                        //   taskC.dueDateC.value = pickedDate;
                        // }
                      },
                      icon: const Icon(LucideIcons.calendar),
                    ),
                    // if (taskC.dueDateC.value != null)
                    IconButton(
                      onPressed: () async {
                        // final time = await showTimePicker(
                        //   context: context,
                        //   initialTime: TimeOfDay(
                        //     hour: taskC.dueDateC.value!.hour,
                        //     minute: taskC.dueDateC.value!.minute,
                        //   ),
                        // );
                        // if (time != null) {
                        //   // Update jam/menit pada dueDateC
                        //   taskC.dueDateC.value = taskC.dueDateC.value!
                        //       .copyWith(
                        //         hour: time.hour,
                        //         minute: time.minute,
                        //       );
                        // }
                      },
                      icon: const Icon(LucideIcons.clock),
                    ),
                    IconButton(
                      onPressed: () {
                        // taskC.isStaredC.value = !taskC.isStaredC.value;
                      },
                      // icon: taskC.isStaredC.value
                      //     ? const Icon(Icons.star, color: Colors.amberAccent)
                      //     : const Icon(Icons.star_border),
                      icon: const Icon(Icons.star),
                    ),
                  ],
                ),

                TextButton(
                  onPressed: () {},
                  // taskC.titleC.text.trim().isEmpty
                  //     ? null // tombol disable
                  //     : () {
                  //         try {
                  //           print(
                  //             "task id dari detail task: ${selectedTask.id}",
                  //           );
                  //           taskC.updateTask(selectedTask.id);
                  //           Get.back();
                  //           showAppSnackbar(
                  //             title: "Sucess!",
                  //             message:
                  //                 "Berhasil mengubah task ${selectedTask.task}",
                  //           );
                  //         } catch (error) {
                  //           showAppSnackbar(
                  //             title: "Error!",
                  //             message: "Error: $error",
                  //             isSuccess: false,
                  //           );
                  //           print(error);
                  //         }
                  //       },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
