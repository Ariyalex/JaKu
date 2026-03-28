import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_event.dart';
import 'package:jaku/data/entities/matkul.dart';

class FilterNoteModal extends StatefulWidget {
  const FilterNoteModal({super.key});

  @override
  State<FilterNoteModal> createState() => _FilterNoteModalState();
}

class _FilterNoteModalState extends State<FilterNoteModal> {
  Set<String> _selectedMatkuls = {};

  @override
  void initState() {
    super.initState();
    final noteBloc = context.read<NoteBloc>();
    final state = noteBloc.state;
    String current = state.filterMatkulId;

    if (current.isEmpty || current == 'all') {
      _selectedMatkuls = {'all'};
    } else {
      _selectedMatkuls = current
          .split(',')
          .map((e) => e.trim())
          .where((element) => element.isNotEmpty)
          .toSet();
      if (_selectedMatkuls.isEmpty) _selectedMatkuls = {'all'};
    }

    // Ensure matkul is loaded
    final matkulBloc = context.read<MatkulBloc>();
    if (matkulBloc.state.status == MatkulStatus.initial) {
      matkulBloc.add(LoadAllMatkul());
    }
  }

  bool _isSelected(String id) => _selectedMatkuls.contains(id);

  void _toggleSelect(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedMatkuls.remove('all');
        _selectedMatkuls.add(id);
      } else {
        _selectedMatkuls.remove(id);
        if (_selectedMatkuls.isEmpty) _selectedMatkuls.add('all');
      }
    });
  }

  void _selectAll(bool selected) {
    setState(() {
      if (selected) {
        _selectedMatkuls
          ..clear()
          ..add('all');
      } else {
        _selectedMatkuls.remove('all');
        if (_selectedMatkuls.isEmpty) _selectedMatkuls.add('all');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text("Filter Note", style: theme.textTheme.bodyLarge),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text("Matkul", style: theme.textTheme.bodyMedium),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: BlocBuilder<MatkulBloc, MatkulState>(
              builder: (context, state) {
                List<Matkul> matkuls = state.matkuls;

                return Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text("All"),
                      selected: _isSelected('all'),
                      onSelected: (selected) {
                        _selectAll(selected);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    ...matkuls.map((type) {
                      return FilterChip(
                        label: Text(type.nameAbbreviation),
                        selected: _isSelected(type.id),
                        onSelected: (selected) {
                          _toggleSelect(type.id, selected);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                    FilterChip(
                      label: const Text("Umum"),
                      selected: _isSelected('umum'),
                      onSelected: (selected) {
                        _toggleSelect('umum', selected);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedMatkuls = {'all'};
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final value = _selectedMatkuls.contains("all")
                          ? 'all'
                          : _selectedMatkuls.join(',');
                      context.read<NoteBloc>().add(FilterNotesByMatkul(value));
                      context.pop();
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
