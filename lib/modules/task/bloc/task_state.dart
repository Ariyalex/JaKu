import 'package:equatable/equatable.dart';
import 'package:jaku/data/models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskListLoading extends TaskState {}

class TaskListLoaded extends TaskState {
  final List<Task> tasks;
  const TaskListLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskListByMatkulLoading extends TaskState {}

class TaskListByMatkulLoaded extends TaskState {
  final List<Task> tasks;
  const TaskListByMatkulLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final Task task;
  const TaskLoaded(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
