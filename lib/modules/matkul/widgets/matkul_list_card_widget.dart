import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/data/entities/matkul.dart';

class MatkulListCardWidget extends StatelessWidget {
  const MatkulListCardWidget({
    super.key,
    required this.selectedMatkul,
    required this.isSelectionMode,
    required this.matkuls,
    required this.toggleMatkul,
    required this.setSelectionMode,
  });

  final Set<String> selectedMatkul;
  final bool isSelectionMode;

  final List<Matkul> matkuls;

  final ValueChanged<String> toggleMatkul;
  final ValueChanged<bool> setSelectionMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          final isSelected = selectedMatkul.contains(matkul.id);

          return InkWell(
            onLongPress: () {
              if (!isSelectionMode) {
                setSelectionMode(true);
                toggleMatkul(matkul.id);
              }
            },

            onTap: () {
              if (isSelectionMode) {
                toggleMatkul(matkul.id);
              } else {
                context.pushNamed(
                  RouteNamed.editMatkul,
                  pathParameters: {"id": matkul.id},
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.cardTheme.color
                    : theme.highlightColor,
                borderRadius: BorderRadius.circular(6),
                border: BoxBorder.all(
                  width: 2,
                  color: isSelected
                      ? theme.colorScheme.tertiary
                      : Colors.transparent,
                ),
              ),
              child: Text(
                matkul.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
