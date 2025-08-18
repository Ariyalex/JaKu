import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObject {
  Task copyWith({
    String? id,
    String? task,
    String? desc,
    bool? status,
    DateTime? taskDueDate,
    Object? matkulId,
    bool? isStared,
    int? matkulOrder,
    int? starredOrder,
  }) {
    return Task(
      id: id ?? this.id,
      task: task ?? this.task,
      desc: desc ?? this.desc,
      status: status ?? this.status,
      taskDueDate: taskDueDate ?? this.taskDueDate,
      matkulId: identical(matkulId, null)
          ? null
          : (matkulId as String?) ?? this.matkulId,
      isStared: isStared ?? this.isStared,
      matkulOrder: matkulOrder ?? this.matkulOrder,
      starredOrder: starredOrder ?? this.starredOrder,
    );
  }

  @HiveField(0)
  String id;

  @HiveField(1)
  String task;

  @HiveField(2)
  String? desc;

  @HiveField(3)
  bool status;

  @HiveField(4)
  DateTime? taskDueDate;

  @HiveField(5)
  String? matkulId;

  @HiveField(6)
  bool isStared;

  @HiveField(7)
  int? matkulOrder;

  @HiveField(8)
  int? starredOrder;

  Task({
    required this.id,
    required this.task,
    required this.status,
    this.desc,
    this.taskDueDate,
    this.matkulId,
    required this.isStared,
    this.matkulOrder,
    this.starredOrder,
  });
}
