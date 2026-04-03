import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScheduleDialogs {
  static Future<void> showDeleteSchedules(
    BuildContext context,
    VoidCallback confirmAction,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Hapus Jadwal Yang Dipilih?",
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "Yakin ingin menghapus jadwal yang sudah tepilih?",
          textAlign: TextAlign.center,
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              context.pop(); // Tutup dialog konfirmasi
            },
            child: const Text("Tidak"),
          ),
          FilledButton(onPressed: confirmAction, child: const Text("Ya")),
        ],
      ),
    );
  }
}
