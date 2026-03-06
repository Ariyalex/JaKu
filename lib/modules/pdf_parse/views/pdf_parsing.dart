import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_bloc.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_event.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_state.dart';
import 'package:get/get.dart';
import 'package:jaku/core/theme/theme.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';

import '../../../core/routes/route_named.dart';

class PdfParsing extends HookWidget {
  const PdfParsing({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    final color = AppTheme.dark;

    final pdfBloc = context.read<PdfParseBloc>();
    final matkulBlocState = context.watch<MatkulBloc>().state;
    final scheduleBlocState = context.watch<ScheduleBloc>().state;

    final selectedFile = useState<File?>(null);
    final responseMessage = useState<String>("");

    Future<void> pickPdfFile() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowMultiple: false,
          withData: false,
          withReadStream: false,
          dialogTitle: 'Pilih File PDF',
        );

        if (result != null && result.files.isNotEmpty) {
          final file = result.files.single;
          if (file.extension?.toLowerCase() != 'pdf') {
            responseMessage.value = "File yang dipilih bukan PDF";
            return;
          }
          selectedFile.value = File(file.path!);
          responseMessage.value = "File dipilih: ${file.name}";
        }
      } catch (e) {
        responseMessage.value = "Error saat memilih file: $e";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Otomation"),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteNamed.guidePdf);
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () {
                pickPdfFile();
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text("Pilih PDF"), Icon(Icons.file_download)],
              ),
            ),
            if (selectedFile.value == null)
              Container(
                width: mediaQueryWidth * 2 / 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.3),
                ),
                child: const Text(
                  'Belum ada file dipilih',
                  textAlign: TextAlign.center,
                ),
              ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                responseMessage.value,
                style: TextStyle(
                  color: responseMessage.value.contains('Error')
                      ? color.colorScheme.error
                      : Colors.green.shade400,
                ),
              ),
            ),
            BlocBuilder<PdfParseBloc, PdfParseState>(
              builder: (context, state) {
                return FilledButton(
                  onPressed:
                      (state is PdfParseLoading) && selectedFile.value == null
                      ? null
                      : () {
                          pdfBloc.add(UploadAndProcessPdf(selectedFile.value!));

                          if (state is PdfParseSuccess) {
                            context.read<MatkulBloc>().add(
                              AddListMatkul(state.matkuls),
                            );
                            context.read<ScheduleBloc>().add(
                              AddListSchedule(state.schedules),
                            );

                            if (matkulBlocState is MatkulError) {
                              responseMessage.value =
                                  'Error: ${matkulBlocState.message}';
                            } else if (scheduleBlocState is ScheduleError) {
                              responseMessage.value =
                                  'Error: ${scheduleBlocState.message}';
                            }
                          } else if (state is PdfParseFailure) {
                            responseMessage.value = 'Error: ${state.message}';
                          }
                        },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      Set<WidgetState> states,
                    ) {
                      if (states.contains(WidgetState.disabled)) {
                        return color.disabledColor;
                      }
                      return Colors.green.shade400;
                    }),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (state is PdfParseLoading)
                            ? "Memproses..."
                            : "Upload, Proses & Simpan",
                        style: TextStyle(
                          color: (state is PdfParseLoading)
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      (state is PdfParseLoading)
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.upload_file),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
