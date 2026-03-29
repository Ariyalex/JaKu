import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';
import 'package:jaku/modules/schedule/widgets/jadwal_kosong.dart';
import 'package:jaku/modules/schedule/widgets/table_view/table.dart' as tbl;

class TableView extends HookWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleBloc = context.read<ScheduleBloc>();

    return BlocListener<MatkulBloc, MatkulState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == MatkulStatus.success,
      listener: (context, state) {
        scheduleBloc.add(LoadListSchedule(state.activeMatkuls));
      },
      child: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, scheduleState) {
          return BlocBuilder<MatkulBloc, MatkulState>(
            builder: (context, matkulState) {
              if (scheduleState.status == ScheduleStatus.loading ||
                  matkulState.status == MatkulStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (scheduleState.status == ScheduleStatus.success &&
                  matkulState.status == MatkulStatus.success) {
                final schedules = scheduleState.schedules;
                final matkuls = matkulState.activeMatkuls;

                if (schedules.isEmpty) {
                  return const JadwalKosong();
                }

                return tbl.Table(schedules: schedules, matkuls: matkuls);
              }

              if (scheduleState.status == ScheduleStatus.error) {
                return Center(child: Text(scheduleState.message ?? "Error"));
              }

              if (matkulState.status == MatkulStatus.error) {
                return Center(child: Text(matkulState.message ?? "Error"));
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
