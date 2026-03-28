import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/matkul_repository.dart';
import 'matkul_event.dart';
import 'matkul_state.dart';

class MatkulBloc extends Bloc<MatkulEvent, MatkulState> {
  final MatkulRepository _repository;

  MatkulBloc(this._repository) : super(const MatkulState()) {
    on<LoadAllMatkul>(_onLoadListMatkul);
    on<LoadListMatkulSemester>(_onLoadListMatkulSemester);
    on<LoadMatkul>(_onLoadMatkul);
    on<AddMatkul>(_onAddMatkul);
    on<AddListMatkul>(_onAddListMatkul);
    on<UpdateMatkul>(_onUpdateMatkul);
    on<DeleteMatkul>(_onDeleteMatkul);
    on<DeleteAllMatkul>(_onDeleteAllMatkul);
    on<UpdateListMatkulSemester>(_onUpdateListMatkulSemester);
    on<LoadActiveSemester>(_onLoadActiveSemester);
    on<SaveActiveSemester>(_onSaveActiveSemester);
  }

  Future<void> _onLoadListMatkul(
    LoadAllMatkul event,
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

  Future<void> _onLoadListMatkulSemester(
    LoadListMatkulSemester event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      final matkuls = _repository.getListMatkulSemester(state.activeSemester);
      emit(
        state.copyWith(activeMatkuls: matkuls, status: MatkulStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadMatkul(
    LoadMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    // If we have it in list, set it
    final existing = state.matkuls.where((m) => m.id == event.id).firstOrNull;
    if (existing != null) {
      emit(state.copyWith(selectedMatkul: existing));
      return;
    }

    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      final matkul = _repository.getMatkulById(event.id);
      emit(
        state.copyWith(status: MatkulStatus.success, selectedMatkul: matkul),
      );
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddMatkul(AddMatkul event, Emitter<MatkulState> emit) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      await _repository.addMatkul(event.matkul);

      _refreshAllData(emit);
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
      _refreshAllData(emit);
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

      _refreshAllData(emit);
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

      _refreshAllData(emit);
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
      _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateListMatkulSemester(
    UpdateListMatkulSemester event,
    Emitter<MatkulState> emit,
  ) async {
    try {
      for (var matkul in event.matkuls) {
        final newMatkul = matkul.copyWith(semester: event.semester);
        await _repository.updateMatkul(newMatkul);
      }

      _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadActiveSemester(
    LoadActiveSemester event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.success));
    try {
      final result = _repository.getActiveSemester();
      emit(state.copyWith(activeSemester: result));
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onSaveActiveSemester(
    SaveActiveSemester event,
    Emitter<MatkulState> emit,
  ) async {
    try {
      await _repository.updateActiveSemester(event.semester);
      emit(state.copyWith(activeSemester: event.semester));
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _refreshAllData(Emitter<MatkulState> emit) async {
    try {
      final result = await Future.wait([
        Future.value(_repository.getAllMatkul()),
        Future.value(_repository.getListMatkulSemester(state.activeSemester)),
      ]);

      final allMatkul = result[0];
      final activeMatkuls = result[1];

      emit(
        state.copyWith(
          matkuls: allMatkul,
          activeMatkuls: activeMatkuls,
          status: MatkulStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }
}
