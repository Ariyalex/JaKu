import 'package:flutter/material.dart';
import 'package:jaku/models/jadwal.dart';

class InformasiMatkul extends StatelessWidget {
  const InformasiMatkul({super.key, required this.schedule});
  final Jadwal schedule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book, color: theme.colorScheme.primary),
                    Expanded(
                      child: Text(
                        schedule.matkul,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              (schedule.kelas != null && schedule.kelas!.isNotEmpty)
                  ? Chip(
                      label: Text("Kelas ${schedule.kelas!}"),
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  schedule.dosen1?.isNotEmpty == true
                      ? schedule.dosen1!
                      : "Dosen belum ditambahkan",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          if (schedule.dosen2?.isNotEmpty == true)
            Row(
              children: [
                Icon(Icons.person, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    schedule.dosen2!,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(Icons.room, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  schedule.room?.isNotEmpty == true
                      ? schedule.room!
                      : "Ruang belum diisi",
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(schedule.day, style: theme.textTheme.bodyLarge),
              const Spacer(),
              Icon(
                Icons.access_time,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                schedule.formattedJamAkhir?.isNotEmpty == true
                    ? "${schedule.formattedJamAwal} - ${schedule.formattedJamAkhir}"
                    : schedule.formattedJamAwal,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
