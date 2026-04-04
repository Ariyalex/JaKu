import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/schedule/bloc/schedule_view_cubit.dart';
import 'package:jaku/modules/schedule/widgets/card_view/card_view.dart';
import 'package:jaku/modules/schedule/widgets/main_screen_drawer_widget.dart';
import 'package:jaku/modules/schedule/widgets/schedule_app_bar.dart';
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

    final isCardView = context.watch<ScheduleViewCubit>().state;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      key: scaffoldKey,
      appBar: ScheduleAppBar(),
      drawer: MainScreenDrawerWidget(),
      body: SafeArea(
        child: isCardView
            ? CardView()
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
