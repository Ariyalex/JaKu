import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul.dart';

enum MatkulStatus { initial, loading, success, error }

class MatkulState extends Equatable {
  final List<Matkul> matkuls;
  final List<Matkul> activeMatkuls;
  final Matkul? selectedMatkul;
  final MatkulStatus status;
  final String? message;
  final int activeSemester;

  const MatkulState({
    this.matkuls = const [],
    this.activeMatkuls = const [],
    this.selectedMatkul,
    this.status = MatkulStatus.initial,
    this.message,
    this.activeSemester = -1,
  });

  MatkulState copyWith({
    List<Matkul>? matkuls,
    List<Matkul>? activeMatkuls,
    Matkul? selectedMatkul,
    MatkulStatus? status,
    String? message,
    int? activeSemester,
    bool clearSelected = false,
  }) {
    return MatkulState(
      matkuls: matkuls ?? this.matkuls,
      activeMatkuls: activeMatkuls ?? this.activeMatkuls,
      selectedMatkul: clearSelected
          ? null
          : (selectedMatkul ?? this.selectedMatkul),
      status: status ?? this.status,
      message: message ?? this.message,
      activeSemester: activeSemester ?? this.activeSemester,
    );
  }

  @override
  List<Object?> get props => [
    matkuls,
    activeMatkuls,
    selectedMatkul,
    status,
    activeSemester,
    message,
  ];
}
