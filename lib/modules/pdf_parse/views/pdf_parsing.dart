import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/my_snackbar.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_bloc.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_event.dart';
import 'package:jaku/modules/pdf_parse/bloc/pdf_parse_state.dart';
import 'package:jaku/core/theme/theme.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/core/routes/route_named.dart';

class PdfParsing extends HookWidget {
  const PdfParsing({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final color = AppTheme.dark;

    final pdfBloc = context.read<PdfParseBloc>();
    final matkulBloc = context.read<MatkulBloc>();
    final scheduleBloc = context.read<ScheduleBloc>();

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

    return BlocListener<PdfParseBloc, PdfParseState>(
      listener: (context, state) {
        if (state is PdfParseSuccess) {
          // 1. Kirim data hasil parse ke BLoC Matkul dan Schedule
          matkulBloc.add(AddListMatkul(state.matkuls));
          scheduleBloc.add(AddListSchedule(state.schedules));

          // 2. Berikan notifikasi sukses
          MySnackbar.success(
            title: "Berhasil!",
            message: "Data jadwal berhasil diimpor dari PDF",
          );

          // 3. Kembali ke dashboard
          context.pop();
        } else if (state is PdfParseFailure) {
          responseMessage.value = 'Error: ${state.message}';
          MySnackbar.error(title: "Gagal!", message: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("PDF Otomation"),
          actions: [
            IconButton(
              onPressed: () {
                context.pushNamed(RouteNamed.guidePdf);
              },
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: pickPdfFile,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Pilih PDF"),
                      SizedBox(width: 8),
                      Icon(Icons.file_download),
                    ],
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
                if (responseMessage.value.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Text(
                      responseMessage.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: responseMessage.value.contains('Error')
                            ? color.colorScheme.error
                            : Colors.green.shade400,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BlocBuilder<PdfParseBloc, PdfParseState>(
                    builder: (context, state) {
                      final isLoading = state is PdfParseLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading || selectedFile.value == null
                              ? null
                              : () {
                                  pdfBloc.add(
                                    UploadAndProcessPdf(selectedFile.value!),
                                  );
                                },

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLoading
                                      ? "Memproses..."
                                      : "Upload, Proses & Simpan",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                if (isLoading)
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  const Icon(Icons.upload_file),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
