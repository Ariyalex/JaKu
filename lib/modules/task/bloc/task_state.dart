import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/task.dart';

enum TaskStatus { initial, loading, success, actionSuccess, error }

class TaskState extends Equatable {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final Task? selectedTask;
  final TaskStatus status;
  final String? message;

  const TaskState({
    this.tasks = const [],
    this.filteredTasks = const [],
    this.selectedTask,
    this.status = TaskStatus.initial,
    this.message,
  });

  TaskState copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    Task? selectedTask,
    TaskStatus? status,
    String? message,
    bool clearSelected = false,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTask: clearSelected ? null : (selectedTask ?? this.selectedTask),
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    tasks,
    filteredTasks,
    selectedTask,
    status,
    message,
  ];
}
