import 'package:hive/hive.dart';

part 'day.g.dart';

@HiveType(typeId: 5)
enum Day {
  @HiveField(0)
  monday("moday", "Senin"),
  @HiveField(1)
  tuesday("tuesday", "Selasa"),
  @HiveField(2)
  wednesday("wednesday", "Rabu"),
  @HiveField(3)
  thursday("thursday", "Kamis"),
  @HiveField(4)
  friday("friday", "Jum'at"),
  @HiveField(5)
  saturday("saturday", "Sabtu"),
  @HiveField(6)
  sunday("sunday", "Minggu");

  final String jsonValue;
  final String label;

  const Day(this.jsonValue, this.label);

  String get display => label;
  String get toJson => jsonValue;

  static Day currentDay() {
    int todayIndex = DateTime.now().weekday - 1;
    return Day.values[todayIndex];
  }

  static List<Day> getAllDay() {
    return [
      Day.monday,
      Day.tuesday,
      Day.wednesday,
      Day.thursday,
      Day.friday,
      Day.saturday,
      Day.sunday,
    ];
  }
}

extension DayExtension on Day {
  static int getDayIndex(String daylabel) {
    return Day.values.firstWhere((d) => d.label == daylabel).index;
  }

  static List<Day> getUniqueDaysSorted(
    List<String> dayLabels, {
    bool startFromToday = true,
  }) {
    Set<Day> uniqueDays = dayLabels
        .map((label) => Day.values.firstWhere((d) => d.label == label))
        .toSet();
    List<Day> sorted = uniqueDays.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    if (startFromToday) {
      Day today = Day.currentDay();
      sorted = [
        ...sorted.where((d) => d.index >= today.index),
        ...sorted.where((d) => d.index < today.index),
      ];
    }
    return sorted;
  }
}
