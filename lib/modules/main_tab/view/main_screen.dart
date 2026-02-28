import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/core/theme/theme.dart';
import 'package:jaku/core/theme/theme_cubit.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_state.dart';
import 'package:jaku/modules/note/view/note_dashboard.dart';
import 'package:jaku/modules/schedule/view/schedule_dashboard.dart';
import 'package:jaku/modules/task/view/task_dashboard.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeDark = AppTheme.dark;
    final themeLight = AppTheme.light;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isLight = themeMode == ThemeMode.light;
        final theme = isLight ? themeLight : themeDark;

        return BlocBuilder<MainTabBloc, MainTabState>(
          builder: (context, state) {
            return PersistentTabView(
              stateManagement: false,
              controller: context.read<MainTabBloc>().mainTabController,
              tabs: [
                PersistentTabConfig(
                  screen: const ScheduleDashboard(),
                  item: ItemConfig(
                    activeForegroundColor: theme.colorScheme.onPrimary,
                    activeColorSecondary: theme.colorScheme.primary,
                    icon: const Icon(LucideIcons.calendarRange),
                    title: "Schedule",
                  ),
                ),
                PersistentTabConfig(
                  screen: const NoteDashboard(),
                  item: ItemConfig(
                    activeForegroundColor: theme.colorScheme.onPrimary,
                    activeColorSecondary: theme.colorScheme.primary,
                    icon: const Icon(LucideIcons.notebook),
                    title: "Note",
                  ),
                ),
                PersistentTabConfig(
                  screen: const TaskDashboard(),
                  item: ItemConfig(
                    activeForegroundColor: theme.colorScheme.onPrimary,
                    activeColorSecondary: theme.colorScheme.primary,
                    icon: const Icon(LucideIcons.listTodo),
                    title: "Task",
                  ),
                ),
              ],
              navBarBuilder: (navBarConfig) {
                final bgColor = theme.colorScheme.surface;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  color: bgColor,
                  child: Style8BottomNavBar(
                    navBarConfig: navBarConfig,
                    navBarDecoration: const NavBarDecoration(
                      color: Colors.transparent,
                    ),
                    height: 60,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
