import 'package:flutter/material.dart';
import 'package:jaku/widgets/note_widgets/filter_note_modal.dart';
import 'package:jaku/widgets/note_widgets/sort_note_modal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({super.key});

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  final FocusNode _focusNode = FocusNode();
  final searchController = TextEditingController();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
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

    bool isNotEmpty = searchController.text.trim().isNotEmpty;
    return TextField(
      focusNode: _focusNode,
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Cari catatan',
        prefixIcon: Icon(Icons.search),
        suffixIcon: Builder(
          builder: (context) {
            // 1. Jika controller not empty & focused: clear
            if (isNotEmpty && _isFocused) {
              return IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
              );
            }
            // 2. Jika controller empty & not focused: sort + filter
            if (!isNotEmpty && !_isFocused) {
              return Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(LucideIcons.arrowDownUp),
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
                      icon: Icon(LucideIcons.funnel),
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
            // 3. Jika controller not empty & not focused: clear + sort + filter
            if (isNotEmpty && !_isFocused) {
              return Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.arrowDownUp),
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
                      icon: Icon(LucideIcons.funnel),
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
            return SizedBox.shrink();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}
