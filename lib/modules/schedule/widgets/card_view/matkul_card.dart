import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';

import '../../../../data/entities/matkul_schedule.dart';
import '../../../../core/routes/route_named.dart';

class MatkulCard extends StatelessWidget {
  final MatkulSchedule schedule;
  final Matkul matkul;
  const MatkulCard({super.key, required this.schedule, required this.matkul});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Card(
        elevation: 0,
        color: theme.highlightColor,
        child: ListTile(
          onTap: () {
            context.goNamed(
              RouteNamed.detailMatkul,
              pathParameters: {"id": schedule.id},
            );
          },
          onLongPress: () {
            Get.defaultDialog(
              backgroundColor: theme.dialogTheme.backgroundColor,
              title: "Hapus Item",
              content: const Text("Yakin hapus?"),
              cancel: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("No"),
              ),
              confirm: FilledButton(
                onPressed: () => context.read<ScheduleBloc>().add(
                  DeleteSchedule(schedule.id),
                ),

                child: const Text("Yes"),
              ),
            );
          },
          title: Text(matkul.name, textAlign: TextAlign.center),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    (schedule.endTime != null
                        ? "${TimeParserHelper.formatDateTimeToString(schedule.startTime)} - ${TimeParserHelper.formatDateTimeToString(schedule.endTime!)}"
                        : TimeParserHelper.formatDateTimeToString(
                            schedule.endTime!,
                          )),
                  ),
                  Text(
                    "${schedule.room}",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (matkul.lecturer1 == "null" || matkul.lecturer1!.isEmpty)
                        ? "dosen belum ditambahkan"
                        : "${matkul.lecturer1}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  matkul.lecturer2 == "null" || matkul.lecturer2!.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          "${matkul.lecturer2}",
                          overflow: TextOverflow.ellipsis,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
