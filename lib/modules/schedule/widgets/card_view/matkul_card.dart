import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            context.pushNamed(
              RouteNamed.detailMatkul,
              pathParameters: {"id": schedule.id},
            );
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: theme.dialogTheme.backgroundColor,
                title: const Text("Hapus Item"),
                content: const Text("Yakin hapus?"),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  ),
                  FilledButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(
                        DeleteSchedule(schedule.id),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Yes"),
                  ),
                ],
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
                        ? "${TimeParserHelper.formatTimeOfDay(schedule.startTime)} - ${TimeParserHelper.formatTimeOfDay(schedule.endTime!)}"
                        : TimeParserHelper.formatTimeOfDay(schedule.startTime)),
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
                    (matkul.lecturer1 == null)
                        ? "dosen belum ditambahkan"
                        : "${matkul.lecturer1}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  matkul.lecturer2 == null
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
