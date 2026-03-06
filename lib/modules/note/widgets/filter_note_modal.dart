import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controller.dart';
import 'package:jaku/modules/note/controller/note_controllers.dart';
import 'package:jaku/data/entities/matkul.dart';

class FilterNoteModal extends StatefulWidget {
  const FilterNoteModal({super.key});

  @override
  State<FilterNoteModal> createState() => _FilterNoteModalState();
}

class _FilterNoteModalState extends State<FilterNoteModal> {
  // final matkulC = Get.find<MatkulController>();
  // final noteC = Get.find<NoteControllers>();

  // // State variables for filter selections
  // Set<String> _selectedMatkuls = {};

  // List<Matkul> get deviceTypesList {
  //   return [...matkulC.allMatkul];
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   final current = noteC.filterMatkulId.value;
  //   if (current.isEmpty || current == 'all') {
  //     _selectedMatkuls = {'all'};
  //   } else {
  //     _selectedMatkuls = current
  //         .split(',')
  //         .map((e) => e.trim())
  //         .where((element) => element.isNotEmpty)
  //         .toSet();
  //     if (_selectedMatkuls.isEmpty) _selectedMatkuls = {'all'};
  //   }
  //   print("filtered matkul id: $_selectedMatkuls");
  // }

  // bool _isSelected(String id) => _selectedMatkuls.contains(id);

  // void _toggleSelect(String id, bool selected) {
  //   setState(() {
  //     if (selected) {
  //       // selecting any specific matkul: remove 'all'
  //       _selectedMatkuls.remove('all');
  //       _selectedMatkuls.add(id);
  //     } else {
  //       _selectedMatkuls.remove(id);
  //       // if nothing remains selected, fallback to 'all'
  //       if (_selectedMatkuls.isEmpty) _selectedMatkuls.add('all');
  //     }
  //   });
  // }

  // void _selectAll(bool selected) {
  //   setState(() {
  //     if (selected) {
  //       _selectedMatkuls
  //         ..clear()
  //         ..add('all');
  //     } else {
  //       // unselecting 'all' -> default to empty (then you may want to pick one)
  //       _selectedMatkuls.remove('all');
  //       if (_selectedMatkuls.isEmpty) _selectedMatkuls.add('all');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Header with close button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text("Filter Note", style: theme.textTheme.bodyLarge),
          ),

          const Divider(),

          // Device Type Filter section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text("Matkul", style: theme.textTheme.bodyMedium),
          ),

          // Device type chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Wrap(
              spacing: 8,
              children: [
                // FilterChip(
                //   label: const Text("All"),
                //   selected: _isSelected('all'),
                //   onSelected: (selected) {
                //     _selectAll(selected);
                //   },
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                // ),
                // ...deviceTypesList.map((type) {
                //   return FilterChip(
                //     label: Text(type.nameAbbreviation),
                //     selected: _isSelected(type.id!),
                //     onSelected: (selected) {
                //       _toggleSelect(type.id!, selected);
                //     },
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   );
                // }),
                FilterChip(
                  label: const Text("Umum"),

                  // selected: _isSelected('umum'),
                  onSelected: (selected) {
                    // _toggleSelect('umum', selected);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),

          // Apply and Reset buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // setState(() {
                      //   _selectedMatkuls = {'all'};
                      // });
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // final value = _selectedMatkuls.contains("all")
                      //     ? 'all'
                      //     : _selectedMatkuls.join(',');
                      // noteC.filterMatkulId.value = value;
                      // noteC.filterByMatkul();
                      // Get.back();
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
