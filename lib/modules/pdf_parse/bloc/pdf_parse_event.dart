import 'dart:io';

import 'package:equatable/equatable.dart';

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
