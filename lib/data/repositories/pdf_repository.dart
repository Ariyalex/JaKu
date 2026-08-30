import 'dart:io';

import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/providers/remote_pdf_provider.dart';

class PdfRepository {
  final RemotePdfProvider _localProvider;
  PdfRepository(this._localProvider);

  Future<({List<Matkul> matkuls, List<MatkulSchedule> schedules})>
  uploadAndProcessPdf(File file) async {
    try {
      final response = await _localProvider.uploadAndProcessPdf(file);
      return (
        matkuls: response.matkuls.map((e) => e.toEntity()).toList(),
        schedules: response.schedules.map((e) => e.toEntity()).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
