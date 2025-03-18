import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jaku/firebase_options.dart';
import 'package:jaku/provider/auth.dart';
import 'package:jaku/screens/auth_page.dart';
import 'package:jaku/screens/detail_matkul.dart';
import 'package:jaku/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../provider/hari_kuliah.dart';
import '../provider/jadwal_kuliah.dart';
import '../screens/add_matkul.dart';
// import './screens/auth_page.dart';
import './theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()..checkLoginStatus()),
        ChangeNotifierProvider(
          create: (context) => JadwalKuliahDay(),
        ),
        ChangeNotifierProxyProvider<Auth, Jadwalkuliah>(
          create: (context) => Jadwalkuliah(),
          update: (context, auth, jadwalKuliah) {
            if (auth.isLoggedIn) {
              jadwalKuliah ??= Jadwalkuliah();
              jadwalKuliah.updateAuthData(auth.user);
              jadwalKuliah.getOnce().then(
                (value) {
                  Provider.of<JadwalKuliahDay>(context, listen: false)
                      .groupByDay(jadwalKuliah!);
                },
              );
            } else {
              jadwalKuliah?.clearData();
              jadwalKuliah?.cancelSubscription();
            }
            return jadwalKuliah ?? Jadwalkuliah();
          },
        )
      ],
      builder: (context, child) =>
          Consumer<Auth>(builder: (context, auth, child) {
        return MaterialApp(
          theme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          home: auth.isLoggedIn ? HomeScreen() : LoginScreen(),
          routes: {
            AddMatkul.routeName: (context) => const AddMatkul(),
            DetailMatkul.routeName: (context) => const DetailMatkul(),
            HomeScreen.routeName: (context) => HomeScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
          },
        );
      }),
    );
  }
}
