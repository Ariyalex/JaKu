import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/theme/theme_cubit.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_selection_cubit.dart';
import 'package:jaku/modules/schedule/bloc/schedule_view_cubit.dart';
import 'package:jaku/modules/schedule/widgets/card_view/card_view.dart';
import 'package:jaku/modules/schedule/widgets/schedule_dialogs.dart';
import 'package:jaku/modules/schedule/widgets/table_view/table_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/routes/route_named.dart';

class ScheduleDashboard extends HookWidget {
  const ScheduleDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final fabKey = useMemoized(() => GlobalKey<ExpandableFabState>());

    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    final themeC = context.read<ThemeCubit>();
    final scheduleBloc = context.read<ScheduleBloc>();
    final scheduleSelectionCubit = context.read<ScheduleSelectionCubit>();
    final scheduleSelectionState = context
        .watch<ScheduleSelectionCubit>()
        .state;
    final isCardView = context.watch<ScheduleViewCubit>().state;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      key: scaffoldKey,
      appBar: scheduleSelectionState.isSelectionMode
          ? AppBar(
              leading: IconButton(
                onPressed: scheduleSelectionCubit.clearSelection,
                icon: Icon(LucideIcons.x),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await ScheduleDialogs.showDeleteSchedules(context, () {
                      scheduleBloc.add(
                        DeleteSchedules(
                          scheduleSelectionState.selectedScheduleIds.toList(),
                        ),
                      );
                      scheduleSelectionCubit.clearSelection();

                      context.pop();
                    });
                  },

                  icon: Icon(LucideIcons.trash2, color: Colors.red),
                ),
              ],
            )
          : AppBar(
              title: const Text("Jaku"),
              leading: Builder(
                builder: (context) => PopupMenuButton<String>(
                  icon: const Icon(Icons.menu),
                  onSelected: (value) {
                    if (value == "info") {
                      context.pushNamed(RouteNamed.guideGeneral);
                    }
                  },
                  position: PopupMenuPosition.under,
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: "info",
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text("Info"),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () =>
                      context.read<ScheduleViewCubit>().toggleView(),
                  label: isCardView
                      ? Text(
                          "Card view",
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorTheme.primary,
                          ),
                        )
                      : Text(
                          "Table view",
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorTheme.onPrimary,
                          ),
                        ),
                  icon: isCardView
                      ? const Icon(Icons.view_agenda_outlined)
                      : const Icon(Icons.table_chart),
                  style: ButtonStyle(
                    backgroundColor: isCardView
                        ? null
                        : WidgetStatePropertyAll(colorTheme.primary),
                    iconColor: isCardView
                        ? null
                        : WidgetStatePropertyAll(colorTheme.onPrimary),
                    side: WidgetStatePropertyAll(
                      BorderSide(width: 1, color: colorTheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () => themeC.toggleTheme(),
                  icon: const Icon(Icons.color_lens),
                ),
              ],
            ),
      body: SafeArea(
        child: isCardView
            ? CardView(
                scheduleSelectionCubit: scheduleSelectionCubit,
                scheduleSelectionState: scheduleSelectionState,
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const TableView(),
              ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: fabKey,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(LucideIcons.plus),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
          angle: math.pi / 4,
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          child: Transform.rotate(
            angle: math.pi / 4,
            child: const Icon(LucideIcons.plus),
          ),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
        ),
        type: ExpandableFabType.up,
        duration: const Duration(milliseconds: 340),
        childrenAnimation: ExpandableFabAnimation.none,
        distance: 70,
        overlayStyle: ExpandableFabOverlayStyle(
          color: colorTheme.surface.withValues(alpha: 0.7),
        ),
        children: [
          Row(
            children: [
              Text('PDF to Schedule', style: textTheme.bodyLarge),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  fabKey.currentState?.close();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        "Peringatan!!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: theme.dialogTheme.backgroundColor,
                      content: const Text(
                        "Fitur ini hanya untuk\nmahasiswa UIN SUKA.\nAdd matkul menggunakan file PDF yang didapat dari SIA UIN SUKA",
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Ga jadi"),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.pushNamed(RouteNamed.pdfParsing);
                          },
                          child: const Text("Ok Bang"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(LucideIcons.filePlusCorner),
              ),
            ],
          ),
          Row(
            children: [
              Text('Add Schedule', style: textTheme.bodyLarge),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  fabKey.currentState?.close();
                  context.pushNamed(RouteNamed.addSchedule);
                },
                child: const Icon(LucideIcons.plus),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
