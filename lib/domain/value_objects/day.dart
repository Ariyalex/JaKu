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
  sunday("sunday", "minggu");

  final String jsonValue;
  final String label;

  const Day(this.jsonValue, this.label);

  String get display => label;
  String get toJson => jsonValue;
}
