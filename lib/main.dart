import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/core/di/app_providers.dart';
import 'package:jaku/core/di/dependency_injection.dart';
import 'package:jaku/core/theme/theme_cubit.dart';
import 'package:jaku/modules/notification/bloc/notification_bloc.dart';
import 'package:jaku/modules/notification/bloc/notification_event.dart';
import 'package:jaku/modules/notification/bloc/notification_state.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_event.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_state.dart';
import 'package:jaku/firebase_options.dart';
import 'package:jaku/modules/note/view/note_dashboard.dart';
import 'package:jaku/modules/schedule/view/schedule_dashboard.dart';
import 'package:jaku/modules/task/view/task_dashboard.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise the time zone database
  tz.initializeTimeZones();

  // inisialisasi firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await DependencyInjection.init();

  // init hive
  await Hive.initFlutter();
  await Hive.openBox('settings');

  final notificationBloc = NotificationBloc();
  notificationBloc.add(NotificationInitialize());

  // ambil data notif yang membuka aplikasi
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await notificationBloc.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final payload =
        notificationAppLaunchDetails!.notificationResponse?.payload ?? "";
    if (payload.isNotEmpty) {
      notificationBloc.add(SetNotificationPayload(payload));
    }
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()..initTheme()),
        BlocProvider(create: (context) => notificationBloc),
        BlocProvider(
          create: (context) => MainTabBloc()..add(LoadAllTaskTabs()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeDark = AppTheme.dark;
    final themeLight = AppTheme.light;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationLoaded && state.payload.isNotEmpty) {
              print("payload ada isinya: ${state.payload}");
              // Jump to Task tab (index 2)
              context.read<MainTabBloc>().add(const ChangeTab(2));
            }
          },
          child: MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            home: MultiRepositoryProvider(
              providers: [
                ...AppProviders.matkulRepositoryProviders,
                ...AppProviders.scheduleRepositoryProviders,
                ...AppProviders.noteRepositoryProviders,
                ...AppProviders.taskRepositoryProviders,
              ],
              child: const MainScreen(),
            ),
          ),
        );
      },
    );
  }
}

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
