import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'task_tab.g.dart';

@HiveType(typeId: 4)
class TaskTab extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String tabName;

  const TaskTab({required this.id, required this.tabName});

  @override
  List<Object?> get props => [id, tabName];
}
