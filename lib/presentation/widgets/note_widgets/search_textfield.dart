import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/presentation/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/presentation/widgets/note_widgets/filter_note_modal.dart';
import 'package:jaku/presentation/widgets/note_widgets/sort_note_modal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({super.key});

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  final FocusNode _focusNode = FocusNode();
  final noteC = Get.find<NoteControllers>();
  late TextEditingController searchController;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    searchController = noteC.searchC;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteC = Get.find<NoteControllers>();

    bool isNotEmpty = searchController.text.trim().isNotEmpty;
    return TextField(
      focusNode: _focusNode,
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Cari catatan',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Builder(
          builder: (context) {
            // 1. Jika controller not empty & focused: clear
            if (isNotEmpty && _isFocused) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  noteC.searchNotes();
                  setState(() {});
                },
              );
            }
            // 2. Jika controller empty & not focused: sort + filter
            if (!isNotEmpty && !_isFocused) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      final isAsce = noteC.isAsce.value;
                      final isSorting = noteC.isSorting.value;

                      return IconButton(
                        icon: Icon(
                          !isSorting
                              ? LucideIcons.arrowDownUp
                              : (isAsce
                                    ? LucideIcons.arrowUp
                                    : LucideIcons.arrowDown),
                        ),
                        onPressed: () {
                          showBarModalBottomSheet<Map<String, dynamic>>(
                            barrierColor: Colors.black.withValues(alpha: 0.4),
                            context: context,
                            useRootNavigator: true,
                            bounce: true,
                            backgroundColor: theme.colorScheme.surfaceContainer,
                            builder: (context) => const SortNoteModal(),
                          );
                        },
                      );
                    }),

                    Obx(() {
                      final isFiltering = noteC.filterMatkulId.value != "all";

                      if (isFiltering) {
                        return RawMaterialButton(
                          onPressed: () {
                            showBarModalBottomSheet<Map<String, dynamic>>(
                              barrierColor: Colors.black.withValues(alpha: 0.4),
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
                          showBarModalBottomSheet<Map<String, dynamic>>(
                            barrierColor: Colors.black.withValues(alpha: 0.4),
                            context: context,
                            useRootNavigator: true,
                            bounce: true,
                            backgroundColor: theme.colorScheme.surfaceContainer,
                            builder: (context) => const FilterNoteModal(),
                          );
                        },
                      );
                    }),
                  ],
                ),
              );
            }
            // 3. Jika controller not empty & not focused: clear + sort + filter
            if (isNotEmpty && !_isFocused) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        print("clearing search");
                        searchController.clear();
                        noteC.searchNotes();
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.arrowDownUp),
                      onPressed: () {
                        showBarModalBottomSheet<Map<String, dynamic>>(
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
                        showBarModalBottomSheet<Map<String, dynamic>>(
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
            // 4. Jika controller empty & focused: tidak ada tombol
            return const SizedBox.shrink();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
      onChanged: (_) {
        noteC.onNoteSearch();
        setState(() {});
      },
    );
  }
}
