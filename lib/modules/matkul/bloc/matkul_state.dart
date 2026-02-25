import 'package:equatable/equatable.dart';
import 'package:jaku/data/models/matkul.dart';

abstract class MatkulState extends Equatable {
  const MatkulState();

  @override
  List<Object?> get props => [];
}

class MatkulInitial extends MatkulState {}

class MatkulLoading extends MatkulState {}

class MatkulLoaded extends MatkulState {
  final List<Matkul> matkuls;
  const MatkulLoaded(this.matkuls);

  @override
  List<Object?> get props => [matkuls];
}

class MatkulError extends MatkulState {
  final String message;
  const MatkulError(this.message);

  @override
  List<Object?> get props => [message];
}
