import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SelectMatkulWidget extends StatefulWidget {
  const SelectMatkulWidget({super.key, this.selectedMatkul});
  final String? selectedMatkul;

  @override
  State<SelectMatkulWidget> createState() => _SelectMatkulWidgetState();
}

class _SelectMatkulWidgetState extends State<SelectMatkulWidget> {
  List<String> matkulList = ["IMK", "PBO", "Basis Data"];
  String? selectedMatkul;

  @override
  void initState() {
    super.initState();
    selectedMatkul = widget.selectedMatkul;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    bool isMatkulSelected =
        selectedMatkul != null && selectedMatkul!.isNotEmpty;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: !isMatkulSelected
              ? EdgeInsets.symmetric(horizontal: 12, vertical: 8)
              : EdgeInsets.only(left: 12, right: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isMatkulSelected ? LucideIcons.bookMarked : LucideIcons.list,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isMatkulSelected ? selectedMatkul! : "Select matkul",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              if (isMatkulSelected) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: theme.colorScheme.primary,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      selectedMatkul = '';
                    });
                  },
                  tooltip: 'Reset matkul',
                ),
              ],
            ],
          ),
        ),
        items: matkulList
            .map(
              (item) => DropdownMenuItem<Object>(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedMatkul = value as String?;
          });
        },
        dropdownStyleData: DropdownStyleData(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
