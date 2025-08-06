import 'package:flutter/material.dart';
import 'package:jaku/widgets/note_widgets/filter_note_modal.dart';
import 'package:jaku/widgets/note_widgets/sort_note_modal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({
    super.key,
  });

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  final FocusNode _focusNode = FocusNode();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Cari catatan',
        prefixIcon: Icon(Icons.search),
        suffixIcon: !_isFocused
            ? Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(LucideIcons.arrowDownUp),
                      onPressed: () {
                        // TODO: aksi filter
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
                        // TODO: aksi filter
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
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
    );
  }
}
