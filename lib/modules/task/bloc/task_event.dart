import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadListTask extends TaskEvent {
  final List<Matkul> matkuls;
  const LoadListTask(this.matkuls);

  @override
  List<Object?> get props => [matkuls];
}

class LoadTask extends TaskEvent {
  final String id;
  const LoadTask(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadListTaskByMatkul extends TaskEvent {
  final String matkulId;
  const LoadListTaskByMatkul(this.matkulId);

  @override
  List<Object?> get props => [matkulId];
}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String id;
  const DeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteAllTask extends TaskEvent {}

class UpdateTaskStatus extends TaskEvent {
  final String id;
  final bool status;

  const UpdateTaskStatus(this.id, this.status);

  @override
  List<Object?> get props => [id, status];
}

class UpdateTaskStarred extends TaskEvent {
  final String id;
  final bool isStared;

  const UpdateTaskStarred(this.id, this.isStared);

  @override
  List<Object?> get props => [id, isStared];
}

class ReorderTasks extends TaskEvent {
  final List<Task> tasks;
  final String? groupId;

  const ReorderTasks(this.tasks, this.groupId);

  @override
  List<Object?> get props => [tasks, groupId];
}
