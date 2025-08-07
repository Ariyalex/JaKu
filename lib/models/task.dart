import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String task;

  @HiveField(2)
  String? desc;

  @HiveField(3)
  bool status;

  @HiveField(4)
  DateTime? taskDueDate;

  @HiveField(5)
  TimeOfDay? taskDueTime;

  @HiveField(6)
  String? matkul;

  @HiveField(7)
  bool isStared;

  Task({
    this.id,
    required this.task,
    required this.status,
    this.desc,
    this.taskDueDate,
    this.taskDueTime,
    this.matkul,
    required this.isStared,
  });
}
