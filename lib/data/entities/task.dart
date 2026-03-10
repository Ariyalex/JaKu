import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 3)
class Task extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String task;

  @HiveField(2)
  final String? desc;

  @HiveField(3)
  final bool status;

  @HiveField(4)
  final DateTime? taskDueDate;

  @HiveField(5)
  final String? groupId;

  @HiveField(6)
  final bool isStared;

  @HiveField(7)
  final int? matkulOrder;

  @HiveField(8)
  final int? starredOrder;

  const Task({
    required this.id,
    required this.task,
    required this.status,
    this.desc,
    this.taskDueDate,
    this.groupId,
    required this.isStared,
    this.matkulOrder,
    this.starredOrder,
  });

  Task copyWith({
    String? task,
    String? desc,
    bool? status,
    DateTime? taskDueDate,
    String? groupId,
    bool? isStared,
    int? matkulOrder,
    int? starredOrder,
  }) {
    return Task(
      id: id,
      task: task ?? this.task,
      desc: desc ?? this.desc,
      status: status ?? this.status,
      taskDueDate: taskDueDate ?? this.taskDueDate,
      groupId: groupId ?? this.groupId,
      isStared: isStared ?? this.isStared,
      matkulOrder: matkulOrder ?? this.matkulOrder,
      starredOrder: starredOrder ?? this.starredOrder,
    );
  }

  @override
  List<Object?> get props => [
    id,
    task,
    desc,
    status,
    taskDueDate,
    groupId,
    isStared,
    matkulOrder,
    starredOrder,
  ];
}
