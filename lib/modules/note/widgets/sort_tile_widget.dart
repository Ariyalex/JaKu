import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SortTileWidget extends StatefulWidget {
  const SortTileWidget({
    super.key,
    required this.isActive,
    this.isSortable = true,
    required this.title,
    required this.onTap,
    this.isAsce = true,
  });
  final bool isActive;
  final bool isSortable;
  final String title;
  final VoidCallback onTap;
  final bool isAsce;

  @override
  State<SortTileWidget> createState() => _SortTileWidgetState();
}

class _SortTileWidgetState extends State<SortTileWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isSortable) {
      return widget.isActive
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                onTap: widget.onTap,
                leading: Icon(
                  widget.isAsce ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                ),
                selected: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                selectedTileColor: theme.focusColor,
                title: Text(widget.title),
              ),
            )
          : ListTile(onTap: widget.onTap, title: Text(widget.title));
    } else {
      return widget.isActive
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                onTap: widget.onTap,
                leading: const Icon(LucideIcons.check),
                selected: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                selectedTileColor: theme.focusColor,
                title: Text(widget.title),
              ),
            )
          : ListTile(onTap: widget.onTap, title: Text(widget.title));
    }
  }
}
