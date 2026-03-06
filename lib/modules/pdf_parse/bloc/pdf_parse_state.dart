import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';

abstract class PdfParseState extends Equatable {
  const PdfParseState();

  @override
  List<Object?> get props => [];
}

class PdfparseInitial extends PdfParseState {}

class PdfParseLoading extends PdfParseState {}

class PdfParseSuccess extends PdfParseState {
  final List<Matkul> matkuls;
  final List<MatkulSchedule> schedules;
  const PdfParseSuccess({required this.matkuls, required this.schedules});

  @override
  List<Object?> get props => [matkuls, schedules];
}

class PdfParseFailure extends PdfParseState {
  final String message;
  const PdfParseFailure(this.message);

  @override
  List<Object?> get props => [message];
}
