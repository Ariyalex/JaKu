import 'package:flutter/material.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:jaku/provider/pdf_back.dart';
import 'package:get/get.dart';
import 'package:jaku/theme/theme.dart';

import '../routes/route_named.dart';

class PdfParsing extends StatelessWidget {
  static const routeNamed = "/pdf-parsing";
  const PdfParsing({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfback = Get.find<PdfBack>();
    final jadwalProvider = Get.find<JadwalkuliahController>();
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    final color = AppTheme.dark;

    return Scaffold(
        appBar: AppBar(
          title: const Text("PDF Otomation"),
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(RouteNamed.guidePdf);
                },
                icon: const Icon(Icons.info_outline))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  pdfback.pickPdfFile();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Pilih PDF"), Icon(Icons.file_download)],
                ),
              ),
              Container(
                width: mediaQueryWidth * 2 / 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.3),
                ),
                child: Column(
                  children: [
                    const Text("File terpilih:"),
                    Obx(() => Text(
                          pdfback.selectedFile.value?.path ??
                              'Belum ada file dipilih',
                          textAlign: TextAlign.center,
                        )),
                  ],
                ),
              ),
              Obx(() => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      pdfback.responseMessage.value,
                      style: TextStyle(
                        color: pdfback.responseMessage.value.contains('Error')
                            ? color.colorScheme.error
                            : Colors.green,
                      ),
                    ),
                  )),
              Obx(() => FilledButton(
                    onPressed:
                        pdfback.isLoading.value || pdfback.isUploading.value
                            ? null
                            : () {
                                pdfback.uploadAndProcessPdf(jadwalProvider);
                              },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) {
                            return color.disabledColor;
                          }
                          return Colors.green;
                        },
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pdfback.isLoading.value
                              ? "Memproses..."
                              : pdfback.isUploading.value
                                  ? "Menyimpan ke Firebase..."
                                  : "Upload, Proses & Simpan",
                          style: TextStyle(
                              color: pdfback.isLoading.value ||
                                      pdfback.isUploading.value
                                  ? Colors.black
                                  : Colors.white),
                        ),
                        const SizedBox(width: 8),
                        pdfback.isLoading.value || pdfback.isUploading.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.upload_file)
                      ],
                    ),
                  )),
              Obx(() {
                if (pdfback.allMatkul.isNotEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Jadwal berhasil diproses: \n${pdfback.allMatkul.length} jadwal ditambahkan",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          Get.offNamed(RouteNamed.homePage);
                        },
                        child: const Text("Kembali ke Home"),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              })
            ],
          ),
        ));
  }
}
