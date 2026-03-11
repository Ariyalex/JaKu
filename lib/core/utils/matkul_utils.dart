import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/value_objects/day.dart';

class MatkulUtils {
  static List<Day> getListDayOfSchedule({
    required List<MatkulSchedule> schedules,
    bool sortByCurrentDay = false,
  }) {
    final Set<Day> uniqueDays = schedules.map((e) => e.day).toSet();
    List<Day> sorted = uniqueDays.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    if (sortByCurrentDay) {
      Day today = Day.currentDay();

      final List<Day> result = [
        ...sorted.where((d) => d.index >= today.index),
        ...sorted.where((d) => d.index < today.index),
      ];

      return result;
    } else {
      return sorted;
    }
  }
}
