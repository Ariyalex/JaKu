import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jaku/controllers/theme_c.dart';
import 'package:jaku/firebase_options.dart';
import 'package:jaku/screens/note/note_dashboard.dart';
import 'package:jaku/screens/tesk/task_dashboard.dart';
import 'package:jaku/services/jadwal_service.dart';
import 'package:jaku/controllers/version_control.dart';
import 'package:jaku/routes/page_route.dart';
import 'package:jaku/screens/schedule/schedule_dashboard.dart';
import 'package:jaku/services/note_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import './theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //inisialisasi firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //inisialisasi hive
  await Hive.initFlutter();
  await JadwalService.initMatkulService();
  await NoteService.initNoteService();
  // Hive.registerAdapter(TaskAdapter());

  // Inisialisasi controller tanpa menyimpan ke variabel lokal

  Get.put(VersionControl());

  //init theme
  await Hive.openBox('settings');
  final themeC = Get.put(ThemeC(), permanent: true);
  themeC.initTheme();

  // Pastikan data login dimuat sebelum menampilkan UI

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeDark = AppTheme.dark;
    final themeLight = AppTheme.light;
    final themeC = Get.find<ThemeC>();

    return GetX<ThemeC>(
      builder: (controller) => GetMaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeC.themeMode,
        debugShowCheckedModeBanner: false,
        home: Obx(
          () => PersistentTabView(
            stateManagement: false,
            tabs: [
              PersistentTabConfig(
                screen: ScheduleDashboard(),

                item: ItemConfig(
                  activeForegroundColor: themeC.isLight.value
                      ? themeLight.colorScheme.onPrimary
                      : themeDark.colorScheme.onPrimary,
                  activeColorSecondary: themeC.isLight.value
                      ? themeLight.colorScheme.primary
                      : themeDark.colorScheme.primary,
                  icon: Icon(LucideIcons.calendarRange),
                  title: "Schedule",
                ),
              ),
              PersistentTabConfig(
                screen: NoteDashboard(),
                item: ItemConfig(
                  activeForegroundColor: themeC.isLight.value
                      ? themeLight.colorScheme.onPrimary
                      : themeDark.colorScheme.onPrimary,
                  activeColorSecondary: themeC.isLight.value
                      ? themeLight.colorScheme.primary
                      : themeDark.colorScheme.primary,
                  icon: Icon(LucideIcons.notebook),
                  title: "Note",
                ),
              ),
              PersistentTabConfig(
                screen: TaskDashboard(),
                item: ItemConfig(
                  activeForegroundColor: themeC.isLight.value
                      ? themeLight.colorScheme.onPrimary
                      : themeDark.colorScheme.onPrimary,
                  activeColorSecondary: themeC.isLight.value
                      ? themeLight.colorScheme.primary
                      : themeDark.colorScheme.primary,
                  icon: Icon(LucideIcons.listTodo),
                  title: "Task",
                ),
              ),
            ],
            navBarBuilder: (navBarConfig) => Obx(
              () => Style8BottomNavBar(
                navBarConfig: navBarConfig,
                navBarDecoration: NavBarDecoration(
                  color: themeC.isLight.value
                      ? themeLight.colorScheme.surface
                      : themeDark.colorScheme.surface,
                ),
                height: 60,
              ),
            ),
          ),
        ),
        getPages: AppPage.pages,
      ),
    );
  }
}
