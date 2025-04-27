import 'package:flutter/material.dart';
import 'package:jaku/provider/jadwal_kuliah.dart';
import 'package:jaku/provider/pdf_back.dart';
import 'package:jaku/screens/guide_pdf.dart';
import 'package:provider/provider.dart';

class PdfParsing extends StatelessWidget {
  static const routeNamed = "/pdf-parsing";
  const PdfParsing({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfback = Provider.of<PdfBack>(context);
    final jadwalProvider = Provider.of<Jadwalkuliah>(context, listen: false);
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text("PDF Otomation"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, GuidePdf.routeNamed);
                },
                icon: Icon(Icons.info_outline))
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
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.3),
                ),
                child: Column(
                  children: [
                    Text("File terpilih:"),
                    Text(
                      pdfback.selectedFile?.path ?? 'Belum ada file dipilih',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  pdfback.responseMessage ?? '',
                  style: TextStyle(
                    color: pdfback.responseMessage?.contains('Error') ?? false
                        ? Color(0xFFCF6679)
                        : Colors.green,
                  ),
                ),
              ),
              FilledButton(
                onPressed: pdfback.isLoading || pdfback.isUploading
                    ? null
                    : () {
                        pdfback.uploadAndProcessPdf(jadwalProvider);
                      },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey.shade500;
                      }
                      return Colors.green;
                    },
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pdfback.isLoading
                          ? "Memproses..."
                          : pdfback.isUploading
                              ? "Menyimpan ke Firebase..."
                              : "Upload, Proses & Simpan",
                      style: TextStyle(
                          color: pdfback.isLoading || pdfback.isUploading
                              ? Colors.black
                              : Colors.white),
                    ),
                    const SizedBox(width: 8),
                    pdfback.isLoading || pdfback.isUploading
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
              ),
              if (pdfback.allMatkul.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  "Jadwal berhasil diproses: \n${pdfback.allMatkul.length} jadwal ditambahkan",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text("Kembali ke Home"),
                ),
              ]
            ],
          ),
        ));
  }
}
