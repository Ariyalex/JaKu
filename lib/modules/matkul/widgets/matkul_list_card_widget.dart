import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/matkul/bloc/matkul_selection_cubit.dart';
import 'package:jaku/modules/matkul/bloc/matkul_selection_state.dart';

class MatkulListCardWidget extends StatelessWidget {
  const MatkulListCardWidget({
    super.key,
    required this.matkuls,
    required this.matkulSelectionCubit,
    required this.matkulSelectionState,
  });

  final MatkulSelectionCubit matkulSelectionCubit;
  final MatkulSelectionState matkulSelectionState;
  final List<Matkul> matkuls;

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
          final isSelected = matkulSelectionState.selectedMatkulIds.contains(
            matkul.id,
          );

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onLongPress: () {
              if (!matkulSelectionState.isSelectionMode) {
                matkulSelectionCubit.setSelectionMode(true);
                matkulSelectionCubit.toggleSelection(matkul.id);
              }
            },

            onTap: () {
              if (matkulSelectionState.isSelectionMode) {
                matkulSelectionCubit.toggleSelection(matkul.id);
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
              child: Column(
                spacing: 8,
                children: [
                  Text(
                    matkul.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    spacing: 4,
                    children: [
                      if (matkul.lecturer1 != null && matkul.lecturer1 != "")
                        Row(
                          spacing: 6,
                          children: [
                            Icon(Icons.person),
                            Expanded(child: Text(matkul.lecturer1!)),
                          ],
                        ),
                      if (matkul.lecturer2 != null && matkul.lecturer2 != "")
                        Row(
                          spacing: 6,
                          children: [
                            Icon(Icons.person),
                            Expanded(child: Text(matkul.lecturer2!)),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
