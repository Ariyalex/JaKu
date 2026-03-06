import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/value_objects/day.dart';

class MatkulUtils {
  static List<Day> getListDayOfSchedule(List<MatkulSchedule> schedule) {
    final Set<Day> uniqueDays = schedule.map((e) => e.day).toSet();
    List<Day> sorted = uniqueDays.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    Day today = Day.currentDay();
    
    final List<Day> result = [
      ...sorted.where((d) => d.index >= today.index),
      ...sorted.where((d) => d.index < today.index),
    ];
    
    return result;
  }
}
