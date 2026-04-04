import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainScreenDrawerWidget extends StatelessWidget {
  const MainScreenDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Text(
              'JaKu',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(LucideIcons.library),
            title: Text("Organisir Matkul"),
            subtitle: BlocSelector<MatkulBloc, MatkulState, int>(
              selector: (state) {
                return state.activeSemester;
              },
              builder: (context, value) {
                return Text(
                  value > 0 ? "Semester $value" : "Semester tidak organisir",
                );
              },
            ),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(RouteNamed.matkulDashboard);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text("Pengaturan"),
          ),
          ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text("About"),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(RouteNamed.guideGeneral);
            },
          ),
        ],
      ),
    );
  }
}
