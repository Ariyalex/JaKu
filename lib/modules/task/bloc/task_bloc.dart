import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/task_repository.dart';
import 'package:jaku/modules/task/bloc/task_event.dart';
import 'package:jaku/modules/task/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;
  TaskBloc(this._repository) : super(TaskInitial()) {
    on<LoadListTask>(_onLoadListTask);
    on<LoadListTaskByMatkul>(_onLoadListTaskByMatkul);
    on<LoadTask>(_onLoadTask);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<DeleteAllTask>(_onDeleteAllTask);
  }

  Future<void> _onLoadListTask(
    LoadListTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskListLoading());
    try {
      final tasks = _repository.getAllTask();
      emit(TaskListLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onLoadTask(LoadTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final task = _repository.getTaskById(event.id);
      emit(TaskLoaded(task));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onLoadListTaskByMatkul(
    LoadListTaskByMatkul event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskListByMatkulLoading());
    try {
      final tasks = _repository.getTasksByMatkul(event.matkulId);
      emit(TaskListByMatkulLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await _repository.addTask(event.task);
      add(LoadListTask());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await _repository.updateTask(event.task);
      add(LoadListTask());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await _repository.deleteTask(event.id);
      add(LoadListTask());
    } catch (e) {
      emit(TaskError(e.toString()));
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
      emit(TaskError(e.toString()));
    }
  }
}
