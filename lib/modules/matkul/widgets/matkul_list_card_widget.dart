import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/matkul/widgets/matkul_card_widget.dart';

class MatkulListCardWidget extends StatelessWidget {
  const MatkulListCardWidget({super.key, required this.matkuls});

  final List<Matkul> matkuls;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: MasonryGridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: matkuls.length,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemBuilder: (context, index) {
          final matkul = matkuls[index];

          return MatkulCardWidget(matkul: matkul);
        },
      ),
    );
  }
}
