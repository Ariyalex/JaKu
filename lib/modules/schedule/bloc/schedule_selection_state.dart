import 'package:equatable/equatable.dart';

class ScheduleSelectionState extends Equatable {
  final Set<String> selectedScheduleIds;
  final bool isSelectionMode;

  const ScheduleSelectionState({
    this.selectedScheduleIds = const {},
    this.isSelectionMode = false,
  });

  @override
  List<Object?> get props => [selectedScheduleIds, isSelectionMode];

  ScheduleSelectionState copyWith({
    Set<String>? selectedScheduleIds,
    bool? isSelectionMode,
  }) {
    return ScheduleSelectionState(
      selectedScheduleIds: selectedScheduleIds ?? this.selectedScheduleIds,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }
}
