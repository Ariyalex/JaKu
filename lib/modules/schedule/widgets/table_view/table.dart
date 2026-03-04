import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/core/utils/matkul_utils.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/models/matkul.dart';
import 'package:jaku/data/models/matkul_schedule.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';

class Table extends HookWidget {
  final List<MatkulSchedule> schedules;
  final List<Matkul> matkuls;

  const Table({super.key, required this.schedules, required this.matkuls});

  @override
  Widget build(BuildContext context) {
    final ScrollController horizontalScrollController = useScrollController();
    final Day todayDay = Day.currentDay();

    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final textTheme = theme.textTheme;

    // 1. Compute Days and Time Pairs
    final List<Day> days = useMemoized(
      () => MatkulUtils.getListDayOfSchedule(schedules),
      [schedules],
    );

    final List<Map<String, String>> timePairs = useMemoized(() {
      final Set<String> jamPairSet = <String>{};
      for (var schedule in schedules) {
        jamPairSet.add(
          "${TimeParserHelper.formatDateTimeToString(schedule.startTime)}#${schedule.endTime != null ? TimeParserHelper.formatDateTimeToString(schedule.endTime!) : ""}",
        );
      }

      final jamPairList = jamPairSet.map((pair) {
        final parts = pair.split('#');
        return {'jamAwal': parts[0], 'jamAkhir': parts[1]};
      }).toList();

      jamPairList.sort((a, b) {
        int timeToMinutes(String timeStr) {
          final parts = timeStr.split(":");
          if (parts.length != 2) return 0;
          try {
            return int.parse(parts[0]) * 60 + int.parse(parts[1]);
          } catch (e) {
            return 0;
          }
        }

        return timeToMinutes(
          a['jamAwal']!,
        ).compareTo(timeToMinutes(b['jamAwal']!));
      });
      return jamPairList;
    }, [schedules]);

    // 2. Scroll Logic
    void scrollToTodayColumn() {
      if (days.isEmpty) return;

      int targetIndex = days.indexWhere((day) => day == todayDay);
      if (targetIndex == -1) targetIndex = 0;

      const double columnWidth = 225.0;
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
    }

    useEffect(() {
      scrollToTodayColumn();
      return null;
    }, [days]);

    // 3. Cell Builder
    DataCell getMatkulCell(Day day, Map<String, String> jamPair) {
      final matchingSchedules = schedules.where((jadwal) {
        final sameDay = jadwal.day == day;
        final sameStartTime =
            TimeParserHelper.formatDateTimeToString(jadwal.startTime) ==
            jamPair['jamAwal'];
        final sameEndTime =
            (jadwal.endTime != null
                ? TimeParserHelper.formatDateTimeToString(jadwal.endTime!)
                : "") ==
            jamPair['jamAkhir'];
        return sameDay && sameStartTime && sameEndTime;
      }).toList();

      final isToday = day == todayDay;

      if (matchingSchedules.isEmpty) {
        return const DataCell(Text(""));
      }

      final schedule = matchingSchedules.first;
      final matkul = matkuls.firstWhere(
        (m) => m.id == schedule.matkulId,
        orElse: () =>
            const Matkul(id: "", name: "Unknown", nameAbbreviation: "???"),
      );

      return DataCell(
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isToday ? primaryColor.withValues(alpha: 0.15) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            matkul.nameAbbreviation.isNotEmpty
                ? matkul.nameAbbreviation
                : matkul.name,
            style: isToday
                ? textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                : textTheme.bodyMedium,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        onTap: () {
          context.goNamed(
            RouteNamed.detailMatkul,
            pathParameters: {"id": matkul.id},
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Hapus Item"),
              content: Text("Yakin hapus jadwal ${matkul.name}?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tidak"),
                ),
                FilledButton(
                  onPressed: () {
                    context.read<ScheduleBloc>().add(
                      DeleteSchedule(schedule.id),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Ya, Hapus"),
                ),
              ],
            ),
          );
        },
      );
    }

    // 4. Render Table
    return DataTable2(
      horizontalMargin: 0,
      columnSpacing: 0,
      bottomMargin: 70,
      dataRowHeight: 100,
      fixedLeftColumns: 1,
      headingRowColor: WidgetStateProperty.all(
        primaryColor.withValues(alpha: 0.1),
      ),
      isHorizontalScrollBarVisible: true,
      horizontalScrollController: horizontalScrollController,
      border: TableBorder.all(width: 0.5, color: theme.dividerColor),
      minWidth: 150 + (days.length * 225.0),
      columns: [
        DataColumn2(
          fixedWidth: 80,
          label: Center(child: Text("Jam", style: textTheme.labelLarge)),
        ),
        ...days.map(
          (day) => DataColumn2(
            fixedWidth: 225.0,
            label: Center(
              child: Text(
                day.display,
                style: textTheme.labelLarge?.copyWith(
                  color: day == todayDay ? primaryColor : null,
                  fontWeight: day == todayDay
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ],
      rows: timePairs.map((jamPair) {
        return DataRow2(
          cells: [
            DataCell(
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  jamPair['jamAkhir']!.isNotEmpty
                      ? '${jamPair['jamAwal']}\n-\n${jamPair['jamAkhir']}'
                      : '${jamPair['jamAwal']}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                ),
              ),
            ),
            ...days.map((day) => getMatkulCell(day, jamPair)),
          ],
        );
      }).toList(),
    );
  }
}
