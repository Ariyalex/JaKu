import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/core/widgets/sort_tile.dart';

class SortNoteModal extends StatelessWidget {
  const SortNoteModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Sorting',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Divider(),
            BlocBuilder<NoteBloc, NoteState>(
              builder: (context, state) {
                int activeIndex = state.sortActiveIndex;
                bool isAsce = state.isAsce;
                bool isSortByCreated = state.isSortByCreatedDate;

                void updateSort(int newActiveIndex, bool newIsAsce, bool newIsSorting, bool newIsSortByCreated) {
                  context.read<NoteBloc>().add(SortNotes(
                    activeIndex: newActiveIndex,
                    isAsce: newIsAsce,
                    isSorting: newIsSorting,
                    isSortByCreatedDate: newIsSortByCreated,
                  ));
                }

                return Column(
                  children: [
                    SortTile(
                      isActive: activeIndex == 0,
                      title: 'None',
                      isSortable: false,
                      onTap: () {
                        updateSort(0, isAsce, false, isSortByCreated);
                      },
                    ),
                    SortTile(
                      isActive: activeIndex == 1,
                      title: "Sort by Created Date",
                      onTap: () {
                        bool newIsAsce = isAsce;
                        if (activeIndex != 1) {
                          newIsAsce = true;
                        } else {
                          newIsAsce = !isAsce;
                        }
                        updateSort(1, newIsAsce, true, true);
                      },
                      isAsce: isAsce,
                    ),
                    SortTile(
                      isActive: activeIndex == 2,
                      title: "Sort by Modified Date",
                      onTap: () {
                        bool newIsAsce = isAsce;
                        if (activeIndex != 2) {
                          newIsAsce = true;
                        } else {
                          newIsAsce = !isAsce;
                        }
                        updateSort(2, newIsAsce, true, false);
                      },
                      isAsce: isAsce,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
