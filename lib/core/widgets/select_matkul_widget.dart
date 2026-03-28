import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SelectMatkulWidget extends StatefulWidget {
  const SelectMatkulWidget({super.key, this.matkulId, this.onChanged});

  final String? matkulId;
  final ValueChanged<String?>? onChanged;

  @override
  State<SelectMatkulWidget> createState() => _SelectMatkulWidgetState();
}

class _SelectMatkulWidgetState extends State<SelectMatkulWidget> {
  @override
  void initState() {
    super.initState();
    final matkulBloc = context.read<MatkulBloc>();
    if (matkulBloc.state.status == MatkulStatus.initial) {
      matkulBloc.add(LoadAllMatkul());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MatkulBloc, MatkulState>(
      builder: (context, state) {
        List<Matkul> matkulList = state.matkuls;

        Matkul? selectedMatkul;
        if (widget.matkulId != null && widget.matkulId!.isNotEmpty) {
          selectedMatkul = matkulList
              .where((m) => m.id == widget.matkulId)
              .firstOrNull;
        }

        bool isMatkulSelected = selectedMatkul != null;

        return DropdownButtonHideUnderline(
          child: DropdownButton2<Matkul>(
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
                    isMatkulSelected
                        ? LucideIcons.bookMarked
                        : LucideIcons.list,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isMatkulSelected
                        ? selectedMatkul.nameAbbreviation
                        : "Select matkul",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (isMatkulSelected) ...[
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: theme.colorScheme.primary,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (widget.onChanged != null) {
                          widget.onChanged!(null);
                        }
                      },
                      tooltip: 'Reset matkul',
                    ),
                  ],
                ],
              ),
            ),
            items: matkulList
                .map(
                  (item) =>
                      DropdownItem<Matkul>(value: item, child: Text(item.name)),
                )
                .toList(),
            onChanged: (value) {
              if (widget.onChanged != null && value != null) {
                widget.onChanged!(value.id);
              }
            },
            dropdownSeparator: DropdownSeparator(
              height: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              width: 200,
              maxHeight: 300,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}
