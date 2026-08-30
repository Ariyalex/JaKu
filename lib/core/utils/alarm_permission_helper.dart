import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissionHelper {
  static Future<void> requestEssentialPermissions(BuildContext context) async {
    // 1. Minta izin Notifikasi (Android 13+)
    if (!await Permission.notification.isGranted) {
      await Permission.notification.request();
    }

    // 2. Minta izin Exact Alarm (Android 13/14+ agar berbunyi tepat waktu)
    if (!await Permission.scheduleExactAlarm.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }

    // 3. Minta izin tampil di atas aplikasi lain (System Alert Window / overlay)
    if (!await Permission.systemAlertWindow.isGranted) {
      await Permission.systemAlertWindow.request();
    }

    // 4. Minta izin mematikan optimasi baterai (Mencegah OS membunuh isolate)
    if (!await Permission.ignoreBatteryOptimizations.isGranted) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    final isAlertWindowGranted = await Permission.systemAlertWindow.isGranted;
    final isBatteryOptimizationsIgnored = await Permission.ignoreBatteryOptimizations.isGranted;

    if (!context.mounted) return;

    // Tampilkan dialog panduan perizinan vendor khusus (Xiaomi/Oppo/Samsung)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Panduan Izin Khusus"),
        content: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Untuk memastikan alarm menyala tepat waktu dan dapat menembus layar kunci, mohon periksa dan aktifkan opsi berikut di Pengaturan Aplikasi:\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text("1. Tampil di Layar Kunci (Show on Lock Screen)"),
                const Text("2. Tampilkan Jendela Pop-up Latar Belakang (Display pop-up windows in background)"),
                const Text("3. Mulai Otomatis (Autostart) - Sangat disarankan untuk Xiaomi/Poco"),
                const Text("4. Tampil di atas aplikasi lain (Draw over other apps)"),
                const Text("5. Baterai: Tidak ada pembatasan (Unrestricted / No Restrictions)"),
                const SizedBox(height: 16),
                Text(
                  "Status saat ini:\n"
                  "• Overlay Aplikasi: ${isAlertWindowGranted ? 'Aktif' : 'Nonaktif'}\n"
                  "• Bebas Hambatan Baterai: ${isBatteryOptimizationsIgnored ? 'Aktif' : 'Nonaktif'}",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Buka halaman App Info di pengaturan sistem
              await openAppSettings();
            },
            child: const Text("Buka Pengaturan"),
          ),
        ],
      ),
    );
  }
}
