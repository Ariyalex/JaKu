import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_bloc.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_event.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EditParsedScheduleDialog extends HookWidget {
  final MatkulSchedule schedule;

  const EditParsedScheduleDialog({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final selectedDay = useState<Day>(schedule.day);
    final selectedStartTime = useState<TimeOfDay>(schedule.startTime);
    final selectedEndTime = useState<TimeOfDay?>(schedule.endTime);
    final roomCtrl = useTextEditingController(text: schedule.room ?? '');
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Edit Jadwal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownSearch<Day>(
              selectedItem: selectedDay.value,
              items: (filter, loadProps) => Day.getAllDay(),
              itemAsString: (item) => item.display,
              compareFn: (item1, item2) => item1 == item2,
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: "Pilih hari",
                  labelText: "Hari",
                ),
              ),
              onChanged: (value) {
                if (value != null) selectedDay.value = value;
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Text(
                TimeParserHelper.format2TimeDayToString(
                  time1: selectedStartTime.value,
                  time2: selectedEndTime.value,
                ),
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedStartTime.value,
                      );
                      if (time != null) selectedStartTime.value = time;
                    },
                    label: const Text("Mulai"),
                    icon: const Icon(LucideIcons.clockFading500, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime:
                            selectedEndTime.value ?? selectedStartTime.value,
                      );
                      if (time != null) selectedEndTime.value = time;
                    },
                    label: const Text("Selesai"),
                    icon: const Icon(LucideIcons.clockCheck500, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roomCtrl,
              decoration: const InputDecoration(labelText: 'Ruangan'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Batal')),
        FilledButton(
          onPressed: () {
            final updated = schedule.copyWith(
              day: selectedDay.value,
              startTime: selectedStartTime.value,
              endTime: selectedEndTime.value,
              room: roomCtrl.text.isEmpty ? null : roomCtrl.text,
            );
            // MatkulSchedule(
            //   id: schedule.id,
            //   matkulId: schedule.matkulId,
            //   day: selectedDay.value,
            //   startTime: selectedStartTime.value,
            //   endTime: selectedEndTime.value,
            //   room: roomCtrl.text.isEmpty ? null : roomCtrl.text,
            // );
            context.read<PdfParseBloc>().add(UpdateParsedSchedule(updated));
            context.pop();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
