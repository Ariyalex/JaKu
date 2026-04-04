import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:jaku/modules/schedule/bloc/schedule_selection_cubit.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class JamCellValue {
  final String startTime;
  final String endTime;

  JamCellValue({required this.startTime, required this.endTime});

  @override
  String toString() {
    return endTime.isNotEmpty ? '$startTime\n-\n$endTime' : startTime;
  }
}

class ScheduleCellValue {
  final MatkulSchedule? schedule;
  final Matkul? matkul;

  ScheduleCellValue({this.schedule, this.matkul});

  @override
  String toString() {
    if (schedule == null || matkul == null) return "";
    String text = matkul!.name;
    if (schedule!.room != null && schedule!.room!.isNotEmpty) {
      text += "\n${schedule!.room!}";
    }
    return text;
  }
}

class ScheduleDataSource extends DataGridSource {
  final List<Day> days;
  final List<Map<String, String>> timePairs;
  final List<MatkulSchedule> schedules;
  final List<Matkul> matkuls;
  final BuildContext context;

  Set<String> selectedIds = {};
  bool isSelectionMode = false;

  ScheduleDataSource({
    required this.days,
    required this.timePairs,
    required this.schedules,
    required this.matkuls,
    required this.context,
  }) {
    _buildDataGridRow();
  }

  void updateSelectionState(Set<String> newIds, bool selectionMode) {
    selectedIds = newIds;
    isSelectionMode = selectionMode;
    notifyListeners();
  }

  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRow() {
    _dataGridRows = timePairs.map<DataGridRow>((e) {
      final List<DataGridCell> cells = [
        DataGridCell<JamCellValue>(
          columnName: "jam",
          value: JamCellValue(
            startTime: e['startTime'] ?? "",
            endTime: e['endTime'] ?? "",
          ),
        ),
      ];

      for (var day in days) {
        final schedule = schedules.firstWhereOrNull(
          (s) =>
              s.day == day &&
              TimeParserHelper.formatTimeOfDay(s.startTime) == e['startTime'] &&
              (s.endTime != null
                      ? TimeParserHelper.formatTimeOfDay(s.endTime!)
                      : "") ==
                  e['endTime'],
        );

        Matkul? matkul;
        if (schedule != null) {
          matkul = matkuls.firstWhereOrNull((m) => m.id == schedule.matkulId);
        }

        cells.add(
          DataGridCell<ScheduleCellValue>(
            columnName: day.name,
            value: ScheduleCellValue(schedule: schedule, matkul: matkul),
          ),
        );
      }

      return DataGridRow(cells: cells);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final theme = Theme.of(context);
    final todayDay = Day.currentDay();
    final scheduleSelectionCubit = context.read<ScheduleSelectionCubit>();

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'jam') {
          final val = dataGridCell.value as JamCellValue;

          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: Text(
              val.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
              softWrap: true,
            ),
          );
        }

        final cellValue = dataGridCell.value as ScheduleCellValue;
        final schedule = cellValue.schedule;
        final matkul = cellValue.matkul;

        final currentDay = days.firstWhere(
          (d) => d.name == dataGridCell.columnName,
        );
        final isToday = currentDay == todayDay;

        final isSelected = selectedIds.contains(schedule?.id);

        if (schedule == null || matkul == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            if (isSelectionMode) {
              scheduleSelectionCubit.toggleSelection(schedule.id);
            } else {
              context.pushNamed(
                RouteNamed.detailSchedule,
                pathParameters: {"id": schedule.id},
              );
            }
          },
          onLongPress: () {
            if (!isSelectionMode) {
              scheduleSelectionCubit.setSelectionMode(true);
              scheduleSelectionCubit.toggleSelection(schedule.id);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isToday
                  ? theme.primaryColor.withValues(alpha: 0.15)
                  : null,
              borderRadius: BorderRadius.circular(4),
              border: isSelected
                  ? BoxBorder.all(color: theme.colorScheme.tertiary, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  matkul.name,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: isToday
                      ? theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )
                      : theme.textTheme.bodyMedium,
                ),
                if (schedule.room != null && schedule.room!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.room,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          schedule.room!,
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
