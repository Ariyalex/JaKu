import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/my_snackbar.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddScheduleScreen extends HookWidget {
  const AddScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    final scheduleRoomTextC = useTextEditingController();
    final selectedDay = useState<Day?>(null);
    final selectedStartTime = useState<TimeOfDay?>(null);
    final selectedEndTime = useState<TimeOfDay?>(null);
    final selectedMatkul = useState<Matkul?>(null);

    return Scaffold(
      appBar: AppBar(title: const Text("Tambahkan Jadwal Baru")),
      body: SafeArea(
        child: Container(
          width: mediaQueryWidth,
          padding: EdgeInsets.only(
            right: 20,
            left: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                Column(
                  spacing: 12,
                  children: [
                    BlocBuilder<MatkulBloc, MatkulState>(
                      builder: (context, state) {
                        if (state.status == MatkulStatus.success) {
                          return DropdownSearch<Matkul>(
                            selectedItem: selectedMatkul.value,
                            itemAsString: (item) => item.name,
                            compareFn: (item1, item2) => item1.id == item2.id,
                            items: (filter, loadProps) => state.matkuls,
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                hintText: "Pilih Matkul*",
                              ),
                            ),
                            popupProps: PopupProps.menu(
                              searchDelay: const Duration(milliseconds: 100),
                              showSearchBox: true,
                              constraints: const BoxConstraints(maxHeight: 500),
                              menuProps: MenuProps(
                                align: MenuAlign.bottomStart,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainer,
                                margin: const EdgeInsets.only(top: 12),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              showSelectedItems: true,
                              itemBuilder:
                                  (context, item, isDisabled, isSelected) =>
                                      ListTile(
                                        title: Text(item.name),
                                        subtitle: Column(
                                          children: [
                                            if (item.lecturer1 != null)
                                              Text(item.lecturer1!),
                                            if (item.lecturer2 != null)
                                              Text(item.lecturer2!),
                                          ],
                                        ),
                                        selected: isSelected,
                                      ),
                              emptyBuilder: (context, searchEntry) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Buat object baru dengan nilai default
                                        final newMatkul = Matkul.create(
                                          name: searchEntry,
                                        );

                                        context.read<MatkulBloc>().add(
                                          AddMatkul(newMatkul),
                                        );
                                        selectedMatkul.value = newMatkul;

                                        // Tutup dropdown menu secara otomatis
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Tambah Matkul baru: "$searchEntry"',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Matkul tidak boleh kosong";
                              }
                              return null;
                            },

                            onChanged: (value) {
                              if (value != null) {
                                selectedMatkul.value = value;
                              } else {
                                selectedMatkul.value = null;
                              }
                            },
                          );
                        } else if (state.status == MatkulStatus.error) {
                          return Text(state.message ?? "Error");
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    DropdownSearch<Day>(
                      selectedItem: selectedDay.value,
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(hintText: "Pilih hari*"),
                      ),
                      compareFn: (item1, item2) => item1 == item2,
                      popupProps: PopupProps.menu(
                        constraints: const BoxConstraints(maxHeight: 200),
                        menuProps: MenuProps(
                          align: MenuAlign.bottomStart,
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          margin: const EdgeInsets.only(top: 12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        showSelectedItems: true,
                      ),
                      items: (filter, loadProps) => Day.getAllDay(),
                      itemAsString: (item) => item.display,
                      onChanged: (value) {
                        if (value != null) {
                          selectedDay.value = value;
                        } else {
                          selectedDay.value = null;
                        }
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                child: Text(
                                  TimeParserHelper.format2TimeDayToString(
                                    time1: selectedStartTime.value,
                                    time2: selectedEndTime.value,
                                  ),
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            if (selectedStartTime.value != null ||
                                selectedEndTime.value != null)
                              IconButton(
                                onPressed: () {
                                  selectedStartTime.value = null;
                                  selectedEndTime.value = null;
                                },
                                icon: const Icon(LucideIcons.x),
                                tooltip: "Hapus Waktu",
                              ),
                          ],
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        selectedStartTime.value ??
                                        TimeOfDay.now(),
                                  );
                                  if (time != null) {
                                    selectedStartTime.value = time;
                                  }
                                },
                                label: const Text("Mulai"),
                                icon: const Icon(
                                  LucideIcons.clockFading500,
                                  size: 18,
                                ),
                              ),
                            ),
                            if (selectedStartTime.value != null)
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          selectedEndTime.value ??
                                          selectedStartTime.value!,
                                    );
                                    if (time != null) {
                                      selectedEndTime.value = time;
                                    }
                                  },
                                  label: const Text("Selesai"),
                                  icon: const Icon(
                                    LucideIcons.clockCheck500,
                                    size: 18,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Ex: fst-404",
                        labelText: "Ruang kelas",
                        alignLabelWithHint: true,
                      ),
                      autocorrect: false,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                      textInputAction: TextInputAction.next,
                      controller: scheduleRoomTextC,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("(*) wajib diisi", style: theme.textTheme.labelLarge),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (selectedMatkul.value != null &&
                              selectedDay.value != null &&
                              selectedStartTime.value != null) {
                            final newSchedule = MatkulSchedule.create(
                              matkulId: selectedMatkul.value!.id,
                              day: selectedDay.value!,
                              startTime: selectedStartTime.value!,
                              endTime: selectedEndTime.value,
                              room: scheduleRoomTextC.text,
                            );
                            context.read<ScheduleBloc>().add(
                              AddSchedule(newSchedule),
                            );
                            context.pop();
                          } else {
                            MySnackbar.error(
                              title: "Form tidak lengkap!",
                              message: 'Harap isi Matkul, Hari, dan Jam',
                            );
                          }
                        },
                        label: Text(
                          "Save",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        icon: const Icon(LucideIcons.save500, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
