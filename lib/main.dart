import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/core/client/hive_client.dart';
import 'package:jaku/core/di/app_providers.dart';
import 'package:jaku/core/di/dependency_injection.dart';
import 'package:jaku/core/routes/app_router.dart';
import 'package:jaku/core/utils/theme_mode_utils.dart';
import 'package:jaku/data/providers/local_settings_provider.dart';
import 'package:jaku/data/repositories/application_settings_repository.dart';
import 'package:jaku/data/repositories/task_tab_repository.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/notification/bloc/notification_bloc.dart';
import 'package:jaku/modules/notification/bloc/notification_event.dart';
import 'package:jaku/modules/notification/bloc/notification_state.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_bloc.dart';
import 'package:jaku/modules/main_tab/bloc/main_tab_event.dart';
import 'package:jaku/firebase_options.dart';
import 'package:jaku/modules/setting/bloc/setting_bloc.dart';
import 'package:jaku/modules/setting/bloc/setting_event.dart';
import 'package:jaku/modules/setting/bloc/setting_state.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:uuid/uuid.dart';
import 'core/theme/theme.dart';
import 'package:toastification/toastification.dart';

const uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise the time zone database
  tz.initializeTimeZones();

  await dotenv.load(fileName: ".env");

  await AndroidAlarmManager.initialize();

  // inisialisasi firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await DependencyInjection.init();

  // init hive
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await HiveClient().init();

  final settingProvider = LocalSettingsProvider();
  final settingRepo = ApplicationSettingsRepository(settingProvider);
  final settingBloc = SettingBloc(settingRepo);
  settingBloc.add(LoadSetting());

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
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => settingProvider),
        RepositoryProvider(create: (context) => settingRepo),
        ...AppProviders.repositoryProviders,
      ],
      child: MultiBlocProvider(
        providers: [
          ...AppProviders.blocProviders,
          BlocProvider(create: (context) => settingBloc),
          BlocProvider(create: (context) => notificationBloc),
          BlocProvider(
            create: (context) =>
                MainTabBloc(context.read<TaskTabRepository>())
                  ..add(LoadAllTaskTabs()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final matkulBloc = context.read<MatkulBloc>();

    useEffect(() {
      matkulBloc.add(LoadAllMatkul());
      matkulBloc.add(LoadActiveSemester());

      return null;
    }, []);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocSelector<SettingBloc, SettingState, ThemeMode>(
          selector: (state) =>
              ThemeModeUtils.stringToThemeMode(state.setting.themeMode),
          builder: (context, themeMode) {
            return BlocListener<NotificationBloc, NotificationState>(
              listener: (context, state) {
                if (state is NotificationLoaded && state.payload.isNotEmpty) {
                  context.read<MainTabBloc>().add(const ChangeTab(2));
                }
              },
              child: ToastificationWrapper(
                child: MaterialApp.router(
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeMode,
                  debugShowCheckedModeBanner: false,
                  routerConfig: AppRouter.router,
                  builder: (context, child) {
                    return child!;
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
