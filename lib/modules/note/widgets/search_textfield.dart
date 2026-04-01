import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/modules/note/widgets/filter_note_modal.dart';
import 'package:jaku/modules/note/widgets/sort_note_modal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchTextfield extends HookWidget {
  const SearchTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteBloc = context.read<NoteBloc>();
    final focusNode = useFocusNode();
    final searchController = useTextEditingController();

    // Track focus state to trigger rebuilds
    useListenable(focusNode);
    useListenable(searchController);

    final isFocused = focusNode.hasFocus;
    final isNotEmpty = searchController.text.trim().isNotEmpty;

    return TextField(
      focusNode: focusNode,
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Cari catatan',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Builder(
          builder: (context) {
            if (isNotEmpty && isFocused) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  noteBloc.add(const SearchNotes(''));
                },
              );
            }
            if (!isNotEmpty && !isFocused) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<NoteBloc, NoteState>(
                      builder: (context, state) {
                        bool isAsce = state.isAsce;

                        return IconButton(
                          icon: Icon(
                            isAsce
                                ? LucideIcons.arrowUp
                                : LucideIcons.arrowDown,
                          ),

                          onPressed: () {
                            showBarModalBottomSheet<void>(
                              barrierColor: Colors.black.withValues(alpha: 0.4),
                              context: context,
                              useRootNavigator: true,
                              bounce: true,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainer,
                              builder: (context) => const SortNoteModal(),
                            );
                          },
                        );
                      },
                    ),
                    BlocBuilder<NoteBloc, NoteState>(
                      builder: (context, state) {
                        bool isFiltering = state.filterMatkulId != 'all';

                        if (isFiltering) {
                          return RawMaterialButton(
                            onPressed: () {
                              showBarModalBottomSheet<void>(
                                barrierColor: Colors.black.withValues(
                                  alpha: 0.4,
                                ),
                                context: context,
                                useRootNavigator: true,
                                bounce: true,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainer,
                                builder: (context) => const FilterNoteModal(),
                              );
                            },
                            fillColor: theme.colorScheme.tertiary,
                            shape: const CircleBorder(),
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            elevation: 0,
                            child: Badge(
                              smallSize: 8,
                              alignment: Alignment.topRight,
                              child: Icon(
                                LucideIcons.funnel,
                                color: theme.colorScheme.onTertiary,
                              ),
                            ),
                          );
                        }
                        return IconButton(
                          icon: const Icon(LucideIcons.funnel),
                          onPressed: () {
                            showBarModalBottomSheet<void>(
                              barrierColor: Colors.black.withValues(alpha: 0.4),
                              context: context,
                              useRootNavigator: true,
                              bounce: true,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainer,
                              builder: (context) => const FilterNoteModal(),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            if (isNotEmpty && !isFocused) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        noteBloc.add(const SearchNotes(''));
                      },
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.arrowDownUp),
                      onPressed: () {
                        showBarModalBottomSheet<void>(
                          barrierColor: Colors.black.withValues(alpha: 0.4),
                          context: context,
                          useRootNavigator: true,
                          bounce: true,
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          builder: (context) => const SortNoteModal(),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.funnel),
                      onPressed: () {
                        showBarModalBottomSheet<void>(
                          barrierColor: Colors.black.withValues(alpha: 0.4),
                          context: context,
                          useRootNavigator: true,
                          bounce: true,
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          builder: (context) => const FilterNoteModal(),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
      onChanged: (value) {
        noteBloc.add(SearchNotes(value));
      },
    );
  }
}
