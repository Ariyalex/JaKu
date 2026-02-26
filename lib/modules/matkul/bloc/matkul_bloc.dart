import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/matkul_repository.dart';
import 'matkul_event.dart';
import 'matkul_state.dart';

class MatkulBloc extends Bloc<MatkulEvent, MatkulState> {
  final MatkulRepository _repository;

  MatkulBloc(this._repository) : super(MatkulInitial()) {
    on<LoadListMatkul>(_onLoadListMatkul);

    // Menangani event LoadMatkul
    on<LoadMatkul>(_onLoadMatkul);

    // Menangani event AddMatkul
    on<AddMatkul>(_onAddMatkul);

    // Menangani event UpdateMatkul
    on<UpdateMatkul>(_onUpdateMatkul);

    // Menangani event DeleteMatkul
    on<DeleteMatkul>(_onDeleteMatkul);

    // Menangani event DeleteAllMatkul
    on<DeleteAllMatkul>(_onDeleteAllMatkul);
  }

  Future<void> _onLoadListMatkul(
    LoadListMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    emit(MatkulListLoading());
    try {
      final matkuls = _repository.getAllMatkul();
      emit(MatkulListLoaded(matkuls));
    } catch (e) {
      emit(MatkulError(e.toString()));
    }
  }

  Future<void> _onLoadMatkul(
    LoadMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    emit(MatkulListLoading());
    try {
      final matkul = _repository.getMatkulById(event.id);
      emit(MatkulLoaded(matkul));
    } catch (e) {
      emit(MatkulError(e.toString()));
    }
  }

  Future<void> _onAddMatkul(AddMatkul event, Emitter<MatkulState> emit) async {
    try {
      await _repository.addMatkul(event.matkul);
      // Setelah tambah, kita refresh data
      add(LoadListMatkul());
    } catch (e) {
      emit(MatkulError(e.toString()));
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
      emit(MatkulError(e.toString()));
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
      emit(MatkulError(e.toString()));
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
      emit(MatkulError(e.toString()));
    }
  }
}
