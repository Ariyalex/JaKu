import 'package:equatable/equatable.dart';

class MatkulSelectionState extends Equatable {
  final Set<String> selectedMatkulIds;
  final bool isSelectionMode;

  const MatkulSelectionState({
    this.selectedMatkulIds = const {},
    this.isSelectionMode = false,
  });

  @override
  List<Object?> get props => [selectedMatkulIds, isSelectionMode];

  MatkulSelectionState copyWith({
    Set<String>? selectedMatkulIds,
    bool? isSelectionMode,
  }) {
    return MatkulSelectionState(
      selectedMatkulIds: selectedMatkulIds ?? this.selectedMatkulIds,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }
}
