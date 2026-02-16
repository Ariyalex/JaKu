import 'package:hive/hive.dart';

part 'task_tab.g.dart';

@HiveType(typeId: 4)
class TaskTab extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String tabName;

  TaskTab({required this.id, required this.tabName});
}
