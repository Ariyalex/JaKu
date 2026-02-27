import 'package:equatable/equatable.dart';
import 'package:jaku/data/models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadListTask extends TaskEvent {}

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
