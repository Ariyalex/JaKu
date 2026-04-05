import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';

abstract class PdfParseEvent extends Equatable {
  const PdfParseEvent();

  @override
  List<Object?> get props => [];
}

class UploadAndProcessPdf extends PdfParseEvent {
  final File pdfFile;
  const UploadAndProcessPdf(this.pdfFile);

  @override
  List<Object?> get props => [pdfFile];
}

class UpdateParsedMatkul extends PdfParseEvent {
  final Matkul updatedMatkul;
  const UpdateParsedMatkul(this.updatedMatkul);

  @override
  List<Object?> get props => [updatedMatkul];
}

class UpdateParsedSchedule extends PdfParseEvent {
  final MatkulSchedule updatedSchedule;
  const UpdateParsedSchedule(this.updatedSchedule);

  @override
  List<Object?> get props => [updatedSchedule];
}

class UpdateSemesterMultipleMatkul extends PdfParseEvent {
  final List<String> matkulIds;
  final int newSemester;
  const UpdateSemesterMultipleMatkul(this.matkulIds, this.newSemester);

  @override
  List<Object?> get props => [matkulIds, newSemester];
}
