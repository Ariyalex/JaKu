import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_selection_state.dart';

class ScheduleSelectionCubit extends Cubit<ScheduleSelectionState> {
  ScheduleSelectionCubit() : super(const ScheduleSelectionState());

  void toggleSelection(String id) {
    final newSet = Set<String>.from(state.selectedScheduleIds);

    if (newSet.contains(id)) {
      newSet.remove(id);
    } else {
      newSet.add(id);
    }

    emit(
      state.copyWith(
        selectedScheduleIds: newSet,
        isSelectionMode: newSet.isNotEmpty,
      ),
    );
  }

  void setSelectionMode(bool value) {
    emit(state.copyWith(isSelectionMode: value));
  }

  void clearSelection() {
    emit(state.copyWith(selectedScheduleIds: {}, isSelectionMode: false));
  }
}
