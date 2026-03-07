import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul.dart';

enum MatkulStatus { initial, loading, success, error }

class MatkulState extends Equatable {
  final List<Matkul> matkuls;
  final Matkul? selectedMatkul;
  final MatkulStatus status;
  final String? message;

  const MatkulState({
    this.matkuls = const [],
    this.selectedMatkul,
    this.status = MatkulStatus.initial,
    this.message,
  });

  MatkulState copyWith({
    List<Matkul>? matkuls,
    Matkul? selectedMatkul,
    MatkulStatus? status,
    String? message,
    bool clearSelected = false,
  }) {
    return MatkulState(
      matkuls: matkuls ?? this.matkuls,
      selectedMatkul: clearSelected ? null : (selectedMatkul ?? this.selectedMatkul),
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [matkuls, selectedMatkul, status, message];
}
