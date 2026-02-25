import 'package:equatable/equatable.dart';
import 'package:jaku/data/models/matkul.dart';

abstract class MatkulEvent extends Equatable {
  const MatkulEvent();

  @override
  List<Object?> get props => [];
}

class LoadMatkul extends MatkulEvent {}

class AddMatkul extends MatkulEvent {
  final Matkul matkul;
  const AddMatkul(this.matkul);

  @override
  List<Object?> get props => [matkul];
}

class UpdateMatkul extends MatkulEvent {
  final Matkul matkul;
  const UpdateMatkul(this.matkul);

  @override
  List<Object?> get props => [matkul];
}

class DeleteMatkul extends MatkulEvent {
  final String id;
  const DeleteMatkul(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteAllMatkul extends MatkulEvent {}
