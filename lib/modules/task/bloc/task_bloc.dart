import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/entities/task.dart';
import 'package:jaku/data/repositories/task_repository.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/task/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;

  TaskBloc(this._repository) : super(const TaskState()) {
    on<LoadListTask>(_onLoadListTask);
    on<LoadListTaskByMatkul>(_onLoadListTaskByMatkul);
    on<LoadTask>(_onLoadTask);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<DeleteAllTask>(_onDeleteAllTask);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<UpdateTaskStarred>(_onUpdateTaskStarred);
    on<ReorderTasks>(_onReorderTasks);
  }

  Future<void> _onLoadListTask(
    LoadListTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = _repository.getAllTask();
      emit(state.copyWith(status: TaskStatus.success, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadTask(LoadTask event, Emitter<TaskState> emit) async {
    // If we have it in list, set it
    emit(state.copyWith(status: TaskStatus.loading));
    final existing = state.tasks.where((t) => t.id == event.id).firstOrNull;
    if (existing != null) {
      emit(state.copyWith(selectedTask: existing, status: TaskStatus.success));
      return;
    }

    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final task = _repository.getTaskById(event.id);
      emit(state.copyWith(status: TaskStatus.success, selectedTask: task));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadListTaskByMatkul(
    LoadListTaskByMatkul event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = _repository.getTasksByMatkul(event.matkulId);
      emit(state.copyWith(status: TaskStatus.success, filteredTasks: tasks));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await _repository.addTask(event.task);
      add(LoadListTask());
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await _repository.updateTask(event.task);
      add(LoadListTask());
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await _repository.deleteTask(event.id);
      add(LoadListTask());
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteAllTask(
    DeleteAllTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _repository.deleteAllTask();
      add(LoadListTask());
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = _repository.getTaskById(event.id);
      final updatedTask = task.copyWith(status: event.status);
      await _repository.updateTask(updatedTask);
      add(LoadListTask());
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateTaskStarred(
    UpdateTaskStarred event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = _repository.getTaskById(event.id);
      final updatedTask = task.copyWith(isStared: event.isStared);
      await _repository.updateTask(updatedTask);
      add(LoadListTask());
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }

  Future<void> _onReorderTasks(
    ReorderTasks event,
    Emitter<TaskState> emit,
  ) async {
    final updatedTasks = <Task>[];
    for (var i = 0; i < event.tasks.length; i++) {
      final task = event.tasks[i];
      if (event.groupId == "0") {
        updatedTasks.add(task.copyWith(allOrder: i));
      } else if (event.groupId == "1") {
        updatedTasks.add(task.copyWith(starredOrder: i));
      } else {
        updatedTasks.add(task.copyWith(groupOrder: i));
      }
    }

    final newList = List<Task>.from(state.tasks);
    for (var updatedTask in updatedTasks) {
      int index = newList.indexWhere((element) => element.id == updatedTask.id);
      if (index != -1) {
        newList[index] = updatedTask;
      }
    }

    emit(state.copyWith(tasks: newList));

    try {
      await _repository.addTasks(updatedTasks);
      add(LoadListTask());
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error, message: e.toString()));
    }
  }
}
