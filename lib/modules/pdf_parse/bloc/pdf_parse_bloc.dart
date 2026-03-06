import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/pdf_repository.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_event.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_state.dart';

class PdfParseBloc extends Bloc<PdfParseEvent, PdfParseState> {
  final PdfRepository _repository;

  PdfParseBloc(this._repository) : super(PdfparseInitial()) {
    on<UploadAndProcessPdf>(_onUploadAndProcessPdf);
  }

  Future<void> _onUploadAndProcessPdf(
    UploadAndProcessPdf event,
    Emitter<PdfParseState> emit,
  ) async {
    emit(PdfParseLoading());
    try {
      final response = await _repository.uploadAndProcessPdf(event.pdfFile);
      emit(
        PdfParseSuccess(
          matkuls: response.matkuls,
          schedules: response.schedules,
        ),
      );
    } catch (e) {
      emit(PdfParseFailure(e.toString()));
    }
  }
}
