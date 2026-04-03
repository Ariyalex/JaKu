import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/schedule/bloc/schedule_selection_cubit.dart';
import 'package:jaku/modules/schedule/bloc/schedule_selection_state.dart';

import '../../../../data/entities/matkul_schedule.dart';
import '../../../../core/routes/route_named.dart';

class ScheduleCard extends StatelessWidget {
  final MatkulSchedule schedule;
  final Matkul matkul;
  final ScheduleSelectionCubit scheduleSelectionCubit;
  final ScheduleSelectionState scheduleSelectionState;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.matkul,
    required this.scheduleSelectionCubit,
    required this.scheduleSelectionState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isSelected = scheduleSelectionState.selectedScheduleIds.contains(
      schedule.id,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Card(
        elevation: 0,
        color: isSelected ? theme.cardTheme.color : theme.highlightColor,
        shape: isSelected
            ? RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(14),
                side: BorderSide(color: theme.colorScheme.tertiary, width: 2),
              )
            : null,

        child: ListTile(
          onTap: () {
            if (scheduleSelectionState.isSelectionMode) {
              scheduleSelectionCubit.toggleSelection(schedule.id);
            } else {
              context.pushNamed(
                RouteNamed.detailSchedule,
                pathParameters: {"id": schedule.id},
              );
            }
          },
          onLongPress: () {
            if (!scheduleSelectionState.isSelectionMode) {
              scheduleSelectionCubit.setSelectionMode(true);
              scheduleSelectionCubit.toggleSelection(schedule.id);
            }
          },
          title: Text(
            matkul.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      Icon(Icons.schedule, color: theme.colorScheme.primary),
                      Text(
                        (schedule.endTime != null
                            ? "${TimeParserHelper.formatTimeOfDay(schedule.startTime)} - ${TimeParserHelper.formatTimeOfDay(schedule.endTime!)}"
                            : TimeParserHelper.formatTimeOfDay(
                                schedule.startTime,
                              )),
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.room, color: theme.colorScheme.primary),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            "${schedule.room}",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Icon(Icons.person_rounded),
                      Expanded(
                        child: Text(
                          (matkul.lecturer1 == null)
                              ? "dosen belum ditambahkan"
                              : "${matkul.lecturer1}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  matkul.lecturer2 == null || matkul.lecturer2 == ""
                      ? const SizedBox.shrink()
                      : Row(
                          spacing: 6,
                          children: [
                            Icon(Icons.person_rounded),
                            Expanded(
                              child: Text(
                                "${matkul.lecturer2}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
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
