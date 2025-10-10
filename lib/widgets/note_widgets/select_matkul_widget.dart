import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/matkul_controllers.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/models/matkul.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SelectMatkulWidget extends StatefulWidget {
  const SelectMatkulWidget({super.key, this.matkulId});
  final String? matkulId;

  @override
  State<SelectMatkulWidget> createState() => _SelectMatkulWidgetState();
}

class _SelectMatkulWidgetState extends State<SelectMatkulWidget> {
  final matkulC = Get.find<MatkulController>();
  Matkul? selectedMatkul;

  @override
  void initState() {
    super.initState();
    if (widget.matkulId != null && widget.matkulId != "") {
      selectedMatkul = matkulC.selectMatkulById(widget.matkulId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteC = Get.find<NoteControllers>();
    final List<Matkul> matkulList = matkulC.allMatkul;

    bool isMatkulSelected = selectedMatkul != null;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: !isMatkulSelected
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
              : const EdgeInsets.only(left: 12, right: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isMatkulSelected ? LucideIcons.bookMarked : LucideIcons.list,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isMatkulSelected
                    ? selectedMatkul!.abbreviation
                    : "Select matkul",
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
                      selectedMatkul = null;
                      noteC.matkulC.value = null;
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
                child: Text(item.abbreviation),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedMatkul = value as Matkul?;
            noteC.matkulC.value = value!.id;
          });
        },
        dropdownStyleData: DropdownStyleData(
          width: 150,
          maxHeight: 250,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
