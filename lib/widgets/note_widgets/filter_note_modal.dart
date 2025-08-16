import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers/jadwal_kuliah_c.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/models/matkul.dart';

class FilterNoteModal extends StatefulWidget {
  const FilterNoteModal({super.key});

  @override
  State<FilterNoteModal> createState() => _FilterNoteModalState();
}

class _FilterNoteModalState extends State<FilterNoteModal> {
  final matkulC = Get.find<JadwalkuliahC>();
  final noteC = Get.find<NoteControllers>();

  // State variables for filter selections
  String _selectedDeviceType = 'all';

  List<Matkul> get deviceTypesList {
    return [...matkulC.allMatkul];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDeviceType = noteC.filterMatkulId.value;
    print("filtered device id: $_selectedDeviceType");
  }

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
                FilterChip(
                  label: Text("All"),
                  selected: _selectedDeviceType == "all",
                  onSelected: (selected) {
                    setState(() {
                      _selectedDeviceType = 'all';
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                ...deviceTypesList.map((type) {
                  return FilterChip(
                    label: Text(type.abbreviation!),
                    selected: _selectedDeviceType == type.id,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDeviceType = selected ? type.id! : 'all';
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
                FilterChip(
                  label: Text("Umum"),
                  selected: _selectedDeviceType == "umum",
                  onSelected: (selected) {
                    setState(() {
                      _selectedDeviceType = 'umum';
                    });
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
                      setState(() {
                        _selectedDeviceType = 'all';
                      });
                    },
                    child: Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // Return the filter selections to the calling screen
                      // Navigator.of(
                      //   context,
                      // ).pop({'deviceType': _selectedDeviceType});
                      noteC.filterMatkulId.value = _selectedDeviceType;
                      noteC.filterByMatkul();
                      Get.back();
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
