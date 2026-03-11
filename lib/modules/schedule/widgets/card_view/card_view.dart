import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/core/utils/matkul_utils.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';
import 'package:jaku/modules/schedule/widgets/card_view/matkul_card.dart';
import 'package:jaku/modules/schedule/widgets/jadwal_kosong.dart';

class CardView extends HookWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheduleBloc = context.read<ScheduleBloc>();

    useEffect(() {
      if (scheduleBloc.state.status != ScheduleStatus.success) {
        scheduleBloc.add(LoadListSchedule());
      }
      context.read<MatkulBloc>().add(LoadListMatkul());
      return null;
    }, []);

    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state.status == ScheduleStatus.loading ||
            state.status == ScheduleStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ScheduleStatus.error) {
          return Center(
            child: Text(state.message ?? "Error loading schedules"),
          );
        }

        if (state.status == ScheduleStatus.success) {
          final schedules = state.schedules;

          if (schedules.isEmpty) {
            return const JadwalKosong();
          }

          final List<Day> sortedDay = MatkulUtils.getListDayOfSchedule(
            schedules: schedules,
            sortByCurrentDay: true,
          );

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 5,
              right: 5,
              left: 5,
              bottom: 60,
            ),
            itemCount: sortedDay.length,
            itemBuilder: (context, index) {
              final scheduleDay = sortedDay[index];
              final scheduleListPerDay = schedules
                  .where((schedule) => schedule.day == scheduleDay)
                  .toList();
              return Card(
                elevation: 0,
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                      ),
                      child: Text(
                        scheduleDay.label,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Container(
                      color: theme.colorScheme.surfaceContainer,
                      child: BlocBuilder<MatkulBloc, MatkulState>(
                        builder: (context, matkulState) {
                          if (matkulState.status == MatkulStatus.success) {
                            final matkuls = matkulState.matkuls;
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: scheduleListPerDay.length,
                              separatorBuilder: (context, index) =>
                                  Container(height: 3),
                              itemBuilder: (context, index) {
                                final schedule = scheduleListPerDay[index];
                                final matkul = matkuls.firstWhere(
                                  (element) => element.id == schedule.matkulId,
                                  orElse: () => matkuls.first,
                                );

                                return MatkulCard(
                                  schedule: schedule,
                                  matkul: matkul,
                                );
                              },
                            );
                          }
                          return const Center(child: LinearProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const Center(child: Text("Memuat data..."));
      },
    );
  }
}
