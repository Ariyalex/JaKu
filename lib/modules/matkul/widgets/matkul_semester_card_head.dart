import 'package:flutter/material.dart';

class MatkulSemesterCardHead extends StatelessWidget {
  const MatkulSemesterCardHead({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onToggle,
  });

  final String title;
  final bool isSelected;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.tertiary
            : theme.colorScheme.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          Switch(value: isSelected, onChanged: onToggle),
        ],
      ),
    );
  }
}
