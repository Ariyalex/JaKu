import 'package:flutter/material.dart';
import 'package:jaku/provider/auth.dart';
import 'package:jaku/screens/auth_page.dart';
import 'package:provider/provider.dart';

import '../provider/hari_kuliah.dart';
import '../provider/jadwal_kuliah.dart';
import '../screens/add_matkul.dart';
import '../widgets/day_card_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isInit = true;
  late Future<void> _futureMatkul;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final jadwalProvider = Provider.of<Jadwalkuliah>(context, listen: false);
      final jadwalHariProvider =
          Provider.of<JadwalKuliahDay>(context, listen: false);

      _futureMatkul = jadwalProvider.getOnce().then(
        (_) {
          jadwalHariProvider.groupByDay(jadwalProvider);
        },
      )..catchError(
          (err) {
            if (mounted) {
              print(err);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Error Occured"),
                    content: Text(err.toString()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Okay"),
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      isInit = false;
    }
    super.didChangeDependencies();
  }

  void _showInfoDialog(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }

  static void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("LogOut"),
        content: Text("Yakin LogOut dari account?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Tidak")),
          FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                var matkuls = Provider.of<Jadwalkuliah>(context, listen: false);
                var auth = Provider.of<Auth>(context, listen: false);
                // await Future.delayed(Duration(milliseconds: 100));

                await auth.signOut(matkuls);
                print("logout selesai");

                Future.delayed(
                  Duration.zero,
                  () {
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    }
                  },
                );
              },
              child: Text("Ya"))
        ],
      ),
    );
  }

  Drawer howTo = Drawer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF748BAC)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Panduan Aplikasi",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Pelajari cara menggunakan aplikasi. cara hapus Matkul, persyaratan data, recovery password, dll.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: const [
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Add Matkul"),
                subtitle: Text(
                    "Gunakan tombol add di pojok kiri atas untuk membuka add page. Matkul harus beirisi:\nNama Matkul, Hari, dan Jam Awal"),
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit Matkul"),
                subtitle: Text(
                    "Tekan matkul untuk memasuki Edit page, Matkul yang diedit harus berisi:\nNama Matkul, Hari, Jam awal."),
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete Matkul"),
                subtitle: Text(
                    "Tekan tahan Matkul untuk menghapus Matkul, Matkul yang dihapus tidak dapat dipulihkan."),
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Fitur"),
                subtitle: Text(
                    "Matkul akan disortir sesuai Hari, Hari yang ditampilkan di paling atas merupakan Hari sekarang diikuti hari berikutnya"),
              ),
              ListTile(
                leading: Icon(Icons.password),
                title: Text("Reset Password"),
                subtitle: Text(
                    "Reset password dengan logOut terlebih dahulu, lalu pilih forgot password? dan masukkan Email yang terdaftar. Reset password akan dikirim ke email yang terdaftar"),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final allMatkulProvider = Provider.of<Jadwalkuliah>(context);
    final jadwalKuliahDayProvider =
        Provider.of<JadwalKuliahDay>(context, listen: true);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Jaku"),
        leading: Builder(
          builder: (context) => PopupMenuButton<String>(
            icon: const Icon(Icons.menu), // Burger Icon
            onSelected: (value) {
              if (value == "info") {
                _showInfoDialog(context);
              } else if (value == "logout") {
                _logout(context);
              }
            },
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: "info",
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text("Guide"),
                ),
              ),
              const PopupMenuItem<String>(
                value: "logout",
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddMatkul.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: howTo,
      body: FutureBuilder(
        future: _futureMatkul,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (allMatkulProvider.allMatkul.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No Data",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddMatkul.routeName);
                    },
                    child: const Text(
                      "Add Matkul",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: DayCardBuilder(
                    jadwalKuliahDayProvider: jadwalKuliahDayProvider,
                    allMatkulProvider: allMatkulProvider,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
