import 'package:flutter/material.dart';

class DrawerGuide extends StatelessWidget {
  const DrawerGuide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  "Info Aplikasi",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Pelajari cara menggunakan aplikasi. Cara hapus Matkul, persyaratan data, recovery password, dll.",
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
              padding: const EdgeInsets.all(16),
              children: const [
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text("Add Matkul"),
                  subtitle: Text(
                    "Gunakan tombol add di pojok kiri atas untuk membuka add page. Matkul harus beirisi:\nNama Matkul, Hari, dan Jam Awal",
                    textAlign: TextAlign.justify,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text("Add Otomatis"),
                  subtitle: Text(
                    "Fitur ini hanya diperuntukkan kepada mahasiswa UIN SUKA.\nFitur ini memerlukan file pdf jadwal kuliah yang didownload di SIA UIN SUKA.\nTombol ada pada di Add Matkul screen, di kanan atas disamping tombol save",
                    textAlign: TextAlign.justify,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit Matkul"),
                  subtitle: Text(
                    "Tekan matkul untuk memasuki Edit page, Matkul yang diedit harus berisi:\nNama Matkul, Hari, Jam awal.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete Matkul"),
                  subtitle: Text(
                    "Tekan tahan Matkul untuk menghapus Matkul, Matkul yang dihapus tidak dapat dipulihkan.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("Fitur"),
                  subtitle: Text(
                    "Matkul akan disortir sesuai Hari, Hari yang ditampilkan di paling atas merupakan Hari sekarang diikuti hari berikutnya",
                    textAlign: TextAlign.justify,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.password),
                  title: Text("Reset Password"),
                  subtitle: Text(
                    "Reset password dengan logOut terlebih dahulu, lalu pilih forgot password? dan masukkan Email yang terdaftar. Reset password akan dikirim ke email yang terdaftar",
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
