import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/data/entities/schedule_reminder.dart';

class AddReminderDialog extends HookWidget {
  const AddReminderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final offsetMinutes = useState<List<int>>([0, 5, 10, 15, 30]);
    final isNotification = useState<bool>(true);
    final minuteTextC = useTextEditingController();

    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioGroup(
              onChanged: (value) {
                isNotification.value = value ?? true;
              },
              groupValue: isNotification.value,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: RadioListTile(
                      value: true,
                      title: Text("Notifikasi"),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: RadioListTile(
                      value: false,
                      title: Row(
                        spacing: 5,
                        children: [Text("Alarm"), Icon(Icons.alarm)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: offsetMinutes.value.length,
              itemBuilder: (context, index) {
                final offsetMinute = offsetMinutes.value[index];
                return ListTile(
                  title: Text(
                    offsetMinute == 0
                        ? "On time"
                        : "$offsetMinute menit sebelum",
                  ),
                  onTap: () => context.pop<ScheduleReminder>(
                    ScheduleReminder.create(
                      offsetMinutes: offsetMinute,
                      isNotificationOnly: isNotification.value,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: minuteTextC,
                decoration: const InputDecoration(
                  hintText: "menit",
                  labelText: "Sesuaikan menit",
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.start,
                autocorrect: false,
                style: const TextStyle(fontWeight: FontWeight.normal),
                onEditingComplete: () => context.pop<ScheduleReminder>(
                  ScheduleReminder.create(
                    offsetMinutes: int.parse(minuteTextC.text),
                    isNotificationOnly: isNotification.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
