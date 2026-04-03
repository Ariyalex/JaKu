import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_selection_state.dart';

class MatkulSelectionCubit extends Cubit<MatkulSelectionState> {
  MatkulSelectionCubit() : super(const MatkulSelectionState());

  void toggleSelection(String matkulId) {
    final newSet = Set<String>.from(state.selectedMatkulIds);
    if (newSet.contains(matkulId)) {
      newSet.remove(matkulId);
    } else {
      newSet.add(matkulId);
    }

    emit(
      state.copyWith(
        selectedMatkulIds: newSet,
        isSelectionMode: newSet.isNotEmpty,
      ),
    );
  }

  void setSelectionMode(bool value) {
    emit(state.copyWith(isSelectionMode: value));
  }

  void clearSelection() {
    emit(state.copyWith(isSelectionMode: false, selectedMatkulIds: {}));
  }
}
