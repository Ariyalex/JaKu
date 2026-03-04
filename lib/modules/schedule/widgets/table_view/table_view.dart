import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
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
    useEffect(() {
      context.read<ScheduleBloc>().add(LoadListSchedule());
      context.read<MatkulBloc>().add(LoadListMatkul());
      return null;
    });

    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, scheduleState) {
        return BlocBuilder<MatkulBloc, MatkulState>(
          builder: (context, matkulState) {
            if (scheduleState is ScheduleListLoading ||
                matkulState is MatkulListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (scheduleState is ScheduleListLoaded &&
                matkulState is MatkulListLoaded) {
              final schedules = scheduleState.schedules;
              final matkuls = matkulState.matkuls;

              if (schedules.isEmpty) {
                return const JadwalKosong();
              }

              return tbl.Table(schedules: schedules, matkuls: matkuls);
            }

            if (scheduleState is ScheduleError) {
              return Center(child: Text(scheduleState.message));
            }

            if (matkulState is MatkulError) {
              return Center(child: Text(matkulState.message));
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
