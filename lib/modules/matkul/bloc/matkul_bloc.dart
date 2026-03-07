import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/matkul_repository.dart';
import 'matkul_event.dart';
import 'matkul_state.dart';

class MatkulBloc extends Bloc<MatkulEvent, MatkulState> {
  final MatkulRepository _repository;

  MatkulBloc(this._repository) : super(const MatkulState()) {
    on<LoadListMatkul>(_onLoadListMatkul);
    on<LoadMatkul>(_onLoadMatkul);
    on<AddMatkul>(_onAddMatkul);
    on<AddListMatkul>(_onAddListMatkul);
    on<UpdateMatkul>(_onUpdateMatkul);
    on<DeleteMatkul>(_onDeleteMatkul);
    on<DeleteAllMatkul>(_onDeleteAllMatkul);
  }

  Future<void> _onLoadListMatkul(
    LoadListMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      final matkuls = _repository.getAllMatkul();
      emit(state.copyWith(status: MatkulStatus.success, matkuls: matkuls));
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadMatkul(LoadMatkul event, Emitter<MatkulState> emit) async {
    // If we have it in list, set it
    final existing = state.matkuls.where((m) => m.id == event.id).firstOrNull;
    if (existing != null) {
      emit(state.copyWith(selectedMatkul: existing));
      return;
    }

    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      final matkul = _repository.getMatkulById(event.id);
      emit(state.copyWith(status: MatkulStatus.success, selectedMatkul: matkul));
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddMatkul(AddMatkul event, Emitter<MatkulState> emit) async {
    try {
      await _repository.addMatkul(event.matkul);
      add(LoadListMatkul());
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddListMatkul(
    AddListMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    try {
      await _repository.addMatkuls(event.matkuls);
      add(LoadListMatkul());
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateMatkul(
    UpdateMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    try {
      await _repository.updateMatkul(event.matkul);
      add(LoadListMatkul());
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteMatkul(
    DeleteMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    try {
      await _repository.deleteMatkul(event.id);
      add(LoadListMatkul());
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteAllMatkul(
    DeleteAllMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    try {
      await _repository.deleteAllMatkul();
      add(LoadListMatkul());
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }
}
