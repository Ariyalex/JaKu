import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MatkulListCardWidget extends StatelessWidget {
  const MatkulListCardWidget({
    super.key,
    required this.selectedMatkul,
    required this.isSelectionMode,
    required this.dummyMatkul,
    required this.toggleMatkul,
    required this.setSelectionMode,
  });

  final Set<int> selectedMatkul;
  final bool isSelectionMode;

  //TODO: change data type and name
  final List<String> dummyMatkul;

  final ValueChanged<int> toggleMatkul;
  final ValueChanged<bool> setSelectionMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: MasonryGridView.builder(
        shrinkWrap: true,
        itemCount: dummyMatkul.length,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemBuilder: (context, index) {
          final isSelected = selectedMatkul.contains(index);

          return InkWell(
            onLongPress: () {
              if (!isSelectionMode) {
                setSelectionMode(true);
                toggleMatkul(index);
              }
            },

            onTap: () {
              if (isSelectionMode) {
                toggleMatkul(index);
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
                dummyMatkul[index],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
