import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/repositories/matkul_repository.dart';
import 'package:jaku/data/repositories/matkul_schedule_repository.dart';
import 'package:jaku/data/repositories/note_repositoruy.dart';
import 'package:jaku/data/repositories/task_repository.dart';
import 'matkul_event.dart';
import 'matkul_state.dart';

class MatkulBloc extends Bloc<MatkulEvent, MatkulState> {
  final MatkulRepository _matkulRepository;
  final MatkulScheduleRepository _scheduleRepository;
  final NoteRepository _noteRepository;
  final TaskRepository _taskRepository;

  MatkulBloc(
    this._matkulRepository,
    this._scheduleRepository,
    this._noteRepository,
    this._taskRepository,
  ) : super(const MatkulState()) {
    on<LoadAllMatkul>(_onLoadListMatkul);
    on<LoadListMatkulSemester>(_onLoadListMatkulSemester);
    on<LoadMatkul>(_onLoadMatkul);
    on<AddMatkul>(_onAddMatkul);
    on<AddListMatkul>(_onAddListMatkul);
    on<UpdateMatkul>(_onUpdateMatkul);
    on<DeleteMatkuls>(_onDeleteMatkuls);
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
      final matkuls = _matkulRepository.getAllMatkul();

      emit(state.copyWith(status: MatkulStatus.success, matkuls: matkuls));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadListMatkulSemester(
    LoadListMatkulSemester event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      final matkuls = _matkulRepository.getListMatkulSemester(
        state.activeSemester,
      );
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
      final matkul = _matkulRepository.getMatkulById(event.id);
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
      await _matkulRepository.addMatkul(event.matkul);
      emit(
        state.copyWith(
          status: MatkulStatus.actionSuccess,
          message: "Berhasil menambahkan matkul baru!",
        ),
      );

      await _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddListMatkul(
    AddListMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      await _matkulRepository.addMatkuls(event.matkuls);
      emit(state.copyWith(status: MatkulStatus.actionSuccess, message: null));

      await _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateMatkul(
    UpdateMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      await _matkulRepository.updateMatkul(event.matkul);
      emit(
        state.copyWith(
          status: MatkulStatus.actionSuccess,
          message: "Berhasil memperbarui matkul!",
        ),
      );

      await _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteMatkuls(
    DeleteMatkuls event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      await _scheduleRepository.deleteSchedulesByMatkulIds(event.ids);
      await _noteRepository.deleteNotesByMatkulIds(event.ids);
      await _taskRepository.deleteTasksByMatkulIds(event.ids);

      await _matkulRepository.deleteMatkuls(event.ids);

      emit(
        state.copyWith(
          status: MatkulStatus.actionSuccess,
          message: "Berhasil menghapus matkuls!",
        ),
      );

      await _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteAllMatkul(
    DeleteAllMatkul event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      await _matkulRepository.deleteAllMatkul();
      emit(
        state.copyWith(
          status: MatkulStatus.actionSuccess,
          message: "Berhasil menghapus semua matkul!",
        ),
      );

      await _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateListMatkulSemester(
    UpdateListMatkulSemester event,
    Emitter<MatkulState> emit,
  ) async {
    emit(state.copyWith(status: MatkulStatus.loading));
    try {
      for (var matkul in event.matkuls) {
        final newMatkul = matkul.copyWith(semester: event.semester);
        await _matkulRepository.updateMatkul(newMatkul);
      }

      emit(
        state.copyWith(
          status: MatkulStatus.actionSuccess,
          message: "Berhasil mengubah semester matkul!",
        ),
      );
      await _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadActiveSemester(
    LoadActiveSemester event,
    Emitter<MatkulState> emit,
  ) async {
    try {
      final result = _matkulRepository.getActiveSemester();
      emit(state.copyWith(activeSemester: result));
      add(LoadListMatkulSemester());
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _onSaveActiveSemester(
    SaveActiveSemester event,
    Emitter<MatkulState> emit,
  ) async {
    try {
      await _matkulRepository.updateActiveSemester(event.semester);
      emit(state.copyWith(activeSemester: event.semester));
      await _refreshAllData(emit);
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }

  Future<void> _refreshAllData(Emitter<MatkulState> emit) async {
    try {
      final allMatkul = _matkulRepository.getAllMatkul();

      final allSemester = allMatkul.map((matkul) => matkul.semester).toSet();
      int currentActiveSemester = state.activeSemester;

      if (!allSemester.contains(currentActiveSemester)) {
        currentActiveSemester = allSemester.maxOrNull ?? -1;
      }

      final List<Matkul> activeMatkuls = _matkulRepository
          .getListMatkulSemester(currentActiveSemester);

      await _matkulRepository.updateActiveSemester(currentActiveSemester);

      emit(
        state.copyWith(
          matkuls: allMatkul,
          activeMatkuls: activeMatkuls,
          status: MatkulStatus.success,
          message: null,
          activeSemester: currentActiveSemester,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: MatkulStatus.error, message: e.toString()));
    }
  }
}
