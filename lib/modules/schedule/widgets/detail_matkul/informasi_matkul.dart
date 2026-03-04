import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';

class InformasiMatkul extends HookWidget {
  const InformasiMatkul({super.key, required this.matkulId});
  final String matkulId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matkulBloc = context.read<MatkulBloc>();

    useEffect(() {
      matkulBloc.add(LoadMatkul(matkulId));
      return;
    }, [matkulId]);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: BlocBuilder<MatkulBloc, MatkulState>(
        bloc: matkulBloc,
        builder: (context, state) {
          if (state is MatkulLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MatkulError) {
            return Center(child: Text(state.message));
          }

          if (state is MatkulLoaded) {
            final matkul = state.matkul;
            return Column(
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
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
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
                BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    if (state is ScheduleLoaded) {
                      final schedule = state.schedule;
                      final String scheduleStartTime =
                          TimeParserHelper.formatDateTimeToString(
                            schedule.startTime,
                          );
                      final String scheduleEndTime = schedule.endTime != null
                          ? TimeParserHelper.formatDateTimeToString(
                              schedule.endTime!,
                            )
                          : "";
                      return Column(
                        children: [
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.room,
                                  color: theme.colorScheme.primary,
                                ),
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
                              Text(
                                schedule.day.label,
                                style: theme.textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.access_time,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                schedule.endTime != null
                                    ? "$scheduleStartTime - $scheduleEndTime"
                                    : scheduleStartTime,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
