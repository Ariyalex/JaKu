import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/pdf_repository.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_event.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_state.dart';

class PdfParseBloc extends Bloc<PdfParseEvent, PdfParseState> {
  final PdfRepository _repository;

  PdfParseBloc(this._repository) : super(PdfparseInitial()) {
    on<UploadAndProcessPdf>(_onUploadAndProcessPdf);
    on<UpdateParsedMatkul>(_onUpdateParsedMatkul);
    on<UpdateParsedSchedule>(_onUpdateParsedSchedule);
    on<UpdateSemesterMultipleMatkul>(_onUpdateSemesterMultipleMatkul);
  }

  void _onUpdateSemesterMultipleMatkul(
    UpdateSemesterMultipleMatkul event,
    Emitter<PdfParseState> emit,
  ) {
    if (state is PdfParseSuccess) {
      final currentState = state as PdfParseSuccess;
      final updatedMatkuls = currentState.matkuls.map((matkul) {
        if (event.matkulIds.contains(matkul.id)) {
          return matkul.copyWith(semester: event.newSemester);
        }
        return matkul;
      }).toList();

      emit(PdfParseSuccess(
        matkuls: updatedMatkuls,
        schedules: currentState.schedules,
      ));
    }
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

  void _onUpdateParsedMatkul(
    UpdateParsedMatkul event,
    Emitter<PdfParseState> emit,
  ) {
    if (state is PdfParseSuccess) {
      final currentState = state as PdfParseSuccess;
      final updatedMatkuls = currentState.matkuls.map((matkul) {
        return matkul.id == event.updatedMatkul.id
            ? event.updatedMatkul
            : matkul;
      }).toList();

      emit(PdfParseSuccess(
        matkuls: updatedMatkuls,
        schedules: currentState.schedules,
      ));
    }
  }

  void _onUpdateParsedSchedule(
    UpdateParsedSchedule event,
    Emitter<PdfParseState> emit,
  ) {
    if (state is PdfParseSuccess) {
      final currentState = state as PdfParseSuccess;
      final updatedSchedules = currentState.schedules.map((schedule) {
        return schedule.id == event.updatedSchedule.id
            ? event.updatedSchedule
            : schedule;
      }).toList();

      emit(PdfParseSuccess(
        matkuls: currentState.matkuls,
        schedules: updatedSchedules,
      ));
    }
  }
}
