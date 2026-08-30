import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/modules/note/widgets/sort_tile_widget.dart';

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
                'Urutkan Berdasarkan',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Divider(),
            BlocBuilder<NoteBloc, NoteState>(
              builder: (context, state) {
                // Sekarang index 0 adalah Modified/Updated, index 1 adalah Created
                int activeIndex = state.sortActiveIndex;
                bool isAsce = state.isAsce;

                void updateSort(
                  int newActiveIndex,
                  bool newIsAsce,
                  bool newIsSortByCreated,
                ) {
                  context.read<NoteBloc>().add(
                    SortNotes(
                      activeIndex: newActiveIndex,
                      isAsce: newIsAsce,
                      isSorting:
                          true, // Karena 'None' sudah dihapus, isSorting selalu true
                      isSortByCreatedDate: newIsSortByCreated,
                    ),
                  );
                }

                return Column(
                  children: [
                    // Index 0: Sort by Modified/Updated Date
                    SortTileWidget(
                      isActive: activeIndex == 0,
                      title: "Tanggal Diubah",
                      onTap: () {
                        bool newIsAsce = (activeIndex != 0) ? true : !isAsce;
                        updateSort(0, newIsAsce, false);
                      },
                      isAsce: isAsce,
                    ),
                    // Index 1: Sort by Created Date
                    SortTileWidget(
                      isActive: activeIndex == 1,
                      title: "Tanggal Dibuat",
                      onTap: () {
                        bool newIsAsce = (activeIndex != 1) ? true : !isAsce;
                        updateSort(1, newIsAsce, true);
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
