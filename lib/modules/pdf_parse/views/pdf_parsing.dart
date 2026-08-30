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
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:jaku/modules/pdf_parse/views/widgets/edit_parsed_matkul_dialog.dart';
import 'package:jaku/modules/pdf_parse/views/widgets/edit_parsed_schedule_dialog.dart';

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
    final selectedIds = useState<Set<String>>({});

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

    void showBulkSemesterDialog(BuildContext context, List<String> ids) {
      final controller = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Set Semester (${ids.length} Matkul)"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Semester",
              hintText: "Contoh: 1",
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            FilledButton(
              onPressed: () {
                final s = int.tryParse(controller.text);
                if (s != null && s >= 1) {
                  pdfBloc.add(UpdateSemesterMultipleMatkul(ids, s));
                  selectedIds.value = {};
                  Navigator.pop(context);
                } else {
                  MySnackbar.error(
                    title: "Gagal!",
                    message: "Semester harus berupa angka >= 1",
                  );
                }
              },
              child: const Text("Terapkan"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Otomation"),
        actions: [
          if (selectedIds.value.isNotEmpty)
            IconButton(
              onPressed: () =>
                  showBulkSemesterDialog(context, selectedIds.value.toList()),
              icon: const Icon(LucideIcons.layers),
              tooltip: "Ubah Semester Terpilih",
            ),
          IconButton(
            onPressed: () {
              context.pushNamed(RouteNamed.guidePdf);
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<PdfParseBloc, PdfParseState>(
          listener: (context, state) {
            if (state is PdfParseFailure) {
              responseMessage.value = 'Error: ${state.message}';
              MySnackbar.error(title: "Gagal!", message: state.message);
            }
          },
          builder: (context, state) {
            if (state is PdfParseSuccess) {
              return Column(
                children: [
                  if (state.matkuls.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedIds.value.length ==
                                state.matkuls.length,
                            onChanged: (val) {
                              if (val == true) {
                                selectedIds.value =
                                    state.matkuls.map((m) => m.id).toSet();
                              } else {
                                selectedIds.value = {};
                              }
                            },
                          ),
                          const Text("Pilih Semua"),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.matkuls.length,
                      itemBuilder: (context, index) {
                        final matkul = state.matkuls[index];
                        final schedulesForMatkul = state.schedules
                            .where((s) => s.matkulId == matkul.id)
                            .toList();
                        final isSemesterInvalid = matkul.semester < 1;
                        final isSelected =
                            selectedIds.value.contains(matkul.id);

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : isSemesterInvalid
                                      ? Theme.of(context).colorScheme.error
                                      : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              final current = Set<String>.from(
                                selectedIds.value,
                              );
                              if (current.contains(matkul.id)) {
                                current.remove(matkul.id);
                              } else {
                                current.add(matkul.id);
                              }
                              selectedIds.value = current;
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isSemesterInvalid)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.errorContainer,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            size: 16,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onErrorContainer,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Semester harus diisi!",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onErrorContainer,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (val) {
                                          final current = Set<String>.from(
                                            selectedIds.value,
                                          );
                                          if (val == true) {
                                            current.add(matkul.id);
                                          } else {
                                            current.remove(matkul.id);
                                          }
                                          selectedIds.value = current;
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          matkul.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(LucideIcons.squarePen),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                EditParsedMatkulDialog(
                                                  matkul: matkul,
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 48.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Singkatan: ${matkul.nameAbbreviation}",
                                        ),
                                        if (matkul.lecturer1 != null)
                                          Text("Dosen 1: ${matkul.lecturer1}"),
                                        if (matkul.lecturer2 != null)
                                          Text("Dosen 2: ${matkul.lecturer2}"),
                                        Text(
                                          "Semester: ${isSemesterInvalid ? 'Belum diset' : matkul.semester}",
                                          style: TextStyle(
                                            color: isSemesterInvalid
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.error
                                                : null,
                                            fontWeight: isSemesterInvalid
                                                ? FontWeight.bold
                                                : null,
                                          ),
                                        ),
                                        const Divider(),
                                        const Text(
                                          "Jadwal:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ...schedulesForMatkul.map((schedule) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${schedule.day.display}, ${schedule.startTime.format(context)} - ${schedule.endTime?.format(context) ?? '?'}\nLokasi: ${schedule.room ?? '-'}",
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  LucideIcons.penLine,
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        EditParsedScheduleDialog(
                                                          schedule: schedule,
                                                        ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(LucideIcons.save),
                        label: const Text("Simpan ke Jadwal"),
                        onPressed: () {
                          if (state.matkuls.any((m) => m.semester < 1)) {
                            MySnackbar.error(
                              title: "Gagal!",
                              message:
                                  "Ada mata kuliah yang belum diatur semesternya.",
                            );
                            return;
                          }
                          matkulBloc.add(AddListMatkul(state.matkuls));
                          scheduleBloc.add(AddListSchedule(state.schedules));
                          MySnackbar.success(
                            title: "Berhasil!",
                            message: "Data jadwal berhasil diimpor dari PDF",
                          );
                          context.pop();
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(
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
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            state is PdfParseLoading ||
                                selectedFile.value == null
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
                                state is PdfParseLoading
                                    ? "Memproses..."
                                    : "Upload, Proses & Review",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (state is PdfParseLoading)
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
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
