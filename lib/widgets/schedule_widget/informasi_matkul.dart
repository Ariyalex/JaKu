import 'package:flutter/material.dart';
import 'package:jaku/models/jadwal.dart';

class InformasiMatkul extends StatelessWidget {
  const InformasiMatkul({super.key, required this.matkul});
  final Matkul matkul;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(color: theme.colorScheme.secondary),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Column(
            children: [
              Text(matkul.matkul),
              matkul.kelas != null
                  ? Text(matkul.kelas!)
                  : const SizedBox.shrink(),
            ],
          )),
          Column(
            children: [
              matkul.dosen1!.isNotEmpty
                  ? Text(
                      matkul.dosen1!,
                    )
                  : Text("Dosen belum ditambahkan"),
              matkul.dosen2!.isNotEmpty
                  ? Text(
                      matkul.dosen2!,
                    )
                  : SizedBox.shrink(),
            ],
          )
        ],
      ),
    );
  }
}
