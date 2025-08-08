import 'package:flutter/material.dart';

class FilterNoteModal extends StatefulWidget {
  final String? initialDeviceType;
  const FilterNoteModal({
    super.key,
    this.initialDeviceType,
  });

  @override
  State<FilterNoteModal> createState() => _FilterNoteModalState();
}

class _FilterNoteModalState extends State<FilterNoteModal> {
  // State variables for filter selections

  String _selectedDeviceType = 'All';
  bool _showActiveOnly = false;

  List<String> get deviceTypesList {
    return ["All", "IMK", "PBO", "Basis Data", "Umum"];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDeviceType = widget.initialDeviceType ?? 'All';
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
              children: deviceTypesList.map((type) {
                return FilterChip(
                  label: Text(type),
                  selected: _selectedDeviceType == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDeviceType = selected ? type : 'All';
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
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
                        _selectedDeviceType = 'All';
                        _showActiveOnly = false;
                      });
                    },
                    child: Text(
                      'Reset',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // Return the filter selections to the calling screen
                      Navigator.of(context).pop({
                        'deviceType': _selectedDeviceType,
                        'activeOnly': _showActiveOnly,
                      });
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
