import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/controllers/main_tab_controller.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
import 'package:jaku/controllers/notification_controller.dart';
import 'package:jaku/controllers/theme_c.dart';
import 'package:jaku/firebase_options.dart';
import 'package:jaku/screens/note/note_dashboard.dart';
import 'package:jaku/screens/task/task_dashboard.dart';
import 'package:jaku/services/jadwal_service.dart';
import 'package:jaku/controllers/version_control.dart';
import 'package:jaku/routes/page_route.dart';
import 'package:jaku/screens/schedule/schedule_dashboard.dart';
import 'package:jaku/services/matkul_service.dart';
import 'package:jaku/services/note_service.dart';
import 'package:jaku/services/task_service.dart';
import 'package:jaku/services/task_tab_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import './theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialise the time zone database
  tz.initializeTimeZones();

  //inisialisasi firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //inisialisasi hive
  await Hive.initFlutter();
  await JadwalService.initScheduleService();
  await NoteService.initNoteService();
  await MatkulService.iniMatkulService();
  await TaskService.initTaskService();
  await TaskTabService.initTaskTabService();

  // Inisialisasi controller tanpa menyimpan ke variabel lokal
  Get.put(MatkulController(), permanent: true);
  Get.put(VersionControl(), permanent: true);
  final notifC = Get.put(NotificationController(), permanent: true);
  Get.put(MainTabController(), permanent: true);

  //init theme
  await Hive.openBox('settings');
  final themeC = Get.put(ThemeC(), permanent: true);
  themeC.initTheme();

  //ambil data notif yang membuka aplikasi
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await notifC.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    notifC.payload.value =
        notificationAppLaunchDetails!.notificationResponse!.payload!;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeDark = AppTheme.dark;
    final themeLight = AppTheme.light;
    final themeC = Get.find<ThemeC>();
    final tabC = Get.find<MainTabController>();
    final notifC = Get.find<NotificationController>();

    if (notifC.payload.value.isNotEmpty) {
      print("payload ada isinya: ${notifC.payload.value}");
      Future.microtask(() {
        tabC.routing(2);
      });
    }

    return GetX<ThemeC>(
      builder: (controller) => GetMaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeC.themeMode,
        debugShowCheckedModeBanner: false,
        home: Obx(
          () => PersistentTabView(
            stateManagement: false,
            controller: tabC.mainTabController,
            tabs: [
              PersistentTabConfig(
                screen: const ScheduleDashboard(),

                item: ItemConfig(
                  activeForegroundColor: themeC.isLight.value
                      ? themeLight.colorScheme.onPrimary
                      : themeDark.colorScheme.onPrimary,
                  activeColorSecondary: themeC.isLight.value
                      ? themeLight.colorScheme.primary
                      : themeDark.colorScheme.primary,
                  icon: const Icon(LucideIcons.calendarRange),
                  title: "Schedule",
                ),
              ),
              PersistentTabConfig(
                screen: const NoteDashboard(),
                item: ItemConfig(
                  activeForegroundColor: themeC.isLight.value
                      ? themeLight.colorScheme.onPrimary
                      : themeDark.colorScheme.onPrimary,
                  activeColorSecondary: themeC.isLight.value
                      ? themeLight.colorScheme.primary
                      : themeDark.colorScheme.primary,
                  icon: const Icon(LucideIcons.notebook),
                  title: "Note",
                ),
              ),
              PersistentTabConfig(
                screen: const TaskDashboard(),
                item: ItemConfig(
                  activeForegroundColor: themeC.isLight.value
                      ? themeLight.colorScheme.onPrimary
                      : themeDark.colorScheme.onPrimary,
                  activeColorSecondary: themeC.isLight.value
                      ? themeLight.colorScheme.primary
                      : themeDark.colorScheme.primary,
                  icon: const Icon(LucideIcons.listTodo),
                  title: "Task",
                ),
              ),
            ],
            navBarBuilder: (navBarConfig) => Obx(() {
              final bgColor = themeC.isLight.value
                  ? themeLight.colorScheme.surface
                  : themeDark.colorScheme.surface;

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
            }),
          ),
        ),
        getPages: AppPage.pages,
      ),
    );
  }
}
