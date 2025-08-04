import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String task;

  @HiveField(2)
  bool status;

  @HiveField(3)
  DateTime? dateTime;

  @HiveField(4)
  String? matkul;

  @HiveField(5)
  bool isStared;

  Task(
      {this.id,
      required this.task,
      required this.status,
      this.dateTime,
      this.matkul,
      required this.isStared});
}
