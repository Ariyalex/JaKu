import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul.dart';

abstract class MatkulEvent extends Equatable {
  const MatkulEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllMatkul extends MatkulEvent {}

class LoadMatkul extends MatkulEvent {
  final String id;
  const LoadMatkul(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadListMatkulSemester extends MatkulEvent {}

class LoadActiveSemester extends MatkulEvent {}

class SaveActiveSemester extends MatkulEvent {
  final int semester;
  const SaveActiveSemester(this.semester);

  @override
  List<Object?> get props => [semester];
}

class AddMatkul extends MatkulEvent {
  final Matkul matkul;
  const AddMatkul(this.matkul);

  @override
  List<Object?> get props => [matkul];
}

class AddListMatkul extends MatkulEvent {
  final List<Matkul> matkuls;
  const AddListMatkul(this.matkuls);

  @override
  List<Object?> get props => [matkuls];
}

class UpdateMatkul extends MatkulEvent {
  final Matkul matkul;
  const UpdateMatkul(this.matkul);

  @override
  List<Object?> get props => [matkul];
}

class UpdateListMatkulSemester extends MatkulEvent {
  final List<Matkul> matkuls;
  final int semester;
  const UpdateListMatkulSemester({
    required this.matkuls,
    required this.semester,
  });

  @override
  List<Object?> get props => [matkuls, semester];
}

class DeleteMatkuls extends MatkulEvent {
  final List<String> ids;
  const DeleteMatkuls(this.ids);

  @override
  List<Object?> get props => [ids];
}

class DeleteAllMatkul extends MatkulEvent {}
