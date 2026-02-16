import 'package:flutter/material.dart';
import 'package:jaku/data/models/matkul.dart';
import 'package:jaku/data/models/matkul_schedule.dart';

class InformasiMatkul extends StatelessWidget {
  const InformasiMatkul({super.key, required this.matkul});
  final Matkul matkul;

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
                        matkul.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              (matkul.className != null && matkul.className!.isNotEmpty)
                  ? Chip(
                      label: Text("className ${matkul.className!}"),
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  matkul.lecturer1?.isNotEmpty == true
                      ? matkul.lecturer1!
                      : "Dosen belum ditambahkan",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          if (matkul.lecturer2?.isNotEmpty == true)
            Row(
              children: [
                Icon(Icons.person, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    matkul.lecturer2!,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          // SizedBox(
          //   width: double.infinity,
          //   child: Row(
          //     children: [
          //       Icon(Icons.room, color: theme.colorScheme.primary),
          //       const SizedBox(width: 8),
          //       Text(
          //         matkul.room?.isNotEmpty == true
          //             ? matkul.room!
          //             : "Ruang belum diisi",
          //         style: theme.textTheme.bodyLarge,
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 12),
          // Row(
          //   children: [
          //     Icon(
          //       Icons.calendar_today,
          //       color: theme.colorScheme.primary,
          //       size: 20,
          //     ),
          //     const SizedBox(width: 8),
          //     Text(matkul.day, style: theme.textTheme.bodyLarge),
          //     const Spacer(),
          //     Icon(
          //       Icons.access_time,
          //       color: theme.colorScheme.primary,
          //       size: 20,
          //     ),
          //     const SizedBox(width: 4),
          //     Text(
          //       matkul.endTime?.isNotEmpty == true
          //           ? "${matkul.startTime} - ${matkul.endTime}"
          //           : matkul.startTime,
          //       style: theme.textTheme.bodyLarge,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
