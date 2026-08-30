import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

class SearchTextfield extends HookWidget {
  const SearchTextfield({
    super.key,
    required this.searchController,
    required this.focusNode,
  });
  final TextEditingController searchController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final noteBloc = context.read<NoteBloc>();

    return KeyboardDetection(
      controller: KeyboardDetectionController(
        onChanged: (state) {
          if (state == KeyboardState.hidden && focusNode.hasFocus) {
            focusNode.unfocus();
          }
        },
      ),
      child: TextField(
        focusNode: focusNode,
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Cari catatan',
          prefixIcon: const Icon(Icons.search),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        onChanged: (value) {
          noteBloc.add(SearchNotes(value));
        },
      ),
    );
  }
}
