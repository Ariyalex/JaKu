import 'package:flutter/widgets.dart';

class TutorialStep {
  final String title;
  final String description;
  final IconData? icon;

  TutorialStep({
    required this.title,
    required this.description,
    this.icon,
  });
}
