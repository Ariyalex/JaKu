import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/matkul/bloc/matkul_selection_cubit.dart';
import 'package:jaku/modules/matkul/bloc/matkul_selection_state.dart';

class MatkulCardWidget extends StatelessWidget {
  final Matkul matkul;

  const MatkulCardWidget({super.key, required this.matkul});

  @override
  Widget build(BuildContext context) {
    final matkulSelectionCubit = context.read<MatkulSelectionCubit>();
    final theme = Theme.of(context);
    return BlocSelector<
      MatkulSelectionCubit,
      MatkulSelectionState,
      ({bool mode, bool isSelected})
    >(
      selector: (state) {
        return (
          mode: state.isSelectionMode,
          isSelected: state.selectedMatkulIds.contains(matkul.id),
        );
      },
      builder: (context, value) {
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onLongPress: () {
            if (!value.mode) {
              matkulSelectionCubit.setSelectionMode(true);
              matkulSelectionCubit.toggleSelection(matkul.id);
            }
          },

          onTap: () {
            if (value.mode) {
              matkulSelectionCubit.toggleSelection(matkul.id);
            } else {
              context.pushNamed(
                RouteNamed.editMatkul,
                pathParameters: {"id": matkul.id},
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
              color: value.isSelected
                  ? theme.cardTheme.color
                  : theme.highlightColor,
              borderRadius: BorderRadius.circular(6),
              border: BoxBorder.all(
                width: 2,
                color: value.isSelected
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
    );
  }
}
