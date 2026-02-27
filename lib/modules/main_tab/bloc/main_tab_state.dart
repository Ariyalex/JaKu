import 'package:equatable/equatable.dart';
import 'package:jaku/data/models/task_tab.dart';

class MainTabState extends Equatable {
  final List<TaskTab> taskTabs;
  final int currentIndex;

  const MainTabState({
    this.taskTabs = const [],
    this.currentIndex = 0,
  });

  MainTabState copyWith({
    List<TaskTab>? taskTabs,
    int? currentIndex,
  }) {
    return MainTabState(
      taskTabs: taskTabs ?? this.taskTabs,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [taskTabs, currentIndex];
}
