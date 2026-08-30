import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/core/utils/matkul_utils.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:jaku/modules/schedule/widgets/table_view/schedule_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ScheduleTable extends HookWidget {
  final List<MatkulSchedule> schedules;
  final List<Matkul> matkuls;
  const ScheduleTable({
    super.key,
    required this.matkuls,
    required this.schedules,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayDay = Day.currentDay();

    final ScrollController horizontalScrollController = useScrollController();

    final days = useMemoized(
      () => MatkulUtils.getListDayOfSchedule(
        schedules: schedules,
        sortByCurrentDay: false,
      ),
      [schedules],
    );

    final List<Map<String, String>> timePairs = useMemoized(() {
      final Set<String> jamPairSet = <String>{};
      for (var schedule in schedules) {
        jamPairSet.add(
          "${TimeParserHelper.formatTimeOfDay(schedule.startTime)}#${schedule.endTime != null ? TimeParserHelper.formatTimeOfDay(schedule.endTime!) : ""}",
        );
      }

      final jamPairList = jamPairSet.map((pair) {
        final parts = pair.split('#');
        return {'startTime': parts[0], 'endTime': parts[1]};
      }).toList();

      jamPairList.sort((a, b) {
        int timeToMinutes(String? timeStr) {
          if (timeStr == null || timeStr.isEmpty) return 0;
          final parts = timeStr.split(":");
          if (parts.length != 2) return 0;
          return (int.tryParse(parts[0]) ?? 0) * 60 +
              (int.tryParse(parts[1]) ?? 0);
        }

        return timeToMinutes(
          a['startTime'],
        ).compareTo(timeToMinutes(b['startTime']));
      });
      return jamPairList;
    }, [schedules]);

    final dataSource = useMemoized(
      () => ScheduleDataSource(
        days: days,
        timePairs: timePairs,
        schedules: schedules,
        matkuls: matkuls,
        context: context,
      ),
      [schedules, matkuls, days, timePairs],
    );

    final ColumnSizer columnSizer = useMemoized(() => ColumnSizer(), []);

    useEffect(() {
      if (days.isEmpty) return;

      int targetIndex = days.indexWhere((day) => day == todayDay);
      if (targetIndex == -1) targetIndex = 0;

      const double columnWidth = 200.0;
      final double scrollPosition = targetIndex * columnWidth;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (horizontalScrollController.hasClients) {
          horizontalScrollController.animateTo(
            scrollPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
      return null;
    }, []);

    return SfDataGrid(
      source: dataSource,
      frozenColumnsCount: 1,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: ColumnWidthMode.fitByCellValue,
      horizontalScrollController: horizontalScrollController,

      columnSizer: columnSizer,
      allowColumnsResizing: true,
      onQueryRowHeight: (details) {
        if (details.rowIndex == 0) {
          return 50.0;
        }

        return details.getIntrinsicRowHeight(details.rowIndex);
      },
      columns: [
        GridColumn(
          columnName: 'jam',
          width: 60,
          label: Container(
            alignment: Alignment.center,
            color: theme.primaryColor.withValues(alpha: 0.1),
            child: Text("Jam", style: theme.textTheme.labelLarge),
          ),
        ),
        ...days.map(
          (day) => GridColumn(
            columnName: day.name,
            width: 200,
            label: Container(
              alignment: Alignment.center,
              color: theme.primaryColor.withValues(alpha: 0.1),
              child: Text(
                day.display,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: day == todayDay ? theme.colorScheme.primary : null,
                  fontWeight: day == todayDay
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
